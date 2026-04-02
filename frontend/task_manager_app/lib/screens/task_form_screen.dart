import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../models/task_model.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  DateTime? _dueDate;
  String _status = "To-Do";
  int? _blockedBy;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    final provider = Provider.of<TaskProvider>(context, listen: false);

    _titleController.text = provider.draftTitle;
    _descController.text = provider.draftDescription;
    _dueDate = provider.draftDueDate;
    _status = provider.draftStatus;
    _blockedBy = provider.draftBlockedBy;
  }

  void _saveDraft() {
    Provider.of<TaskProvider>(context, listen: false).saveDraft(
      title: _titleController.text,
      description: _descController.text,
      dueDate: _dueDate,
      status: _status,
      blockedBy: _blockedBy,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _dueDate = picked);
      _saveDraft();
    }
  }

  Future<void> _saveTask() async {
    if (_titleController.text.isEmpty ||
        _descController.text.isEmpty ||
        _dueDate == null) {
      return;
    }

    setState(() => _isSaving = true);

    final task = Task(
      title: _titleController.text,
      description: _descController.text,
      dueDate: _dueDate!,
      status: _status,
      blockedBy: _blockedBy,
    );

    await Provider.of<TaskProvider>(context, listen: false)
        .addTask(task);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final tasks = Provider.of<TaskProvider>(context).tasks;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Create New Task",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Task Title",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: "Enter task title",
                      prefixIcon: const Icon(Icons.edit_note,
                          color: Color(0xFF1E3A8A)),
                    ),
                    onChanged: (_) => _saveDraft(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Description Input
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      hintText: "Enter task description",
                      prefixIcon: const Icon(Icons.description,
                          color: Color(0xFF1E3A8A)),
                    ),
                    maxLines: 3,
                    onChanged: (_) => _saveDraft(),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Due Date Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Due Date",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F5F5),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.calendar_today,
                            color: Color(0xFF1E3A8A),
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            _dueDate == null
                                ? "Select due date"
                                : _dueDate.toString().split(" ")[0],
                            style: TextStyle(
                              fontSize: 14,
                              color: _dueDate == null
                                  ? Colors.grey[500]
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Color(0xFF1E3A8A),
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Status Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Status",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      underline: const SizedBox(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "To-Do",
                          child: Text("To-Do"),
                        ),
                        DropdownMenuItem(
                          value: "In Progress",
                          child: Text("In Progress"),
                        ),
                        DropdownMenuItem(
                          value: "Done",
                          child: Text("Done"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _status = value!);
                        _saveDraft();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Block By Dropdown
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Blocked By (Optional)",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.grey[300]!,
                        width: 1,
                      ),
                    ),
                    child: DropdownButton<int?>(
                      value: _blockedBy,
                      isExpanded: true,
                      underline: const SizedBox(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      hint: const Text("No dependency"),
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text("No dependency"),
                        ),
                        ...tasks.map((task) => DropdownMenuItem(
                          value: task.id,
                          child: Text(
                            task.title,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ))
                      ],
                      onChanged: (value) {
                        setState(() => _blockedBy = value);
                        _saveDraft();
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: _isSaving
                    ? const Center(
                        child: SizedBox(
                          height: 48,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      )
                    : ElevatedButton.icon(
                        onPressed: _saveTask,
                        icon: const Icon(Icons.check),
                        label: const Text("Create Task"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}