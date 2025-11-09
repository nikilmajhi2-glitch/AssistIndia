import 'package:telephony_plus/telephony_plus.dart';

class SmsService {
  static final TelephonyPlus _telephony = TelephonyPlus.instance;

  /// Sends an SMS using the chosen SIM slot.
  /// [simSlot] = 0 for SIM1, 1 for SIM2 (if dual SIM supported)
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