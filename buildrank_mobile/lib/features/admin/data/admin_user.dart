class AdminUser {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final bool isActive;
  final bool isSuperuser;
  final String dateJoined;
  final String role;
  final String accountStatus;
  final String suspensionReason;
  final String? suspendedUntil;

  const AdminUser({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    required this.isSuperuser,
    required this.dateJoined,
    required this.role,
    required this.accountStatus,
    required this.suspensionReason,
    this.suspendedUntil,
  });

  factory AdminUser.fromJson(Map<String, dynamic> json) => AdminUser(
    id: (json['id'] as num).toInt(),
    email: json['email'] as String? ?? '',
    firstName: json['first_name'] as String? ?? '',
    lastName: json['last_name'] as String? ?? '',
    isActive: json['is_active'] as bool? ?? true,
    isSuperuser: json['is_superuser'] as bool? ?? false,
    dateJoined: json['date_joined'] as String? ?? '',
    role: json['role'] as String? ?? '',
    accountStatus: json['account_status'] as String? ?? 'active',
    suspensionReason: json['suspension_reason'] as String? ?? '',
    suspendedUntil: json['suspended_until'] as String?,
  );

  String get fullName => '$firstName $lastName'.trim();
  bool get isBlocked => accountStatus == 'blocked';
  bool get isSuspended => accountStatus == 'suspended';
  bool get isActiveStatus => accountStatus == 'active';

  String get roleLabel => switch (role) {
    'owner' => 'Propietari',
    'tenant' => 'Llogater',
    'admin' => 'Admin finca',
    _ => role,
  };
}
