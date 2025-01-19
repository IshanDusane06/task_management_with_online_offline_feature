// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      date: json['date'] as String?,
      priority: json['priority'] as String?,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': instance.date,
      'priority': instance.priority,
    };
