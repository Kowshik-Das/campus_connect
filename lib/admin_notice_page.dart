import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminNoticePage extends StatefulWidget {
  const AdminNoticePage({Key? key}) : super(key: key);

  @override
  State<AdminNoticePage> createState() => _AdminNoticePageState();
}

class _AdminNoticePageState extends State<AdminNoticePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _postNotice() async {
    try {
      await _firestore.collection('notices').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      _titleController.clear();
      _descriptionController.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('✅ Notice posted successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Failed to post notice: $e')));
    }
  }

  Future<void> _deleteNotice(String id) async {
    await _firestore.collection('notices').doc(id).delete();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('🗑️ Notice deleted')));
  }

  Future<void> _editNotice(
    String id,
    String oldTitle,
    String oldDescription,
  ) async {
    _titleController.text = oldTitle;
    _descriptionController.text = oldDescription;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Edit Notice'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'New Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'New Description'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _firestore.collection('notices').doc(id).update({
                'title': _titleController.text.trim(),
                'description': _descriptionController.text.trim(),
              });

              _titleController.clear();
              _descriptionController.clear();
              Navigator.pop(context);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('✏️ Notice updated')));
            },
            child: Text('Update'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Notice Panel")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Notice Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Notice Description'),
            ),
            SizedBox(height: 12),
            ElevatedButton(onPressed: _postNotice, child: Text('Post Notice')),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('notices')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError)
                    return Center(child: Text('Error loading notices'));
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final notices = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: notices.length,
                    itemBuilder: (context, index) {
                      final doc = notices[index];
                      final title = doc['title'];
                      final desc = doc['description'];
                      final id = doc.id;

                      return Card(
                        child: ListTile(
                          title: Text(title),
                          subtitle: Text(desc),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editNotice(id, title, desc),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteNotice(id),
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
      ),
    );
  }
}
