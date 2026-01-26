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
  final int ayahNumber;
  final double scrollOffset;

  ReadingProgressLoaded({
    required this.surahId,
    required this.surahName,
    this.ayahNumber = 0,
    required this.scrollOffset,
  });

  List<Object?> get props => [surahId, surahName, ayahNumber, scrollOffset];
}
