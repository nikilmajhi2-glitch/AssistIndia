import 'package:workmanager/workmanager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:telephony/telephony.dart';
import 'package:assistindia/utils/prefs.dart';
import 'package:assistindia/services/firebase_service.dart';
import 'package:assistindia/services/sms_service.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await Firebase.initializeApp();
      await Prefs.init();
      final userId = Prefs.getUserId();
      if (userId == null) return Future.value(true);
      final simSlot = Prefs.getSimSlot() ?? 0;
      final tasks = await FirebaseService.fetchPendingTasks(limit: 5);
      for (final t in tasks) {
        final ok = await SmsService.sendSms(t.phone, t.message, simSlot: simSlot);
        if (ok) {
          await FirebaseService.markTaskSent(t.id);
          await FirebaseService.addCredit(userId, t.credit);
        } else {
          await FirebaseService.markTaskFailed(t.id, 'send_failed');
        }
      }
      return Future.value(true);
    } catch (e) {
      print('Background worker error: $e');
      return Future.value(true);
    }
  });
}
