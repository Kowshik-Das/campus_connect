import 'package:flutter/material.dart';

class ClassSchedulePage extends StatelessWidget {
  const ClassSchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Class Schedule'),
      ),
      body: const Center(
        child: Text(
          'This is the class schedule page.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}