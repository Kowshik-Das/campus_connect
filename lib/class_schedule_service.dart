import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'class_model.dart';

class ClassScheduleService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // Get reference
  CollectionReference getUserScheduleCollection() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('users').doc(uid).collection('class_schedule');
  }

  // Add class
  Future<void> addClass(ClassSchedule cls) async {
    await getUserScheduleCollection().add(cls.toMap());
  }

  // Update class
  Future<void> updateClass(ClassSchedule cls) async {
    await getUserScheduleCollection().doc(cls.id).update(cls.toMap());
  }

  // Delete class
  Future<void> deleteClass(String id) async {
    await getUserScheduleCollection().doc(id).delete();
  }

  // Get class list for a specific day
  Stream<List<ClassSchedule>> getClassesForDay(String day) {
    return getUserScheduleCollection()
        .where('day', isEqualTo: day)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => ClassSchedule.fromMap(
                  doc.id,
                  doc.data() as Map<String, dynamic>,
                ),
              )
              .toList(),
        );
  }
}
