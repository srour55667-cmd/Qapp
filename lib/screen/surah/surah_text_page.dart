import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/core/theme/app_spacing.dart';
import 'package:qapp/core/theme/app_typography.dart';
import 'package:qapp/core/widgets/custom_app_bar.dart';
import 'package:qapp/data/cubit/reading_progress_cubit.dart';
import 'package:qapp/data/cubit/reading_progress_state.dart';
import 'package:quran/quran.dart' as quran;
import 'package:qapp/data/repository/quran_repository.dart';

class SurahTextPage extends StatefulWidget {
  final int surahId;
  final String surahName;

  const SurahTextPage({
    super.key,
    required this.surahId,
    required this.surahName,
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
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
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
        );
      }
    });

    _loadLastPosition();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadData() async {
    final verses = await QuranRepository.getSurahAyat(widget.surahId);
    if (mounted) {
      setState(() {
        _verses = verses;
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      context.read<ReadingProgressCubit>().updateProgress(
        widget.surahId,
        widget.surahName,
        _scrollController.offset,
      );
    }
  }

  Future<void> _loadLastPosition() async {
    final lastPos = context.read<ReadingProgressCubit>().state;
    if (lastPos is ReadingProgressLoaded &&
        lastPos.surahId == widget.surahId &&
        _scrollController.hasClients) {
      final offset = lastPos.scrollOffset;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients && offset > 0) {
          _scrollController.jumpTo(offset);
        }
      });
    }
  }

  @override
  void dispose() {
    _stopAutoScroll();
    // Save position one final time immediately via Cubit
    if (_scrollController.hasClients) {
      context.read<ReadingProgressCubit>().updateProgressImmediate(
        widget.surahId,
        widget.surahName,
        _scrollController.offset,
      );
    }
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _stopAutoScroll(); // Clear existing timer
    // ~60fps target: 16ms
    _autoScrollTimer = Timer.periodic(const Duration(milliseconds: 16), (
      timer,
    ) {
      if (!_scrollController.hasClients) return;

      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;

      if (currentScroll >= maxScroll) {
        _stopAutoScroll();
        setState(() => _isAutoScrollEnabled = false);
        return;
      }

      _scrollController.jumpTo(currentScroll + _scrollSpeed);
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
      body: Stack(
        children: [
          // Main Scroll View
          Listener(
            onPointerDown: (_) {
              // Pause on touch
              if (_isAutoScrollEnabled) {
                _stopAutoScroll();
                setState(() => _isAutoScrollEnabled = false);
              }
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomSliverAppBar(
                  title: Text(
                    widget.surahName,
                  ), // Removed "Surah" prefix per some designs, keeping it clean
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.text_fields),
                      onPressed: _showSettingsSheet,
                    ),
                  ],
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      children: [
                        // Basmala Header
                        if (_showBasmala) ...[
                          Text(
                            quran.basmala,
                            style: AppTypography.quranText(
                              fontSize: _fontSize,
                              color: theme.primaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ],
                    ),
                  ),
                ),

                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.screenPadding,
                        vertical: AppSpacing.sm,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(AppSpacing.cardPadding),
                        decoration: BoxDecoration(
                          color: theme.cardTheme.color,
                          borderRadius: BorderRadius.circular(
                            AppSpacing.radiusMd,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              _verses[index],
                              style: AppTypography.quranText(
                                fontSize: _fontSize,
                                color: theme.textTheme.bodyLarge?.color,
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                    );
                  }, childCount: count),
                ),

                const SliverPadding(
                  padding: EdgeInsets.only(bottom: 120),
                ), // Extra padding for controls
              ],
            ),
          ),

          // Auto-Scroll Controller Overlay
          if (_isAutoScrollEnabled ||
              _scrollController.hasClients &&
                  _scrollController.offset > 0 &&
                  _speedControlVisible)
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

  bool _speedControlVisible = false;

  Widget _buildScrollControls(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardColor.withOpacity(0.95),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
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
                _speedControlVisible = false;
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
}
