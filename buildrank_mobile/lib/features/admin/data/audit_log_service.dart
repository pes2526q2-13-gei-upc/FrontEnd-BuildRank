import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/admin/data/audit_log.dart';

class AuditLogService {
  Future<AuditLogPage> getLogs({
    int? userId,
    String? method,
    String? resourceType,
    int? statusCode,
    String? fromDate,
    String? toDate,
    int page = 1,
  }) async {
    final uri = ApiConfig.auditLogs(
      userId: userId,
      method: method,
      resourceType: resourceType,
      statusCode: statusCode,
      fromDate: fromDate,
      toDate: toDate,
      page: page,
    );

    final response = await ApiClient.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return AuditLogPage.fromJson(data);
    }

    throw Exception('No s\'han pogut carregar els logs d\'auditoria.');
  }
}
