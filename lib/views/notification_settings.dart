import 'package:flutter/material.dart';

class NotificationsSettings extends StatefulWidget {
  const NotificationsSettings({super.key});

  @override
  State<NotificationsSettings> createState() => _NotificationsSettingsState();
}

class _NotificationsSettingsState extends State<NotificationsSettings> {
  bool _emailNotifications = true;
  bool _pushNotifications = true;
  bool _smsNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: const Stack(
          children: [
            Center(
              child: Text('Notification Settings',
                  style: TextStyle(color: Colors.white, fontSize: 20)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSwitchTile(
              'Email Notifications',
              Icons.email,
              _emailNotifications,
              (bool value) {
                setState(() {
                  _emailNotifications = value;
                });
              },
            ),
            _buildSwitchTile(
              'Push Notifications',
              Icons.notifications,
              _pushNotifications,
              (bool value) {
                setState(() {
                  _pushNotifications = value;
                });
              },
            ),
            _buildSwitchTile(
              'SMS Notifications',
              Icons.sms,
              _smsNotifications,
              (bool value) {
                setState(() {
                  _smsNotifications = value;
                });
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  Widget _buildSwitchTile(
      String title, IconData icon, bool value, Function(bool) onChanged) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: Switch(
            activeColor: Colors.purple,
            value: value,
            onChanged: onChanged,
          ),
        ),
        const Divider(
          color: Colors.grey,
          thickness: 0.2,
        ),
      ],
    );
  }
}
