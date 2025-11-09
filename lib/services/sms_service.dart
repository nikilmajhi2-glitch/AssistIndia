import 'package:sms_sender/sms_sender.dart';

class SmsService {
  /// Sends an SMS message using the selected SIM slot.
  /// [simSlot] = 0 → SIM1, [simSlot] = 1 → SIM2 (if dual SIM supported)
  static Future<bool> sendSms(String to, String message, {required int simSlot}) async {
    try {
      final sender = SmsSender();

      // Build SMS message with SIM slot
      final SmsMessage sms = SmsMessage(to, message)
        ..simSlot = simSlot;

      // Send the SMS
      sender.sendSms(sms);

      print('✅ SMS sent to $to using SIM ${simSlot + 1}');
      return true;
    } catch (e) {
      print('❌ Failed to send SMS to $to: $e');
      return false;
    }
  }
}