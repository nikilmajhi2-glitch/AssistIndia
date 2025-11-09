import 'package:cloud_firestore/cloud_firestore.dart';

class SmsTask {
  final String id;
  final String phone;
  final String message;
  final int credit;

  SmsTask({required this.id, required this.phone, required this.message, required this.credit});

  factory SmsTask.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SmsTask(
      id: doc.id,
      phone: data['phone'] ?? '',
      message: data['message'] ?? '',
      credit: (data['credit'] ?? 1) as int,
    );
  }
}
