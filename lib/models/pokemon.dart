import 'package:cloud_firestore/cloud_firestore.dart';

class Pokemon {
  final String? id;
  final String name;
  final String type;
  final int level;
  final DateTime createdAt;

  Pokemon({
    this.id,
    required this.name,
    required this.type,
    required this.level,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Pokemon.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Pokemon(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      level: data['level'] ?? 1,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'type': type,
      'level': level,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  Pokemon copyWith({
    String? id,
    String? name,
    String? type,
    int? level,
    DateTime? createdAt,
  }) {
    return Pokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'Pokemon{ id: $id, name: $name, type: $type, level: $level }';
  }
}
