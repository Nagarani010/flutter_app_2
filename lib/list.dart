import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

import 'model.dart';

class DietSheetList extends StatefulWidget {
  const DietSheetList({super.key});

  @override
  State<DietSheetList> createState() => _DietSheetListState();
}

class _DietSheetListState extends State<DietSheetList> {
  List<DietSheetEntry> entries = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('diet_entries');
    if (data != null) {
      setState(() {
        entries = DietSheetEntry.decode(data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF5FF),
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        title: const Text("Health Follow Up", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: entries.isEmpty
          ? const Center(child: Text("No entries submitted yet."))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: FileImage(File(entry.imagePath)),
                      ),
                      title: const Text(
                        "Student Health Alerts",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Name: ${entry.name}"),
                          Text("Room No: ${entry.roomNumber}"),
                          Text("Roll No: ${entry.rollNumber}"),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}