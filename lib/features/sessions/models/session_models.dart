class SessionItem {
  final String id;
  final String name;
  final double price;
  final String buyer;
  final List<String> consumers;

  const SessionItem({
    required this.id,
    required this.name,
    required this.price,
    required this.buyer,
    required this.consumers,
  });

  double get perPersonShare => consumers.isEmpty ? 0 : price / consumers.length;
}

class Session {
  final String id;
  final String title;
  final String place;
  final String date;
  final String status; // 'open' | 'closed'
  final List<String> members;
  final List<SessionItem> items;

  const Session({
    required this.id,
    required this.title,
    required this.place,
    required this.date,
    required this.status,
    required this.members,
    required this.items,
  });

  double get totalAmount => items.fold(0.0, (acc, item) => acc + item.price);
}

class PersonBalance {
  final String name;
  final double paid;
  final double owed;

  const PersonBalance({
    required this.name,
    required this.paid,
    required this.owed,
  });

  double get net => paid - owed;
}

List<PersonBalance> computeBalances(Session session) {
  final Map<String, double> paidMap = {};
  final Map<String, double> owedMap = {};

  for (final m in session.members) {
    paidMap[m] = 0.0;
    owedMap[m] = 0.0;
  }

  for (final item in session.items) {
    paidMap[item.buyer] = (paidMap[item.buyer] ?? 0.0) + item.price;
    final share = item.perPersonShare;
    for (final consumer in item.consumers) {
      owedMap[consumer] = (owedMap[consumer] ?? 0.0) + share;
    }
  }

  return session.members.map((m) {
    return PersonBalance(
      name: m,
      paid: paidMap[m] ?? 0.0,
      owed: owedMap[m] ?? 0.0,
    );
  }).toList();
}
