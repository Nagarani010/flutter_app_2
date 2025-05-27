import 'package:flutter/material.dart'; 
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Follow Up',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: const HealthFollowUpPage(),
    );
  }
}

List<Map<String, String>> notifications = [];

class HealthFollowUpPage extends StatefulWidget {
  const HealthFollowUpPage({super.key});

  @override
  State<HealthFollowUpPage> createState() => _HealthFollowUpPageState();
}

class _HealthFollowUpPageState extends State<HealthFollowUpPage> {
  File? _image;
  final TextEditingController studentNameController = TextEditingController();
  final TextEditingController rollNoController = TextEditingController();
  final TextEditingController roomNoController = TextEditingController();

  bool showRedDot = false;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
    }
  }

  void _submitDietSheet() {
    if (studentNameController.text.isEmpty ||
        rollNoController.text.isEmpty ||
        roomNoController.text.isEmpty) {
      return;
    }

    notifications.add({
      'type': 'Diet Sheet',
      'name': studentNameController.text,
      'roll': rollNoController.text,
      'room': roomNoController.text,
    });

    _saveNotifications();

    setState(() {
      studentNameController.clear();
      rollNoController.clear();
      roomNoController.clear();
      _image = null;
      showRedDot = true;
    });
  }

  void _openNotifications() {
    setState(() {
      showRedDot = false;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NotificationScreen()),
    );
  }

  void _loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedData = prefs.getString('notifications');
    if (savedData != null) {
      setState(() {
        notifications = List<Map<String, String>>.from(json.decode(savedData));
      });
    }
  }

  void _saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', json.encode(notifications));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002366),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
        title: const Text("Health Follow Up", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.white),
                onPressed: _openNotifications,
              ),
              if (showRedDot)
                const Positioned(
                  right: 11,
                  top: 11,
                  child: CircleAvatar(radius: 5, backgroundColor: Colors.red),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Health Alerts", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ParentHealthAlertScreen()),
                      );
                      if (result == true) {
                        setState(() => showRedDot = true);
                        _saveNotifications();
                      }
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset("lib/assets/parents_alert.jpg", height: 100, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 5),
                        const Text("Parents Health Alert"),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const StaffHealthAlertScreen()),
                      );
                      if (result == true) {
                        setState(() => showRedDot = true);
                        _saveNotifications();
                      }
                    },
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset("lib/assets/staff_alert.jpg", height: 100, fit: BoxFit.cover),
                        ),
                        const SizedBox(height: 5),
                        const Text("Staff Health Alert"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text("Diet Sheet for Hostellers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildTextField("Student name", controller: studentNameController),
            _buildTextField("Roll No", controller: rollNoController),
            _buildTextField("Hostel Room No", controller: roomNoController),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: DottedBorder(
                borderType: BorderType.RRect,
                radius: const Radius.circular(12),
                dashPattern: const [6, 3],
                color: Colors.grey,
                child: Container(
                  height: 120,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: _image != null
                      ? Image.file(_image!, height: 100)
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add, size: 30, color: Colors.blue),
                            Text("Select Your Image here", style: TextStyle(color: Colors.blue)),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitDietSheet,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF002366),
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Submit", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class ParentHealthAlertScreen extends StatelessWidget {
  const ParentHealthAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final rollController = TextEditingController();
    final classController = TextEditingController();
    final parentController = TextEditingController();
    final staffController = TextEditingController();
    final medController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002366),
        title: const Text('Parent Health Alerts', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text("Enter the Valid Medication Details:", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildTextField("Student name", controller: nameController),
            _buildTextField("Roll No", controller: rollController),
            _buildTextField("Class", controller: classController),
            _buildTextField("Parent name", controller: parentController),
            _buildTextField("Staff Name", controller: staffController),
            _buildTextField("Medication details", controller: medController, maxLines: 4),
            const SizedBox(height: 20),
            _buildSubmitButton(() {
              notifications.add({
                'type': 'Parents Health Alert',
                'location': 'West Street, Chennai',
                'time': '9:00 AM',
              });
              Navigator.pop(context, true);
            }),
          ],
        ),
      ),
    );
  }
}

class StaffHealthAlertScreen extends StatelessWidget {
  const StaffHealthAlertScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final idController = TextEditingController();
    final reasonController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002366),
        title: const Text('Staff Health Alert', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField("Staff Name", controller: nameController),
            _buildTextField("Staff ID", controller: idController),
            _buildTextField("Reason for leave", controller: reasonController, maxLines: 3),
            const SizedBox(height: 20),
            _buildSubmitButton(() {
              notifications.add({
                'type': 'Staff Health Alert',
                'location': 'East Avenue, Chennai',
                'time': '10:00 AM',
              });
              Navigator.pop(context, true);
            }),
          ],
        ),
      ),
    );
  }
}

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002366),
        title: const Text("Health Follow Up", style: TextStyle(color: Colors.white)),
        leading: const BackButton(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final item = notifications[index];
          if (item['type'] == 'Diet Sheet') {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                title: const Text("Diet Sheet Submitted"),
                subtitle: Text("Room: ${item['room']}\nRoll No: ${item['roll']}\nName: ${item['name']}"),
              ),
            );
          } else {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(
                    item['type'] == 'Parents Health Alert'
                        ? "lib/assets/parents_alert.jpg"
                        : "lib/assets/staff_alert.jpg",
                  ),
                ),
                title: Text(item['type']!),
                subtitle: Text("${item['location']}\nToday"),
                trailing: Text(item['time']!),
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _buildTextField(String hint, {int maxLines = 1, TextEditingController? controller}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

Widget _buildSubmitButton(VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF002366),
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
    child: const Text("Submit", style: TextStyle(color: Colors.white)),
  );
}