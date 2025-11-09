import 'package:flutter/material.dart';
import 'package:assistindia/utils/prefs.dart';
import 'package:assistindia/screens/dashboard_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:assistindia/services/background_service.dart';

class BindScreen extends StatefulWidget {
  const BindScreen({super.key});

  @override
  State<BindScreen> createState() => _BindScreenState();
}

class _BindScreenState extends State<BindScreen> {
  final TextEditingController _userController = TextEditingController();
  int? _selectedSim;

  bool get isReady => _userController.text.trim().isNotEmpty && _selectedSim != null;

  void _bindAndStart() async {
    final id = _userController.text.trim();
    if (id.isEmpty || _selectedSim == null) return;
    await Prefs.setUserId(id);
    await Prefs.setSimSlot(_selectedSim!);

    // Register periodic task (every 15 minutes is minimum on some Android; WorkManager frequency approx 15m.
    // For dev/testing Workmanager supports shorter in debug but in production it's ~15m minimum. We still register 2min as requested.
    Workmanager().registerPeriodicTask(
      'assist_sms_task',
      'assist_sms_task_worker',
      frequency: const Duration(minutes: 2),
      existingWorkPolicy: ExistingWorkPolicy.replace,
      initialDelay: const Duration(seconds: 10),
    );

    if (!mounted) return;
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            color: const Color(0xFF0B1220),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.send_rounded, size: 72, color: Color(0xFF3949AB)),
                  const SizedBox(height: 12),
                  const Text('AssistIndia', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _userController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Enter your User ID',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  Align(alignment: Alignment.centerLeft, child: Text('Select SIM Slot:', style: TextStyle(fontWeight: FontWeight.w600))),
                  RadioListTile<int>(
                    value: 0,
                    groupValue: _selectedSim,
                    onChanged: (v) => setState(() => _selectedSim = v),
                    title: const Text('SIM 1'),
                    activeColor: const Color(0xFF3949AB),
                  ),
                  RadioListTile<int>(
                    value: 1,
                    groupValue: _selectedSim,
                    onChanged: (v) => setState(() => _selectedSim = v),
                    title: const Text('SIM 2'),
                    activeColor: const Color(0xFF3949AB),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: isReady ? _bindAndStart : null,
                    icon: const Icon(Icons.check_circle_outline),
                    label: const Text('Bind & Start'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3949AB),
                      minimumSize: const Size.fromHeight(48),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
