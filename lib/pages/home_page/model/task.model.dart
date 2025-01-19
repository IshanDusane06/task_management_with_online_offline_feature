import 'package:json_annotation/json_annotation.dart';

part 'task.model.g.dart';

@JsonSerializable()
class TaskModel {
  final int? id;
  final String? title;
  final String? description;
  final String? date;
  final String? priority;

  const TaskModel({
    this.id,
    this.title,
    this.description,
    this.date,
    this.priority,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) =>
      _$TaskModelFromJson(json);

  Map<String, dynamic> toJson() => _$TaskModelToJson(this);

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'date': date,
      'repeatAt': priority,
    };
  }
}
