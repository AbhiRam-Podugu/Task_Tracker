import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/task_model.dart';

class TaskService {
 final String baseUrl = "http://127.0.0.1:8000";
  // ⚠️ IMPORTANT: for Android emulator
  // If using real device → tell me

  Future<List<Task>> fetchTasks({String? search, String? status}) async {
    String url = "$baseUrl/tasks/";

    List<String> params = [];
    if (search != null && search.isNotEmpty) {
      params.add("search=$search");
    }
    if (status != null && status.isNotEmpty) {
      params.add("status=$status");
    }

    if (params.isNotEmpty) {
      url += "?${params.join("&")}";
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((e) => Task.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load tasks");
    }
  }

  Future<void> createTask(Task task) async {
    await Future.delayed(const Duration(seconds: 2)); // simulated delay

    final response = await http.post(
      Uri.parse("$baseUrl/tasks/"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to create task");
    }
  }

  Future<void> updateTask(int id, Task task) async {
    await Future.delayed(const Duration(seconds: 2)); // simulated delay

    final response = await http.put(
      Uri.parse("$baseUrl/tasks/$id"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(task.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to update task");
    }
  }

  Future<void> deleteTask(int id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/tasks/$id"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to delete task");
    }
  }
}