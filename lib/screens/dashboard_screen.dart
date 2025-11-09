import 'package:flutter/material.dart';
import 'package:assistindia/utils/prefs.dart';
import 'package:assistindia/services/firebase_service.dart';
import 'package:assistindia/services/sms_service.dart';
import 'package:workmanager/workmanager.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? userId;
  int pending = 0;
  int sent = 0;
  bool running = false;

  @override
  void initState() {
    super.initState();
    userId = Prefs.getUserId();
    _refreshCounts();
  }

  Future<void> _refreshCounts() async {
    final counts = await FirebaseService.getCounts();
    setState(() {
      pending = counts['pending'] ?? 0;
      sent = counts['sent'] ?? 0;
    });
  }

  Future<void> _runNow() async {
    setState(() => running = true);
    // Trigger one-off immediate background task
    Workmanager().registerOneOffTask('assist_sms_now', 'assist_sms_task_worker');
    await Future.delayed(const Duration(seconds: 4));
    await _refreshCounts();
    setState(() => running = false);
  }

  Future<void> _unbind() async {
    await Prefs.clear();
    Workmanager().cancelByUniqueName('assist_sms_task');
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AssistIndia Dashboard'),
        backgroundColor: const Color(0xFF061226),
        actions: [
          IconButton(onPressed: _refreshCounts, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              color: const Color(0xFF071320),
              child: ListTile(
                leading: const Icon(Icons.account_circle, size: 36, color: Color(0xFF3949AB)),
                title: Text('Bound User: ${userId ?? ''}'),
                subtitle: Text('SIM: ${Prefs.getSimSlot() == 0 ? 'SIM 1' : 'SIM 2'}'),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _statusCard('Pending', pending.toString())),
                const SizedBox(width: 12),
                Expanded(child: _statusCard('Sent', sent.toString())),
              ],
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: running ? null : _runNow,
              icon: const Icon(Icons.play_arrow),
              label: Text(running ? 'Running...' : 'Run Sync Now'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFDD835),
                foregroundColor: Colors.black,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: _unbind, child: const Text('Unbind & Stop Service')),
          ],
        ),
      ),
    );
  }

  Widget _statusCard(String title, String value) {
    return Card(
      color: const Color(0xFF071320),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
