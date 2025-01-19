import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_management_app/pages/home_page/controller/home_page_controller.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';
import 'package:task_management_app/services/firebase_service.dart';

class SyncManager {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///this function is called every time the devices comes online to sync with
  ///firebase. It checks if there are any pending CRUD operation. If there are
  ///it pushes then to firebase
  static Future<void> syncData(WidgetRef providerRef) async {
    try {
      // final taskBox;
      // if (Hive.isBoxOpen('tasks')) {
      //   taskBox = Hive.box('tasks');
      // } else {
      //   final box = await Hive.openBox('tasks');
      //   taskBox = Hive.box('tasks');
      // }
      // final syncQueue = await Hive.openBox('sync_queue');
      await Hive.close();

      bool isBoxOpen = Hive.isBoxOpen('tasks');
      final Box taskBox = isBoxOpen
          ? Hive.box('tasks')
          : await Hive.openBox<HiveTaskModel>('tasks');

      // Open the 'sync_queue' box if not already open
      final Box<SyncQueueItem> syncQueue = Hive.isBoxOpen('syncQueue')
          ? Hive.box('syncQueue')
          : await Hive.openBox('syncQueue');

      //checks if there are any pending operations
      if (syncQueue.length > 0) {
        int i = 0;
        for (SyncQueueItem change in syncQueue.values) {
          final changeMap = change;
          final operation = changeMap.operation;
          final taskId = changeMap.id;

          //takes necessary action for pending actions

          if (operation == 'CREATE') {
            await FirebaseService.saveTaskToFirebase(changeMap.changes!);
            // await _firestore
            //     .collection('tasks')
            //     .doc(taskId)
            //     .set(changeMap.changes!.toJson());
          } else if (operation == 'UPDATE') {
            await FirebaseService.updateTask(changeMap.changes!);

            // await _firestore
            //     .collection('tasks')
            //     .doc(taskId)
            //     .update(changeMap.changes!.toJson());
          } else if (operation == 'DELETE') {
            await FirebaseService.deleteTask(changeMap.changes!);

            // await _firestore.collection('tasks').doc(taskId).delete();
          }

          //updates the provider value to show the syncing progress.
          i = i + 1;
          providerRef
              .read(progressIndicatorProvider.notifier)
              .update((state) => i / syncQueue.length);
        }
        // Pull updates from Firebase
        final remoteTasks = await _firestore.collection('tasks').get();
        for (var doc in remoteTasks.docs) {
          taskBox.put(doc.data()['id'], HiveTaskModel.fromJson(doc.data()));
        }
        // Clear the sync queue
        await syncQueue.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  /// this functions setups the real time listener for firebase
  void setupRealTimeListener(BuildContext context, WidgetRef providerRef) {
    try {
      final tasksCollection = FirebaseFirestore.instance.collection('tasks');

      tasksCollection.snapshots().listen((querySnapshot) async {
        bool isBoxOpen = Hive.isBoxOpen('tasks');
        final Box<HiveTaskModel> taskBox;
        if (isBoxOpen) {
          taskBox = Hive.box<HiveTaskModel>('tasks');
        } else {
          taskBox = await Hive.openBox<HiveTaskModel>('tasks');
        }
        //= isBoxOpen
        //     ? Hive.box<HiveTaskModel>('tasks')
        //     : await Hive.openBox<HiveTaskModel>('tasks');

        // final taskBox = Hive.box<HiveTaskModel>('tasks');

        for (var change in querySnapshot.docChanges) {
          final doc = change.doc;
          final taskId = doc.data()?['id'];
          final taskData = doc.data();

          if (change.type == DocumentChangeType.added) {
            if (taskBox.containsKey(taskId)) {
              final task = taskBox.get(taskId);
              taskBox.put(taskId, HiveTaskModel.fromJson(taskData!));
              // taskBox.put(taskBox.keys.last + 1, task!);
            } else {
              taskBox.put(taskId, HiveTaskModel.fromJson(taskData!));
            }
            await providerRef.read(homePageController.notifier).getAllTask();
          } else if (change.type == DocumentChangeType.modified) {
            final task = taskBox.get(taskId);
            final firebaseTaskData = HiveTaskModel.fromJson(taskData!);
            //if the local changes are more recently updated then updates the
            //firebase or updates the local DB
            if (task?.updatedAt
                    ?.isAfter(firebaseTaskData.updatedAt ?? DateTime.now()) ??
                false) {
              FirebaseService.updateTask(task!);
            } else {
              taskBox.put(taskId, HiveTaskModel.fromJson(taskData));
            }
            await providerRef.read(homePageController.notifier).getAllTask();
          } else if (change.type == DocumentChangeType.removed) {
            // checks if the task is already not been removed when it was online
            // if it was, does nothing other wise deletes its from local DB.
            if (taskBox.containsKey(taskId)) {
              taskBox.delete(taskId);
            }
            await providerRef.read(homePageController.notifier).getAllTask();
          }
        }
        querySnapshot.docChanges.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Something went wrong while listing to the updates of Firebase'),
        ),
      );
    }
  }
}
