import 'package:flutter/material.dart';
import 'package:campus_connect/class_model.dart';
import 'package:campus_connect/class_schedule_service.dart';

class ClassSchedulePage extends StatefulWidget {
  const ClassSchedulePage({super.key});

  @override
  State<ClassSchedulePage> createState() => _ClassSchedulePageState();
}

class _ClassSchedulePageState extends State<ClassSchedulePage> {
  final List<String> _days = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
  ];
  String selectedDay = 'Saturday';
  final ClassScheduleService _service = ClassScheduleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Class Schedule')),
      body: Column(
        children: [
          DropdownButton<String>(
            value: selectedDay,
            items: _days.map((String day) {
              return DropdownMenuItem(value: day, child: Text(day));
            }).toList(),
            onChanged: (newDay) {
              setState(() => selectedDay = newDay!);
            },
          ),
          Expanded(
            child: StreamBuilder<List<ClassSchedule>>(
              stream: _service.getClassesForDay(selectedDay),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final classes = snapshot.data!;
                if (classes.isEmpty) {
                  return const Center(child: Text('No classes added.'));
                }
                return ListView.builder(
                  itemCount: classes.length,
                  itemBuilder: (context, index) {
                    final cls = classes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        title: Text('Class name: ${cls.className}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Faculty Initial: ${cls.facultyInitial}'),
                            Text('Time: ${cls.time}'),
                            Text('Room: ${cls.room}'),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => _openFormDialog(cls),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _service.deleteClass(cls.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _openFormDialog([ClassSchedule? existing]) {
    final nameCtrl = TextEditingController(text: existing?.className);
    final facultyCtrl = TextEditingController(text: existing?.facultyInitial);
    final timeCtrl = TextEditingController(text: existing?.time);
    final roomCtrl = TextEditingController(text: existing?.room);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add Class' : 'Edit Class'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Class Name'),
              ),
              TextField(
                controller: facultyCtrl,
                decoration: const InputDecoration(labelText: 'Faculty Initial'),
              ),
              TextField(
                controller: timeCtrl,
                decoration: const InputDecoration(labelText: 'Time'),
              ),
              TextField(
                controller: roomCtrl,
                decoration: const InputDecoration(labelText: 'Room'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              final cls = ClassSchedule(
                id: existing?.id ?? '',
                day: selectedDay,
                className: nameCtrl.text.trim(),
                facultyInitial: facultyCtrl.text.trim(),
                time: timeCtrl.text.trim(),
                room: roomCtrl.text.trim(),
              );
              if (existing == null) {
                _service.addClass(cls);
              } else {
                _service.updateClass(cls);
              }
              Navigator.pop(context);
            },
            child: Text(existing == null ? 'Add' : 'Update'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
