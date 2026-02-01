import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/core/theme/app_spacing.dart';
import 'package:qapp/core/theme/app_typography.dart';
import 'package:qapp/data/cubit/reading_progress_cubit.dart';
import 'package:quran/quran.dart' as quran;
import 'package:qapp/data/repository/quran_repository.dart';
import 'package:qapp/screen/surah/widgets/ayah_action_sheet.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class SurahTextPage extends StatefulWidget {
  final int surahId;
  final String surahName;
  final int initialAyahNumber;

  const SurahTextPage({
    super.key,
    required this.surahId,
    required this.surahName,
    this.initialAyahNumber = 0,
  });

  @override
  State<SurahTextPage> createState() => _SurahTextPageState();
}

class _SurahTextPageState extends State<SurahTextPage> {
  // State for settings
  double _fontSize = 24.0;
  bool _showBasmala = true;
  List<String> _verses = [];
  bool _isLoading = true;

  // Qiyam Al-Layl (Auto-Scroll) State
  bool _isAutoScrollEnabled = false;
  double _scrollSpeed = 1.0; // Pixels per tick
  Timer? _autoScrollTimer;
  final ItemScrollController _itemScrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    // Surah 1 and 9 don't show Basmala usually in the same way.
    _showBasmala = widget.surahId != 9 && widget.surahId != 1;

    _loadData();

    // Save position immediately when page opens via Cubit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ReadingProgressCubit>().updateProgressImmediate(
          widget.surahId,
          widget.surahName,
          0.0,
          widget.initialAyahNumber,
        );
      }
    });

    // Listen to positions to update progress
    _itemPositionsListener.itemPositions.addListener(_onScroll);
  }

  Future<void> _loadData() async {
    final verses = await QuranRepository.getSurahAyat(widget.surahId);
    if (mounted) {
      setState(() {
        _verses = verses;
        _isLoading = false;

        // Jump to initial ayah if set
        if (widget.initialAyahNumber > 0) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _jumpToAyah(widget.initialAyahNumber);
          });
        }
      });
    }
  }

  void _onScroll() {
    final positions = _itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) return;

    // Find the first visible item
    final first = positions.reduce(
      (min, pos) => pos.index < min.index ? pos : min,
    );
    final index = first.index;

    // Calculate actual Ayah number
    // Index 0 might be Basmala:
    // If showBasmala: Item 0 is Basmala. Item 1 is Ayah 1.
    // So Ayah Index = Item Index.
    // Wait, if Index = 1 (Ayah 1), then Ayah Number = 1.
    // If Index = 0 (Basmala), Ayah Number = 0 (Internal).
    // If !showBasmala: Item 0 is Ayah 1. Ayah Number = Index + 1.

    int ayahNum = 0;
    if (_showBasmala) {
      if (index > 0) ayahNum = index; // Item 1 is Ayah 1
    } else {
      ayahNum = index + 1; // Item 0 is Ayah 1
    }

    if (ayahNum > 0) {
      context.read<ReadingProgressCubit>().updateProgress(
        widget.surahId,
        widget.surahName,
        0.0, // We don't strictly need pixel offset for ItemScroll
        ayahNum,
      );
    }
  }

  void _jumpToAyah(int ayahNumber) {
    if (ayahNumber <= 0) return;

    int index = 0;
    if (_showBasmala) {
      index = ayahNumber; // Ayah 1 is Item 1
    } else {
      index = ayahNumber - 1; // Ayah 1 is Item 0
    }

    // Safety check
    if (index < 0) index = 0;

    _itemScrollController.jumpTo(index: index);
  }

  @override
  void dispose() {
    _stopAutoScroll();
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _startAutoScroll() {
    _stopAutoScroll();

    if (!_isAutoScrollEnabled) return;

    // Use a periodic timer for continuous smooth scrolling
    // 32ms is approx 30fps
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 32), (
      timer,
    ) {
      if (!mounted || !_isAutoScrollEnabled) {
        timer.cancel();
        return;
      }

      final positions = _itemPositionsListener.itemPositions.value;
      if (positions.isEmpty) return;

      // Find the top-most visible item to anchor scrolling
      final sorted = positions.toList()
        ..sort((a, b) => a.index.compareTo(b.index));
      final currentItem = sorted.first;

      // Calculate scroll step based on speed
      // Base speed: 5% of screen height per second
      // Tick duration: 0.032s
      final double baseSpeed = 0.05;
      final double step = baseSpeed * _scrollSpeed * 0.032;

      // Decrease alignment to move item UP (scroll DOWN)
      // itemLeadingEdge is 0.0 at top. Negative means above top.
      double targetAlignment = currentItem.itemLeadingEdge - step;

      _itemScrollController.jumpTo(
        index: currentItem.index,
        alignment: targetAlignment,
      );

      // Check for End of Surah
      // If the last item is visible and fully within viewport (trailing edge <= 1.0)
      final total = _showBasmala ? _verses.length + 1 : _verses.length;
      if (currentItem.index >= total - 1 &&
          currentItem.itemTrailingEdge <= 1.0) {
        _stopAutoScroll();
        setState(() => _isAutoScrollEnabled = false);
      }
    });
  }

  void _stopAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = null;
  }

  void _toggleAutoScroll(bool enabled) {
    setState(() {
      _isAutoScrollEnabled = enabled;
      if (enabled) {
        _startAutoScroll();
      } else {
        _stopAutoScroll();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final theme = Theme.of(context);
    final count = _verses.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.surahName),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.text_fields),
            onPressed: _showSettingsSheet,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Main Scroll View
          ScrollablePositionedList.builder(
            itemCount: _showBasmala ? count + 1 : count,
            itemScrollController: _itemScrollController,
            itemPositionsListener: _itemPositionsListener,
            padding: const EdgeInsets.only(bottom: 150), // Padding for controls
            itemBuilder: (context, listIndex) {
              if (_showBasmala && listIndex == 0) {
                return Padding(
                  padding: const EdgeInsets.all(AppSpacing.screenPadding),
                  child: Text(
                    quran.basmala,
                    style: AppTypography.quranText(
                      fontSize: _fontSize,
                      color: theme.primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              // Ayah Logic
              final verseIndex = _showBasmala ? listIndex - 1 : listIndex;
              if (verseIndex < 0 || verseIndex >= _verses.length) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPadding,
                  vertical: AppSpacing.sm,
                ),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.cardPadding),
                  decoration: BoxDecoration(
                    color: theme.cardTheme.color,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      _showAyahOptions(verseIndex + 1, _verses[verseIndex]);
                    },
                    borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _verses[verseIndex],
                          style: AppTypography.quranText(
                            fontSize: _fontSize,
                            color: theme.textTheme.bodyLarge?.color,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Auto-Scroll Controller Overlay
          if (_isAutoScrollEnabled)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: _buildScrollControls(theme),
            ),
        ],
      ),
    );
  }

  Widget _buildScrollControls(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Play/Pause
          IconButton(
            icon: Icon(
              _isAutoScrollEnabled
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
            ),
            color: theme.primaryColor,
            iconSize: 32,
            onPressed: () {
              _toggleAutoScroll(!_isAutoScrollEnabled);
            },
          ),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "السرعة: ${_scrollSpeed.toStringAsFixed(1)}x",
                  style: theme.textTheme.labelSmall,
                ),
                Slider(
                  value: _scrollSpeed,
                  min: 0.5,
                  max: 5.0,
                  divisions: 9,
                  onChanged: (val) {
                    setState(() => _scrollSpeed = val);
                    if (_isAutoScrollEnabled) _startAutoScroll();
                  },
                ),
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.close_rounded),
            color: Colors.grey,
            onPressed: () {
              _stopAutoScroll();
              setState(() {
                _isAutoScrollEnabled = false;
              });
            },
          ),
        ],
      ),
    );
  }

  void _showSettingsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "إعدادات القراءة",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    "حجم الخط",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Slider(
                    value: _fontSize,
                    min: 18,
                    max: 40,
                    divisions: 11,
                    label: _fontSize.round().toString(),
                    onChanged: (val) {
                      setSheetState(() {
                        _fontSize = val;
                      });
                      setState(() {
                        _fontSize = val;
                      });
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),

                  // Qiyam Al-Layl Section
                  SwitchListTile(
                    title: Text(
                      "وضع قيام الليل (تمرير تلقائي)",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: const Text(
                      "تمرير الصفحات تلقائياً للقراءة دون لمس",
                    ),
                    value: _isAutoScrollEnabled,
                    activeColor: Theme.of(context).primaryColor,
                    onChanged: (val) {
                      setSheetState(() {
                        _toggleAutoScroll(val);
                      });
                    },
                  ),

                  if (_isAutoScrollEnabled) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Text(
                      "سرعة التمرير: ${_scrollSpeed.toStringAsFixed(1)}x",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Slider(
                      value: _scrollSpeed,
                      min: 0.5,
                      max: 5.0,
                      divisions: 9,
                      label: "${_scrollSpeed}x",
                      onChanged: (val) {
                        setSheetState(() {
                          _scrollSpeed = val;
                        });
                        setState(() {
                          _scrollSpeed = val;
                        });
                        // Restart scroll to apply new speed immediately if active
                        if (_isAutoScrollEnabled) {
                          _startAutoScroll();
                        }
                      },
                    ),
                  ],
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAyahOptions(int ayahNumber, String ayahText) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => AyahActionSheet(
        surahId: widget.surahId,
        surahName: widget.surahName,
        ayahNumber: ayahNumber,
        ayahText: ayahText,
        onStopHere: () {
          // Manual stop save
          context.read<ReadingProgressCubit>().updateProgressImmediate(
            widget.surahId,
            widget.surahName,
            0.0,
            ayahNumber,
          );
        },
      ),
    );
  }
}
