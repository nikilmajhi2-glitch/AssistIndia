import 'package:telephony/telephony.dart';

class SmsService {
  static final _telephony = Telephony.instance;

  static Future<bool> sendSms(String to, String message, {required int simSlot}) async {
    try {
      await _telephony.sendSms(to: to, message: message, simSlot: simSlot);
      return true;
    } catch (e) {
      print('Sms send error: $e');
      return false;
    }
  }
}
