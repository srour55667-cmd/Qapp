import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qapp/data/cubit/reading_progress_state.dart';
import 'package:qapp/services/last_read_service.dart';
import 'package:qapp/model/surah_model.dart';

/// Cubit for managing reading progress state
class ReadingProgressCubit extends Cubit<ReadingProgressState> {
  List<SurahModel>? _suwarList;
  Timer? _debounceTimer;

  ReadingProgressCubit({List<SurahModel>? suwarList})
    : _suwarList = suwarList,
      super(ReadingProgressInitial());

  /// Update the internal suwar list for name resolution
  void updateSuwarList(List<SurahModel> list) {
    _suwarList = list;
    // If we're already loaded, refresh the name
    if (state is ReadingProgressLoaded) {
      loadProgress();
    }
  }

  /// Load saved progress from storage
  Future<void> loadProgress({List<SurahModel>? suwarList}) async {
    if (suwarList != null) _suwarList = suwarList;

    emit(ReadingProgressLoading());

    try {
      final surahId = await LastReadService.getLastSurahId();

      if (surahId == null) {
        emit(ReadingProgressEmpty());
        return;
      }

      final scrollOffset = await LastReadService.getLastScrollOffset();

      // Find surah name from list if available
      String surahName = 'سورة';
      if (_suwarList != null) {
        try {
          final surah = _suwarList!.firstWhere((s) => s.id == surahId);
          surahName = surah.nameAr;
        } catch (e) {
          // Surah not found in list, use default
        }
      }

      emit(
        ReadingProgressLoaded(
          surahId: surahId,
          surahName: surahName,
          scrollOffset: scrollOffset,
        ),
      );
    } catch (e) {
      print('Error loading reading progress: $e');
      emit(ReadingProgressEmpty());
    }
  }

  /// Update reading progress with debouncing (2 seconds)
  void updateProgress(int surahId, String surahName, double scrollOffset) {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Set new timer for debounced save
    _debounceTimer = Timer(const Duration(seconds: 2), () async {
      print(
        'DEBUG: Cubit saving progress - Surah: $surahId, Offset: $scrollOffset',
      );

      // Save to storage
      await LastReadService.savePosition(surahId, scrollOffset);

      // Emit new state
      emit(
        ReadingProgressLoaded(
          surahId: surahId,
          surahName: surahName,
          scrollOffset: scrollOffset,
        ),
      );
    });
  }

  /// Update progress immediately (no debounce) - for dispose/critical saves
  Future<void> updateProgressImmediate(
    int surahId,
    String surahName,
    double scrollOffset,
  ) async {
    _debounceTimer?.cancel();

    print(
      'DEBUG: Cubit immediate save - Surah: $surahId, Offset: $scrollOffset',
    );

    await LastReadService.savePosition(surahId, scrollOffset);

    emit(
      ReadingProgressLoaded(
        surahId: surahId,
        surahName: surahName,
        scrollOffset: scrollOffset,
      ),
    );
  }

  /// Clear saved progress
  Future<void> clearProgress() async {
    await LastReadService.clearPosition();
    emit(ReadingProgressEmpty());
  }

  @override
  Future<void> close() {
    _debounceTimer?.cancel();
    return super.close();
  }
}
