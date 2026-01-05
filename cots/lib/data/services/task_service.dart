import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';
import 'supabase_config.dart';

class TaskService {
  TaskService();

  Map<String, String> get _headers => {
    'apikey': SupabaseConfig.anonKey,
    'Authorization': 'Bearer ${SupabaseConfig.anonKey}',
    'Content-Type': 'application/json',
  };

  Uri _buildUri(String path) {
    return Uri.parse('${SupabaseConfig.baseUrl}$path');
  }

  Future<List<Task>> getAllTasks() async {
    final response = await http.get(
      _buildUri('/rest/v1/tasks?select=*'),
      headers: _headers,
    );

    _ensureSuccess(response);
    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Task>> getTasksByStatus(String status) async {
    final response = await http.get(
      _buildUri('/rest/v1/tasks?select=*&status=eq.$status'),
      headers: _headers,
    );

    _ensureSuccess(response);
    final List data = jsonDecode(response.body) as List;
    return data.map((e) => Task.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Task> addTask({
    required String title,
    required String course,
    required DateTime deadline,
    String note = '',
  }) async {
    final body = jsonEncode({
      'title': title,
      'course': course,
      'deadline': deadline.toIso8601String(),
      'status': 'BERJALAN',
      'note': note,
      'is_done': false,
    });

    final response = await http.post(
      _buildUri('/rest/v1/tasks'),
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: body,
    );

    _ensureSuccess(response);
    final List data = jsonDecode(response.body) as List;
    return Task.fromJson(data.first as Map<String, dynamic>);
  }

  Future<void> updateNote({required int id, required String note}) async {
    final response = await http.patch(
      _buildUri('/rest/v1/tasks?id=eq.$id'),
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({'note': note}),
    );

    _ensureSuccess(response);
  }

  Future<void> toggleTaskStatus({required int id, required bool isDone}) async {
    final response = await http.patch(
      _buildUri('/rest/v1/tasks?id=eq.$id'),
      headers: {..._headers, 'Prefer': 'return=representation'},
      body: jsonEncode({
        'is_done': isDone,
        'status': isDone ? 'SELESAI' : 'BERJALAN',
      }),
    );

    _ensureSuccess(response);
  }

  void _ensureSuccess(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Gagal memproses data: ${response.statusCode}');
    }
  }
}
