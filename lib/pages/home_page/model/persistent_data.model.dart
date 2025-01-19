import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'persistent_data.model.g.dart';

@HiveType(typeId: 0)
class PersistentDataModel {
  const PersistentDataModel({
    this.taskList,
  });

  @HiveField(0)
  final List<HiveTaskModel>? taskList;

  PersistentDataModel copyWith({List<HiveTaskModel>? taskList}) {
    return PersistentDataModel(
      taskList: taskList ?? this.taskList,
    );
  }
}

// @HiveType(typeId: 2)
// List<HiveTaskModel>? task;

@HiveType(typeId: 1) // Unique typeId for TaskModel
class HiveTaskModel extends HiveObject {
  @HiveField(0)
  int? id;

  @HiveField(1)
  String? title;

  @HiveField(2)
  String? description;

  @HiveField(3)
  String? date;

  @HiveField(4)
  String? priority;

  @HiveField(5)
  bool? isSynced;

  @HiveField(6)
  DateTime? createdAt;

  @HiveField(7)
  DateTime? updatedAt;

  factory HiveTaskModel.fromJson(Map<String, dynamic> json) {
    return HiveTaskModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        description: json['description'] as String?,
        date: json['date'] as String?,
        priority: json['priority'] as String?,
        isSynced: json['isSynced'] as bool?,
        createdAt: (json['createdAt'] as Timestamp?)?.toDate(),
        updatedAt: (json['updatedAt'] as Timestamp?)?.toDate());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'priority': priority,
      'isSynced': isSynced,
      'createdAt': createdAt,
      'updatedAt': updatedAt
    };
  }

  HiveTaskModel copyWith({
    int? id,
    String? title,
    String? description,
    String? date,
    String? priority,
    bool? isSynced,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HiveTaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      isSynced: isSynced ?? this.isSynced,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  HiveTaskModel({
    this.id,
    this.title,
    this.description,
    this.date,
    this.priority,
    this.isSynced,
    this.createdAt,
    this.updatedAt,
  });
}

@HiveType(typeId: 2) // Ensure the typeId is unique across your app
class SyncQueueItem {
  @HiveField(0)
  final String operation; // e.g., CREATE, UPDATE, DELETE

  @HiveField(1)
  final int id; // The unique identifier for the task

  @HiveField(2)
  final DateTime timestamp; // When the operation occurred

  @HiveField(3)
  final HiveTaskModel? changes; // Changes made to the task, if any

  const SyncQueueItem({
    required this.operation,
    required this.id,
    required this.timestamp,
    this.changes,
  });

  // To convert a SyncQueueItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'operation': operation,
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'changes': changes,
    };
  }

  // To create a SyncQueueItem from JSON
  factory SyncQueueItem.fromJson(Map<String, dynamic> json) {
    return SyncQueueItem(
      operation: json['operation'],
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      changes: json['changes'] != null ? HiveTaskModel.fromJson(json) : null,
    );
  }
}
