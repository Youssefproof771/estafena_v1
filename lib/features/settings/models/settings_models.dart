import '../../friends/models/friend_models.dart';

class UserProfile {
  final String name;
  final String handle;
  final String initials;
  final String bio;
  final PaymentMethods payments;

  const UserProfile({
    required this.name,
    required this.handle,
    required this.initials,
    this.bio = '',
    this.payments = const PaymentMethods(),
  });

  UserProfile copyWith({
    String? name,
    String? handle,
    String? initials,
    String? bio,
    PaymentMethods? payments,
  }) {
    return UserProfile(
      name: name ?? this.name,
      handle: handle ?? this.handle,
      initials: initials ?? this.initials,
      bio: bio ?? this.bio,
      payments: payments ?? this.payments,
    );
  }
}

class LanguageOption {
  final String code;
  final String label;

  const LanguageOption({required this.code, required this.label});
}

const List<LanguageOption> supportedLanguages = [
  LanguageOption(code: 'en', label: 'English'),
  LanguageOption(code: 'ar', label: 'العربية'),
];

String getInitials(String name) {
  final parts = name
      .trim()
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return '?';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return (parts[0][0] + parts[1][0]).toUpperCase();
}
