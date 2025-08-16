import 'package:flutter/material.dart';
import 'TaskModel.dart';
import 'TaskService.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  final TaskService _taskService = TaskService();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _dueDateController = TextEditingController();

  void _showTaskDialog({TaskModel? task}) {
    if (task != null) {
      _titleController.text = task.title;
      _descController.text = task.description;
      _dueDateController.text = task.dueDate;
    } else {
      _titleController.clear();
      _descController.clear();
      _dueDateController.clear();
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(task == null ? 'Add Task' : 'Edit Task'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: _dueDateController,
                decoration: InputDecoration(labelText: 'Due Date'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text(task == null ? 'Add' : 'Update'),
            onPressed: () {
              if (_titleController.text.isNotEmpty) {
                TaskModel newTask = TaskModel(
                  id: task?.id,
                  title: _titleController.text,
                  description: _descController.text,
                  dueDate: _dueDateController.text,
                  isCompleted: task?.isCompleted ?? false,
                );

                if (task == null) {
                  _taskService.addTask(newTask);
                } else {
                  _taskService.updateTask(newTask);
                }
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("To-Do List")),
      body: StreamBuilder<List<TaskModel>>(
        stream: _taskService.getTasks(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final tasks = snapshot.data!;
          if (tasks.isEmpty) return Center(child: Text("No tasks yet"));

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return ListTile(
                leading: Checkbox(
                  value: task.isCompleted,
                  onChanged: (value) {
                    _taskService.updateTask(
                      TaskModel(
                        id: task.id,
                        title: task.title,
                        description: task.description,
                        dueDate: task.dueDate,
                        isCompleted: value ?? false,
                      ),
                    );
                  },
                ),
                title: Text(task.title),
                subtitle: Text("${task.description}\nDue: ${task.dueDate}"),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showTaskDialog(task: task),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _taskService.deleteTask(task.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
