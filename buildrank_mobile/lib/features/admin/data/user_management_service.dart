import 'dart:convert';

import 'package:buildrank_mobile/core/config/api_config.dart';
import 'package:buildrank_mobile/core/services/api_client.dart';
import 'package:buildrank_mobile/features/admin/data/admin_user.dart';
import 'package:http/http.dart' as http;

class UserManagementService {
  Future<List<AdminUser>> getUsers() async {
    final response = await ApiClient.get(Uri.parse(ApiConfig.adminUsers));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data
          .map((e) => AdminUser.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    throw Exception('No s\'han pogut carregar els usuaris.');
  }

  Future<AdminUser> blockUser(int id) async {
    final response = await ApiClient.post(
      Uri.parse(ApiConfig.adminBlockUser(id)),
    );
    return _parseUser(response);
  }

  Future<AdminUser> unblockUser(int id) async {
    final response = await ApiClient.post(
      Uri.parse(ApiConfig.adminUnblockUser(id)),
    );
    return _parseUser(response);
  }

  Future<AdminUser> suspendUser(
    int id, {
    String? reason,
    DateTime? suspendedUntil,
  }) async {
    final body = <String, dynamic>{};
    if (reason != null && reason.isNotEmpty) body['reason'] = reason;
    if (suspendedUntil != null) {
      body['suspended_until'] = suspendedUntil.toUtc().toIso8601String();
    }

    final response = await ApiClient.post(
      Uri.parse(ApiConfig.adminSuspendUser(id)),
      body: jsonEncode(body),
    );
    return _parseUser(response);
  }

  Future<AdminUser> unsuspendUser(int id) async {
    final response = await ApiClient.post(
      Uri.parse(ApiConfig.adminUnsuspendUser(id)),
    );
    return _parseUser(response);
  }

  AdminUser _parseUser(http.Response response) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode == 200) return AdminUser.fromJson(data);
    throw Exception(data['detail']?.toString() ?? 'Error en l\'operació.');
  }
}
