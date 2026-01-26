import 'package:flutter/material.dart';
import 'package:qapp/core/theme/app_spacing.dart';
import 'package:qapp/screen/tafseer/TafsirResultPage.dart';
import 'package:qapp/services/ayah_audio_service.dart';

class AyahActionSheet extends StatefulWidget {
  final int surahId;
  final String surahName;
  final int ayahNumber;
  final String ayahText;
  final VoidCallback onStopHere;

  const AyahActionSheet({
    super.key,
    required this.surahId,
    required this.surahName,
    required this.ayahNumber,
    required this.ayahText,
    required this.onStopHere,
  });

  @override
  State<AyahActionSheet> createState() => _AyahActionSheetState();
}

class _AyahActionSheetState extends State<AyahActionSheet> {
  bool _isPlaying = false;
  final _audioService = AyahAudioService();

  @override
  void initState() {
    super.initState();
    _isPlaying = _audioService.isPlaying;
    _audioService.onStateChanged = (isPlaying) {
      if (mounted) {
        setState(() {
          _isPlaying = isPlaying;
        });
      }
    };
  }

  @override
  void dispose() {
    // We don't stop audio when closing sheet unless playing a different ayah?
    // User requirement: "stop audio when leaving the screen" - handled in SurahTextPage or AudioService.
    super.dispose();
  }

  void _handlePlay() async {
    if (_isPlaying) {
      await _audioService.pause();
    } else {
      await _audioService.playAyah(widget.surahId, widget.ayahNumber);
    }
  }

  void _handleTafsir() {
    Navigator.pop(context); // Close sheet first
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TafsirResultPage(
          surahNumber: widget.surahId,
          surahName: widget.surahName,
          tafsirCode: 'ar-tafsir-muyassar', // Default or fetch from pref
          initialAyahNumber: widget.ayahNumber,
        ),
      ),
    );
  }

  void _handleInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('معلومات الآية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('سورة: ${widget.surahName}'),
            const SizedBox(height: 8),
            Text('رقم السورة: ${widget.surahId}'),
            const SizedBox(height: 8),
            Text('رقم الآية: ${widget.ayahNumber}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('حسناً'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.cardPadding),
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Text(
            'الآية ${widget.ayahNumber} - ${widget.surahName}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          _buildActionItem(
            icon: _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
            label: _isPlaying ? 'إيقاف مؤقت' : 'سماع الآية',
            color: theme.primaryColor,
            onTap: _handlePlay,
          ),

          _buildActionItem(
            icon: Icons.menu_book_rounded,
            label: 'التفسير',
            onTap: _handleTafsir,
          ),

          _buildActionItem(
            icon: Icons.info_outline_rounded,
            label: 'معلومات الآية',
            onTap: _handleInfo,
          ),

          _buildActionItem(
            icon: Icons.bookmark_add_rounded,
            label: 'التوقف هنا',
            color: Colors.orange,
            onTap: () {
              widget.onStopHere();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('تم حفظ آخر توقف'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),

          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (color ?? theme.iconTheme.color)?.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color ?? theme.iconTheme.color),
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}
