import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:maps/services/all_services_local_notification.dart';

void main() {
  runApp(const NotificationTesterApp());
}

class NotificationTesterApp extends StatelessWidget {
  const NotificationTesterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Tester',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const NotificationTestScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationTestScreen extends StatefulWidget {
  const NotificationTestScreen({super.key});

  @override
  State<NotificationTestScreen> createState() => _NotificationTestScreenState();
}

class _NotificationTestScreenState extends State<NotificationTestScreen> {
  final NotificationService _notificationService = NotificationService();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Test Notification');
  final _bodyController = TextEditingController(text: 'This is a test message');
  final _payloadController = TextEditingController(text: 'test_payload');
  final _soundController = TextEditingController(text: 'notification');
  final _idController = TextEditingController(text: '1');
  TimeOfDay _selectedTime = TimeOfDay.now();
  Duration _delayDuration = const Duration(minutes: 5);
  RepeatInterval _repeatInterval = RepeatInterval.daily;

  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    await _notificationService.init();
    _notificationService.onNotificationTap.listen((response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tapped: ${response.payload}')),
      );
    });
  }

  Future<void> _selectTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null) {
      setState(() => _selectedTime = pickedTime);
    }
  }

  Future<void> _selectDuration(BuildContext context) async {
    final pickedDuration = await showDialog<Duration>(
      context: context,
      builder: (context) => DurationPickerDialog(
        initialDuration: _delayDuration,
      ),
    );
    if (pickedDuration != null) {
      setState(() => _delayDuration = pickedDuration);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Tester'),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear_all),
            onPressed: () async {
              await _notificationService.cancelAll();
              _showSuccess('All notifications cancelled');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildInputSection(),
              const SizedBox(height: 24),
              _buildBasicNotificationCard(),
              const SizedBox(height: 16),
              _buildScheduledNotificationCard(),
              const SizedBox(height: 16),
              _buildDailyNotificationCard(),
              const SizedBox(height: 16),
              _buildRepeatedNotificationCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _idController,
              decoration: const InputDecoration(
                labelText: 'Notification ID',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _bodyController,
              decoration: const InputDecoration(
                labelText: 'Body',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _payloadController,
              decoration: const InputDecoration(
                labelText: 'Payload',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _soundController,
              decoration: const InputDecoration(
                labelText: 'Sound (Android only)',
                border: OutlineInputBorder(),
                hintText: 'e.g. notification',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBasicNotificationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Basic Notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _soundController,
              decoration: const InputDecoration(
                labelText: 'Sound (Android: raw resource name without extension)',
                border: OutlineInputBorder(),
                hintText: 'e.g. notification (for res/raw/notification.mp3)',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                try {
                  await _notificationService.showBasic(
                    id: int.parse(_idController.text),
                    title: _titleController.text,
                    body: _bodyController.text,
                    payload: _payloadController.text.isNotEmpty
                        ? _payloadController.text
                        : null,
                    sound: _soundController.text.isNotEmpty
                        ? _soundController.text
                        : null,
                  );
                  _showSuccess('Basic notification shown');
                } catch (e) {
                  _showError('Failed to show notification: $e');
                }
              },
              child: const Text('Show Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }


  Widget _buildScheduledNotificationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Scheduled Notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text('Delay: ${_delayDuration.inMinutes} minutes'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _selectDuration(context),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await _notificationService.showScheduled(
                  id: int.parse(_idController.text),
                  title: _titleController.text,
                  body: _bodyController.text,
                  delay: _delayDuration,
                  payload: _payloadController.text.isNotEmpty
                      ? _payloadController.text
                      : null,
                );
                _showSuccess(
                  'Scheduled for ${_delayDuration.inMinutes} minutes from now',
                );
              },
              child: const Text('Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyNotificationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Daily Notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              title: Text('Time: ${_selectedTime.format(context)}'),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _selectTime(context),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await _notificationService.showDaily(
                  id: int.parse(_idController.text),
                  title: _titleController.text,
                  body: _bodyController.text,
                  time: _selectedTime,
                  payload: _payloadController.text.isNotEmpty
                      ? _payloadController.text
                      : null,
                );
                _showSuccess(
                  'Daily at ${_selectedTime.format(context)}',
                );
              },
              child: const Text('Set Daily'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRepeatedNotificationCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Repeated Notification',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<RepeatInterval>(
              value: _repeatInterval,
              items: const [
                DropdownMenuItem(
                  value: RepeatInterval.hourly,
                  child: Text('Hourly'),
                ),
                DropdownMenuItem(
                  value: RepeatInterval.daily,
                  child: Text('Daily'),
                ),
                DropdownMenuItem(
                  value: RepeatInterval.weekly,
                  child: Text('Weekly'),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => _repeatInterval = value);
                }
              },
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Repeat Interval',
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) return;
                await _notificationService.showRepeated(
                  id: int.parse(_idController.text),
                  title: _titleController.text,
                  body: _bodyController.text,
                  interval: _repeatInterval,
                  payload: _payloadController.text.isNotEmpty
                      ? _payloadController.text
                      : null,
                );
                _showSuccess(
                  'Repeating ${_repeatInterval.toString().split('.').last}',
                );
              },
              child: const Text('Set Repeating'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _payloadController.dispose();
    _soundController.dispose();
    _idController.dispose();
    _notificationService.dispose();
    super.dispose();
  }
}

// Helper widget for duration picker (you can replace with a package if preferred)
class DurationPickerDialog extends StatefulWidget {
  final Duration initialDuration;

  const DurationPickerDialog({super.key, required this.initialDuration});

  @override
  State<DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<DurationPickerDialog> {
  late int _minutes;

  @override
  void initState() {
    super.initState();
    _minutes = widget.initialDuration.inMinutes;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Delay Duration'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('$_minutes minutes'),
          Slider(
            min: 1,
            max: 1440, // 24 hours
            divisions: 1439,
            value: _minutes.toDouble(),
            onChanged: (value) {
              setState(() => _minutes = value.toInt());
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, Duration(minutes: _minutes)),
          child: const Text('OK'),
        ),
      ],
    );
  }
}