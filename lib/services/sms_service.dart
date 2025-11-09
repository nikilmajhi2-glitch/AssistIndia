import 'package:sms_sender/sms_sender.dart';

class SmsService {
  static final SmsSender _sender = SmsSender();

  /// Send SMS using SIM slot (0 = SIM1, 1 = SIM2)
  static Future<bool> sendSms(String to, String message, {required int simSlot}) async {
    try {
      final sms = SmsMessage(to, message);
      sms.simSlot = simSlot;
      _sender.sendSms(sms);
      print('✅ SMS sent to $to using SIM ${simSlot + 1}');
      return true;
    } catch (e) {
      print('❌ SMS send failed for $to: $e');
      return false;
    }
  }
}