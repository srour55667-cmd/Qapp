/// Base state for reading progress
abstract class ReadingProgressState {}

/// Initial state when cubit is created
class ReadingProgressInitial extends ReadingProgressState {}

/// Loading state while fetching saved progress
class ReadingProgressLoading extends ReadingProgressState {}

/// Empty state when no progress has been saved
class ReadingProgressEmpty extends ReadingProgressState {}

/// Loaded state with actual reading progress data
class ReadingProgressLoaded extends ReadingProgressState {
  final int surahId;
  final String surahName;
  final double scrollOffset;

  ReadingProgressLoaded({
    required this.surahId,
    required this.surahName,
    required this.scrollOffset,
  });
}
