import '../../core/models/combination.dart';
import '../../core/models/technique.dart';

/// Lookup over the technique catalogue. Single source of truth for the spoken
/// phrase, so speech, on-screen text and logs can never disagree on direction.
class TechniqueCatalogue {
  TechniqueCatalogue(List<Technique> techniques)
      : assert(
          techniques.map((t) => t.id).toSet().length == techniques.length,
          'Duplicate technique id in catalogue',
        ),
        _byId = {for (final t in techniques) t.id: t};

  final Map<String, Technique> _byId;

  Iterable<Technique> get all => _byId.values;

  Technique byId(String id) {
    final t = _byId[id];
    if (t == null) throw ArgumentError('Unknown technique id: $id');
    return t;
  }

  List<Technique> resolve(List<String> ids) =>
      ids.map(byId).toList(growable: false);

  /// What the TTS engine says, e.g. "jab, cross, slip left, cross".
  String spoken(List<String> ids) => resolve(ids).map((t) => t.label).join(', ');

  /// Same text, first letter capitalised, for the big on-screen callout.
  String display(List<String> ids) {
    final s = spoken(ids);
    return s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
  }
}

const _b = SkillLevel.beginner;
const _i = SkillLevel.intermediate;
const _a = SkillLevel.advanced;

/// Small catalogue for the Phase 0 spike. Phase 2 replaces this with
/// assets/data/techniques.json.
final TechniqueCatalogue spikeCatalogue = TechniqueCatalogue(const [
  Technique(id: 'jab', label: 'jab', category: TechniqueCategory.punch, level: _b),
  Technique(id: 'cross', label: 'cross', category: TechniqueCategory.punch, level: _b),
  Technique(id: 'double_jab', label: 'double jab', category: TechniqueCategory.comboAction, level: _b),
  Technique(id: 'lead_hook', label: 'lead hook', category: TechniqueCategory.punch, level: _i),
  Technique(id: 'rear_hook', label: 'rear hook', category: TechniqueCategory.punch, level: _i),
  Technique(id: 'slip_left', label: 'slip left', category: TechniqueCategory.slip, level: _i, direction: Direction.left),
  Technique(id: 'slip_right', label: 'slip right', category: TechniqueCategory.slip, level: _i, direction: Direction.right),
  Technique(id: 'roll_left', label: 'roll left', category: TechniqueCategory.roll, level: _i, direction: Direction.left),
  Technique(id: 'roll_right', label: 'roll right', category: TechniqueCategory.roll, level: _i, direction: Direction.right),
  Technique(id: 'pivot_left', label: 'pivot left', category: TechniqueCategory.pivot, level: _i, direction: Direction.left),
  Technique(id: 'pivot_right', label: 'pivot right', category: TechniqueCategory.pivot, level: _i, direction: Direction.right),
  Technique(id: 'pull_back', label: 'pull back', category: TechniqueCategory.pullLean, level: _a, direction: Direction.back),
  Technique(id: 'exit_right', label: 'exit right', category: TechniqueCategory.exitReset, level: _a, direction: Direction.right),
]);

/// Illustrative records from PRD Appendix A plus two extras. Not reviewed seed
/// data; the real ~30 combinations arrive in Phase 2.
const List<Combination> spikeCombinations = [
  Combination(
    id: 'boxing_beg_001',
    skillLevel: SkillLevel.beginner,
    difficulty: 1,
    techniqueIds: ['jab', 'cross'],
  ),
  Combination(
    id: 'boxing_beg_002',
    skillLevel: SkillLevel.beginner,
    difficulty: 1,
    techniqueIds: ['double_jab', 'cross'],
  ),
  Combination(
    id: 'boxing_int_014',
    skillLevel: SkillLevel.intermediate,
    difficulty: 3,
    techniqueIds: ['jab', 'cross', 'slip_left', 'cross'],
  ),
  Combination(
    id: 'boxing_int_021',
    skillLevel: SkillLevel.intermediate,
    difficulty: 3,
    techniqueIds: ['jab', 'cross', 'roll_right', 'pivot_left'],
  ),
  Combination(
    id: 'boxing_int_022',
    skillLevel: SkillLevel.intermediate,
    difficulty: 3,
    techniqueIds: ['jab', 'slip_right', 'cross', 'roll_left'],
  ),
  Combination(
    id: 'boxing_int_023',
    skillLevel: SkillLevel.intermediate,
    difficulty: 3,
    techniqueIds: ['jab', 'cross', 'lead_hook', 'cross', 'pivot_right'],
  ),
  Combination(
    id: 'boxing_adv_008',
    skillLevel: SkillLevel.advanced,
    difficulty: 5,
    techniqueIds: ['double_jab', 'cross', 'pull_back', 'rear_hook', 'exit_right'],
  ),
];
