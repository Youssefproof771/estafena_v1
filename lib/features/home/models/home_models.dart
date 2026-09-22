class ActivityItem {
  final String id;
  final String title;
  final String detail;
  final String when;
  final double
  amount; // positive: received/owed to you, negative: paid/you owe, 0: neutral

  const ActivityItem({
    required this.id,
    required this.title,
    required this.detail,
    required this.when,
    required this.amount,
  });
}
