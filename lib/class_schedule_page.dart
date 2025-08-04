import 'package:flutter/material.dart';

class ClassSchedulePage extends StatefulWidget {
  const ClassSchedulePage({super.key});

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  final Map<String, List<Map<String, String>>> _weeklySchedule = {
    'Saturday': [],
    'Sunday': [],
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
  };

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _weeklySchedule.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Class Schedule'),
          bottom: TabBar(
            isScrollable: true,
            tabs: _weeklySchedule.keys.map((day) => Tab(text: day)).toList(),
          ),
        ),
        body: TabBarView(
          children: _weeklySchedule.keys.map((day) {
            return _buildDaySchedule(day);
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildDaySchedule(String day) {
    final schedule = _weeklySchedule[day]!;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: schedule.length,
            itemBuilder: (context, index) {
              final classItem = schedule[index];
              return ListTile(
                title: Text('${classItem['class']} (${classItem['time']})'),
                subtitle: Text(
                  'Faculty: ${classItem['faculty']}, Room: ${classItem['room']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () =>
                          _showClassDialog(day, isEdit: true, index: index),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          schedule.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("Add Class"),
          onPressed: () => _showClassDialog(day),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  void _showClassDialog(String day, {bool isEdit = false, int? index}) {
    final schedule = _weeklySchedule[day]!;
    final TextEditingController classController = TextEditingController();
    final TextEditingController facultyController = TextEditingController();
    final TextEditingController timeController = TextEditingController();
    final TextEditingController roomController = TextEditingController();

    if (isEdit && index != null) {
      final existing = schedule[index];
      classController.text = existing['class']!;
      facultyController.text = existing['faculty']!;
      timeController.text = existing['time']!;
      roomController.text = existing['room']!;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Edit Class' : 'Add Class'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: classController,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: facultyController,
                decoration: const InputDecoration(labelText: 'Faculty Initial'),
              ),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                  labelText: 'Time (e.g., 9:00 AM - 10:00 AM)',
                ),
              ),
              TextField(
                controller: roomController,
                decoration: const InputDecoration(labelText: 'Room Number'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newClass = {
                'class': classController.text,
                'faculty': facultyController.text,
                'time': timeController.text,
                'room': roomController.text,
              };

              setState(() {
                if (isEdit && index != null) {
                  schedule[index] = newClass;
                } else {
                  schedule.add(newClass);
                }
              });

              Navigator.pop(context);
            },
            child: Text(isEdit ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }
}
