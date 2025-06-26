import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_notice_page.dart';
import 'login_page.dart';
import 'class_schedule_page.dart'; // ✅ Import the new page here

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  bool isAdmin(String email) {
    // 🔐 Add your admin email here
    const adminEmails = ['daskowshik49@gmail.com'];
    return adminEmails.contains(email);
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final bool showAdminPanel = user != null && isAdmin(user.email!);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Connect'),
        actions: [
          if (showAdminPanel)
            IconButton(
              icon: const Icon(Icons.admin_panel_settings),
              tooltip: 'Go to Admin Panel',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => AdminNoticePage()),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await FirebaseAuth.instance.signOut();

              // Use pushAndRemoveUntil to clear the backstack and go to LoginPage
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            '📢 Notices',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          // ✅ New button for class schedule
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ClassSchedulePage()),
              );
            },
            child: const Text('Go to Class Schedule'),
          ),

          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notices')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final notices = snapshot.data!.docs;

                if (notices.isEmpty) {
                  return const Center(child: Text('No notices yet.'));
                }

                return ListView.builder(
                  itemCount: notices.length,
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    final title = notice['title'] ?? '';
                    final description = notice['description'] ?? '';

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: ListTile(
                        title: Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(description),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}