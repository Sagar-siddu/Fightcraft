import 'package:flutter_test/flutter_test.dart';
import 'package:fightcraft/core/models/technique.dart';
import 'package:fightcraft/features/combinations/technique_catalogue.dart';

void main() {
  group('directionality (PRD 6.3)', () {
    test('id suffix, direction field and spoken label always agree', () {
      for (final t in spikeCatalogue.all) {
        if (t.id.endsWith('_left')) {
          expect(t.direction, Direction.left, reason: t.id);
          expect(t.label.endsWith('left'), isTrue, reason: t.id);
        } else if (t.id.endsWith('_right')) {
          expect(t.direction, Direction.right, reason: t.id);
          expect(t.label.endsWith('right'), isTrue, reason: t.id);
        }
      }
    });

    test('slip_left and slip_right are distinct catalogue entries', () {
      final l = spikeCatalogue.byId('slip_left');
      final r = spikeCatalogue.byId('slip_right');
      expect(l.id, isNot(r.id));
      expect(l.label, 'slip left');
      expect(r.label, 'slip right');
    });

    test('spoken text preserves order and direction', () {
      expect(
        spikeCatalogue.spoken(['jab', 'cross', 'slip_left', 'cross', 'pivot_right']),
        'jab, cross, slip left, cross, pivot right',
      );
    });
  });

  group('spike combinations', () {
    test('every technique id resolves in the catalogue', () {
      for (final c in spikeCombinations) {
        expect(() => spikeCatalogue.resolve(c.techniqueIds), returnsNormally,
            reason: c.id);
      }
    });

    test('no combination needs a technique above its own skill level', () {
      for (final c in spikeCombinations) {
        for (final t in spikeCatalogue.resolve(c.techniqueIds)) {
          expect(t.level.index <= c.skillLevel.index, isTrue,
              reason: '${c.id} uses ${t.id}');
        }
      }
    });

    test('unknown technique id throws', () {
      expect(() => spikeCatalogue.byId('slip'), throwsArgumentError);
    });
  });
}
