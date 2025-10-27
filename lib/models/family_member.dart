import 'dart:convert';

class FamilyMember {
  final int? id;
  final String name;
  final String gender;
  final DateTime birthdate;
  final String? imagePath;
  final int? spouseId;
  final int? fatherId;
  final int? motherId;
  final List<int> childrenIds;

  FamilyMember({
    this.id,
    required this.name,
    required this.gender,
    required this.birthdate,
    this.imagePath,
    this.spouseId,
    this.fatherId,
    this.motherId,
    this.childrenIds = const [],
  });

  // คำนวณอายุ
  int get age {
    final now = DateTime.now();
    int age = now.year - birthdate.year;
    if (now.month < birthdate.month ||
        (now.month == birthdate.month && now.day < birthdate.day)) {
      age--;
    }
    return age;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'gender': gender,
      'birthdate': birthdate.toIso8601String(),
      'image_path': imagePath,
      'spouse_id': spouseId,
      'father_id': fatherId,
      'mother_id': motherId,
      'children_ids': jsonEncode(childrenIds),
    };
  }

  factory FamilyMember.fromMap(Map<String, dynamic> map) {
    return FamilyMember(
      id: map['id'],
      name: map['name'],
      gender: map['gender'],
      birthdate: DateTime.parse(map['birthdate']),
      imagePath: map['image_path'],
      spouseId: map['spouse_id'],
      fatherId: map['father_id'],
      motherId: map['mother_id'],
      childrenIds: map['children_ids'] != null
          ? List<int>.from(jsonDecode(map['children_ids']))
          : [],
    );
  }

  FamilyMember copyWith({
    int? id,
    String? name,
    String? gender,
    DateTime? birthdate,
    String? imagePath,
    int? spouseId,
    int? fatherId,
    int? motherId,
    List<int>? childrenIds,
  }) {
    return FamilyMember(
      id: id ?? this.id,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      birthdate: birthdate ?? this.birthdate,
      imagePath: imagePath ?? this.imagePath,
      spouseId: spouseId ?? this.spouseId,
      fatherId: fatherId ?? this.fatherId,
      motherId: motherId ?? this.motherId,
      childrenIds: childrenIds ?? this.childrenIds,
    );
  }
}