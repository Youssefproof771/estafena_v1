class Friend {
  final String id;
  final String name;
  final String handle;
  final String initials;
  final List<String> payments; // e.g. InstaPay, Vodafone Cash, Bank Account

  const Friend({
    required this.id,
    required this.name,
    required this.handle,
    required this.initials,
    this.payments = const [],
  });
}

class FriendTransaction {
  final String id;
  final String title;
  final double amount; // positive: you paid (they owe you), negative: they paid (you owe them)
  final String when;

  const FriendTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.when,
  });
}

String formatCurrency(num amount) {
  return '${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)} EGP';
}

class FriendRequest {
  final String id;
  final String name;
  final String initials;
  final int mutual;

  const FriendRequest({
    required this.id,
    required this.name,
    required this.initials,
    required this.mutual,
  });
}

class FriendSuggestion {
  final String id;
  final String name;
  final String initials;
  final int mutual;

  const FriendSuggestion({
    required this.id,
    required this.name,
    required this.initials,
    required this.mutual,
  });
}

class PaymentMethods {
  final String? instapay;
  final String? wallet;
  final String? card;

  const PaymentMethods({
    this.instapay,
    this.wallet,
    this.card,
  });

  bool get isEmpty => instapay == null && wallet == null && card == null;
}

class ProfileView {
  final String name;
  final String handle;
  final String initials;
  final double? balance;
  final PaymentMethods payments;

  const ProfileView({
    required this.name,
    required this.handle,
    required this.initials,
    this.balance,
    required this.payments,
  });
}