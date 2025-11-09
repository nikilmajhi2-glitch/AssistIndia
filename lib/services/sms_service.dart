import 'package:another_telephony/another_telephony.dart';

class SmsService {
  static final AnotherTelephony _telephony = AnotherTelephony.instance;

  /// Sends SMS using selected SIM slot (0 = SIM1, 1 = SIM2)
  static Future<bool> sendSms(String to, String message, {required int simSlot}) async {
    try {
      await _telephony.sendSms(
        to: to,
        message: message,
        simSlot: simSlot,
      );
      print('✅ SMS sent to $to using SIM ${simSlot + 1}');
      return true;
    } catch (e) {
      print('❌ SMS send failed for $to: $e');
      return false;
    }
  }
}