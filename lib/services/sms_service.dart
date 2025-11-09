import 'package:flutter_sms_plus/flutter_sms_plus.dart';

class SmsService {
  /// Sends an SMS using the chosen SIM slot.
  /// [simSlot] = 0 for SIM1, 1 for SIM2 (if device supports dual SIM)
  static Future<bool> sendSms(String to, String message, {required int simSlot}) async {
    try {
      final SmsSender sender = SmsSender();

      // Create the SMS message
      final SmsMessage sms = SmsMessage(to, message)
        ..simSlot = simSlot; // specify SIM slot (0 or 1)

      sender.sendSms(sms);

      print('✅ SMS sent to $to using SIM ${simSlot + 1}');
      return true;
    } catch (e) {
      print('❌ SMS send failed for $to: $e');
      return false;
    }
  }
}