class AuditLog {
  final int id;
  final int? user;
  final String userEmail;
  final String method;
  final String endpoint;
  final String resourceType;
  final String? resourceId;
  final int statusCode;
  final String ipAddress;
  final int durationMs;
  final String timestamp;

  const AuditLog({
    required this.id,
    this.user,
    required this.userEmail,
    required this.method,
    required this.endpoint,
    required this.resourceType,
    this.resourceId,
    required this.statusCode,
    required this.ipAddress,
    required this.durationMs,
    required this.timestamp,
  });

  factory AuditLog.fromJson(Map<String, dynamic> json) => AuditLog(
    id: (json['id'] as num).toInt(),
    user: json['user'] != null ? (json['user'] as num).toInt() : null,
    userEmail: json['user_email'] as String? ?? '',
    method: json['method'] as String? ?? '',
    endpoint: json['endpoint'] as String? ?? '',
    resourceType: json['resource_type'] as String? ?? '',
    resourceId: json['resource_id'] as String?,
    statusCode: (json['status_code'] as num).toInt(),
    ipAddress: json['ip_address'] as String? ?? '',
    durationMs: (json['duration_ms'] as num?)?.toInt() ?? 0,
    timestamp: json['timestamp'] as String? ?? '',
  );
}

class AuditLogPage {
  final int count;
  final String? next;
  final String? previous;
  final List<AuditLog> results;

  const AuditLogPage({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory AuditLogPage.fromJson(Map<String, dynamic> json) => AuditLogPage(
    count: (json['count'] as num).toInt(),
    next: json['next'] as String?,
    previous: json['previous'] as String?,
    results: (json['results'] as List)
        .map((e) => AuditLog.fromJson(e as Map<String, dynamic>))
        .toList(),
  );

  bool get hasNext => next != null;
  bool get hasPrevious => previous != null;
}
