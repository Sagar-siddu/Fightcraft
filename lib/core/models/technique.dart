/// Domain enums and the Technique model (PRD sections 6.1 and 6.2).
///
/// Pure Dart. Every directional move is its own technique with its own ID
/// (`slip_left` and `slip_right` are different entries). Direction is data on
/// the technique, never inferred from a display string (PRD 6.3).
library;

enum SkillLevel { beginner, intermediate, advanced }

enum TechniqueCategory {
  punch,
  slip,
  roll,
  pullLean,
  pivot,
  step,
  exitReset,
  defence,
  comboAction,
}

enum Direction { left, right, forward, back }

class Technique {
  const Technique({
    required this.id,
    required this.label,
    required this.category,
    required this.level,
    this.direction,
  });

  /// Stable identifier, e.g. `slip_left`. Never changes once shipped.
  final String id;

  /// Spoken and displayed phrase, e.g. "slip left". Can be reworded without
  /// touching selector logic.
  final String label;

  final TechniqueCategory category;

  /// Lowest skill level at which this technique may be called.
  final SkillLevel level;

  /// Null for non-directional techniques (jab, cross, ...).
  final Direction? direction;
}
