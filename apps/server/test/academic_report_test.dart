import 'package:test/test.dart';

import '../lib/src/academic_report.dart';

void main() {
  test('média normaliza escalas, pondera pesos e distingue ausência, dispensa e zero', () {
    final rows = <Map<String, dynamic>>[
      {
        'journal': 'j',
        'stage': 'Etapa 1',
        'enrollment': 'a',
        'status': 'Lançada',
        'score': 8,
        'max_score': 10,
        'weight': 1,
      },
      {
        'journal': 'j',
        'stage': 'Etapa 1',
        'enrollment': 'a',
        'status': 'Lançada',
        'score': 60,
        'max_score': 100,
        'weight': 3,
      },
      {
        'journal': 'j',
        'stage': 'Etapa 1',
        'enrollment': 'a',
        'status': 'Ausente',
        'score': null,
        'max_score': 10,
        'weight': 9,
      },
      {
        'journal': 'j',
        'stage': 'Etapa 1',
        'enrollment': 'a',
        'status': 'Dispensada',
        'score': null,
        'max_score': 10,
        'weight': 9,
      },
      {
        'journal': 'j',
        'stage': 'Etapa 2',
        'enrollment': 'a',
        'status': 'Lançada',
        'score': 0,
        'max_score': 10,
        'weight': 1,
      },
      {
        'journal': 'j',
        'stage': 'Etapa 1',
        'enrollment': 'b',
        'status': 'Pendente',
        'score': null,
        'max_score': 10,
        'weight': 1,
      },
    ];
    final summaries = summarizeGrades(rows);
    expect(summaries, hasLength(3));
    expect(summaries[0]['average'], 6.5);
    expect(summaries[0]['missing_count'], 1);
    expect(summaries[1]['average'], 0);
    expect(summaries[1]['missing_count'], 0);
    expect(summaries[2]['average'], isNull);
    expect(summaries[2]['missing_count'], 1);
    expect(summarizeGrades([]), isEmpty);
  });
}
