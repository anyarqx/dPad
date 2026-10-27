List<Map<String, dynamic>> summarizeGrades(List<Map<String, dynamic>> grades) {
  final groups = <String, List<Map<String, dynamic>>>{};
  for (final g in grades) {
    final key = [g['journal'], g['stage'], g['enrollment']].join('|');
    groups.putIfAbsent(key, () => []).add(g);
  }
  return [
    for (final group in groups.values)
      (() {
        double weighted = 0, weights = 0;
        int missing = 0;
        for (final grade in group) {
          if (grade['status'] == 'Lançada') {
            weighted +=
                (grade['score'] as num) /
                (grade['max_score'] as num) *
                10 *
                (grade['weight'] as num);
            weights += (grade['weight'] as num).toDouble();
          } else if (grade['status'] != 'Dispensada') {
            missing++;
          }
        }
        return <String, dynamic>{
          ...group.first,
          'items': group,
          'average': weights == 0 ? null : weighted / weights,
          'missing_count': missing,
        };
      })(),
  ];
}
