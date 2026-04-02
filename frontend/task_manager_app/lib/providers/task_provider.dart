import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/task_service.dart';

class TaskProvider with ChangeNotifier {
  final TaskService _service = TaskService();

  List<Task> _tasks = [];
  bool _isLoading = false;

  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;

  // 🔥 DRAFT STATE
  String draftTitle = "";
  String draftDescription = "";
  DateTime? draftDueDate;
  String draftStatus = "To-Do";
  int? draftBlockedBy;

  void saveDraft({
    required String title,
    required String description,
    DateTime? dueDate,
    required String status,
    int? blockedBy,
  }) {
    draftTitle = title;
    draftDescription = description;
    draftDueDate = dueDate;
    draftStatus = status;
    draftBlockedBy = blockedBy;
  }

  void clearDraft() {
    draftTitle = "";
    draftDescription = "";
    draftDueDate = null;
    draftStatus = "To-Do";
    draftBlockedBy = null;
  }

  Future<void> fetchTasks({String? search, String? status}) async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _service.fetchTasks(search: search, status: status);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTask(Task task) async {
    _isLoading = true;
    notifyListeners();

    await _service.createTask(task);
    await fetchTasks();

    clearDraft();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(int id, Task task) async {
    _isLoading = true;
    notifyListeners();

    await _service.updateTask(id, task);
    await fetchTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(int id) async {
    await _service.deleteTask(id);
    await fetchTasks();
  }
}