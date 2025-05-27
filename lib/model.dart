import 'dart:convert';

class DietSheetEntry {
  final String name;
  final String roomNumber;
  final String rollNumber;
  final String imagePath;

  DietSheetEntry({
    required this.name,
    required this.roomNumber,
    required this.rollNumber,
    required this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'roomNumber': roomNumber,
    'rollNumber': rollNumber,
    'imagePath': imagePath,
  };

  factory DietSheetEntry.fromJson(Map<String, dynamic> json) {
    return DietSheetEntry(
      name: json['name'],
      roomNumber: json['roomNumber'],
      rollNumber: json['rollNumber'],
      imagePath: json['imagePath'],
    );
  }

  static String encode(List<DietSheetEntry> entries) =>
      json.encode(entries.map((e) => e.toJson()).toList());

  static List<DietSheetEntry> decode(String entries) =>
      (json.decode(entries) as List<dynamic>)
          .map((item) => DietSheetEntry.fromJson(item))
          .toList();
}