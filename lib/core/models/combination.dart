import 'technique.dart';

/// Subset of the PRD 6.1 combination schema needed for Phase 0.
/// Phase 2 adds name, tags, estimated duration, enabled flag and timestamps.
enum Sport { boxing }

enum CombinationSource { builtIn, custom }

class Combination {
  const Combination({
    required this.id,
    required this.skillLevel,
    required this.difficulty,
    required this.techniqueIds,
    this.sport = Sport.boxing,
    this.source = CombinationSource.builtIn,
  });

  final String id;
  final Sport sport;
  final CombinationSource source;

  /// Maximum recommended user level.
  final SkillLevel skillLevel;

  /// 1-5 technique/sequence complexity.
  final int difficulty;

  /// Ordered technique IDs. Speech and display are both derived from these.
  final List<String> techniqueIds;
}
