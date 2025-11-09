import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:assistindia/models/sms_task.dart';

class FirebaseService {
  static final _db = FirebaseFirestore.instance;

  static Future<List<SmsTask>> fetchPendingTasks({int limit = 5}) async {
    final snap = await _db
        .collection('sms_tasks')
        .where('status', isEqualTo: 'pending')
        .limit(limit)
        .get();
    return snap.docs.map((d) => SmsTask.fromDoc(d)).toList();
  }

  static Future<void> markTaskSent(String id) async {
    await _db.collection('sms_tasks').doc(id).update({
      'status': 'sent',
      'sent_at': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> markTaskFailed(String id, String error) async {
    await _db.collection('sms_tasks').doc(id).update({
      'status': 'failed',
      'error': error,
    });
  }

  static Future<void> addCredit(String userId, int credit) async {
    final userRef = _db.collection('users').doc(userId);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(userRef);
      final old = (snap.data()?['credits'] ?? 0) as int;
      tx.update(userRef, {'credits': old + credit});
    });
  }

  static Future<Map<String, int>> getCounts() async {
    final pendingQ =
        await _db.collection('sms_tasks').where('status', isEqualTo: 'pending').get();
    final sentQ =
        await _db.collection('sms_tasks').where('status', isEqualTo: 'sent').get();
    return {'pending': pendingQ.size, 'sent': sentQ.size};
  }
}