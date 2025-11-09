import 'package:sms_advanced/sms_advanced.dart';

class SmsService {
  /// Send an SMS using the chosen SIM slot.
  /// [simSlot] = 0 for SIM1, 1 for SIM2 (if device supports dual SIM)
  static Future<bool> sendSms(String to, String message, {required int simSlot}) async {
    try {
      final SmsSender sender = SmsSender();

      // Create a message instance with dual-SIM support
      final SmsMessage sms = SmsMessage(to, message)
        ..simSlot = simSlot; // specify which SIM to use

      sender.sendSms(sms);

      print('✅ SMS sent to $to using SIM ${simSlot + 1}');
      return true;
    } catch (e) {
      print('❌ SMS send failed for $to: $e');
      return false;
    }
  }
}