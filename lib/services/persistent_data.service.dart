import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';
import 'package:task_management_app/services/firebase_service.dart';

class PersistentDataService {
  // static var hiveBox;
  // static var dataBox;

  static Future initHiveBox() async {
    // hiveBox = Hive.openBox<PersistentDataModel>('data');
    // dataBox = Hive.box<PersistentDataModel>('data');
  }

  Future<List<HiveTaskModel>> getAllTask() async {
    try {
      // await initHiveBox();
      await Hive.openBox<HiveTaskModel>('tasks');
      return Hive.box<HiveTaskModel>('tasks')
          .values
          .toList()
          .cast<HiveTaskModel>();

      // dataBox.get(key)
    } catch (e) {
      throw FlutterError('Unable to fetch users preferences');
    }
  }

  Future<void> insertTask(HiveTaskModel task, bool isInternetConnected) async {
    try {
      final box = await Hive.openBox<HiveTaskModel>('tasks');
      final syncQueueBox = await Hive.openBox<SyncQueueItem>('syncQueue');

      HiveTaskModel originalTask = task;
      await box.add(task);
      await task.save();

      //if device is not connected to internet store that actions
      if (!isInternetConnected) {
        final newItem = SyncQueueItem(
          operation: 'CREATE',
          id: task.id ?? task.key,
          timestamp: DateTime.now(),
          changes: task.copyWith(
            id: task.id ?? task.key,
          ),
        );
        final id = await syncQueueBox.add(newItem);
        print('id of new item: $id');
      }

      //if device is connected to internet update the firebase
      if (isInternetConnected) {
        await FirebaseService.saveTaskToFirebase(
          task.copyWith(
            id: task.key,
            isSynced: true,
            createdAt: task.createdAt,
            updatedAt: task.updatedAt,
          ),
        ).then((value) =>
            updateTask(originalTask, isInternetConnected, isSynced: true));
      }
    } catch (e) {
      print(e);
    }
  }

  /// Update data in Hive
  // Future<void> updateTask(HiveTaskModel task, int index) async {
  //   final box = await Hive.openBox<PersistentDataModel>('data');

  //   // Get the current data
  //   final currentData = box.get('taskList');
  //   if (currentData == null || currentData.taskList == null) return;

  //   final updatedTaskList = currentData.taskList!.map((task) {
  //     if (task.id == task.id) {
  //       // Replace the task with the updated one

  //       return task;
  //     }
  //     return task;
  //   }).toList();

  //   // Create a new PersistentDataModel with the updated task list
  //   final updatedData = currentData.copyWith(taskList: updatedTaskList);

  //   // Save the updated data
  //   await box.put('persistentData', updatedData);
  //   await box.close();
  // }

  Future<void> updateTask(
    HiveTaskModel task,
    bool isInternetConnected, {
    String? title,
    String? description,
    String? date,
    String? priority,
    bool? isSynced,
    DateTime? updatedAt,
  }) async {
    try {
      final box = await Hive.openBox<HiveTaskModel>('tasks');
      final syncQueueBox = await Hive.openBox<SyncQueueItem>('syncQueue');

      task.title = title ?? task.title;
      task.description = description ?? task.description;
      task.date = date ?? task.date;
      task.priority = priority ?? task.description;
      task.isSynced = isSynced ?? task.isSynced;
      task.updatedAt = updatedAt ?? task.updatedAt;
      box.put(task.id ?? task.key, task);
      await task.save();

      //if device is not connected to internet store that actions
      if (!isInternetConnected) {
        final newItem = SyncQueueItem(
          operation: 'UPDATE',
          id: task.id ?? task.key,
          timestamp: DateTime.now(),
          changes: task.copyWith(
            id: task.id ?? task.key,
          ),
        );
        syncQueueBox.add(newItem);
      }

      //if device is connected to internet update the firebase
      if (isInternetConnected) {
        FirebaseService.updateTask(
          task,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  /// Update data in Hive
  // Future<void> deleteTask(int taskId) async {
  //   final box = await Hive.openBox<PersistentDataModel>('data');

  //   // Get the current data
  //   final currentData = box.get('taskList');
  //   if (currentData == null || currentData.taskList == null) return;

  //   final updatedTaskList =
  //       currentData.taskList!.where((task) => task.id != taskId).toList();

  //   // Create a new PersistentDataModel with the updated task list
  //   final updatedData = currentData.copyWith(taskList: updatedTaskList);

  //   // Save the updated data
  //   await box.put('persistentData', updatedData);
  //   await box.close();
  // }

  Future deleteTask(HiveTaskModel task, bool isInternetConnected) async {
    // final box = await Hive.openBox<PersistentDataModel>('data');
    try {
      final syncQueueBox = await Hive.openBox<SyncQueueItem>('syncQueue');

      //if device is not connected to internet store that actions
      if (!isInternetConnected) {
        final newItem = SyncQueueItem(
          operation: 'DELETE',
          id: task.id ?? task.key,
          timestamp: DateTime.now(),
          changes: task.copyWith(
            id: task.id ?? task.key,
          ),
        );
        syncQueueBox.add(newItem);
      }

      //if device is connected to internet update the firebase
      if (isInternetConnected) {
        FirebaseService.deleteTask(task);
      }
      await task.delete();
    } catch (e) {
      throw FlutterError('Something went wrong while deleting the task');
    }
  }
}
