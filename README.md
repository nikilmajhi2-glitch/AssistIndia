# AssistIndia (Flutter) - Dark Theme
Flutter skeleton for AssistIndia (com.rupeedesk). Features:
- Strict user binding (User ID) required before starting service
- SIM selection (SIM1 or SIM2)
- Background auto-sync every 2 minutes using WorkManager
- Firebase Firestore integration (sms_tasks, users)
- Dark Material 3 UI

Important:
- Replace `android/app/google-services.json.example` with your Firebase `google-services.json`.
- Test on a real Android device (SMS sending & simSlot require real device).
- WorkManager minimum periodic frequency on Android is typically ~15 minutes in production; shorter intervals may be ignored by OS optimizations.
