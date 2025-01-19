import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<List<HiveTaskModel>> getAllTasks() async {
    try {
      // Reference to the tasks collection
      final taskCollection = _firestore.collection('tasks');

      // Get all documents from the collection
      final querySnapshot = await taskCollection.get();

      // Map the documents to a list of HiveTaskModel
      final tasks = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return HiveTaskModel(
          id: data['id'] as int?,
          title: data['title'] as String?,
          description: data['description'] as String?,
          date: data['date'] as String?,
          priority: data['priority'] as String?,
        );
      }).toList();
      return tasks;
    } catch (e) {
      return [];
    }
  }

  /// Save a task to Firebase
  static Future<DocumentReference<Map<String, dynamic>>> saveTaskToFirebase(
      HiveTaskModel task) async {
    try {
      return await _firestore.collection('tasks').add(task.toJson());
    } catch (e) {
      throw FlutterError('Something went wrong while add data');
    }
  }

  static Future<void> addTask(HiveTaskModel task) async {
    try {
      // Reference to the tasks collection
      final taskCollection = FirebaseFirestore.instance.collection('tasks');

      // Perform a transaction to handle concurrent additions
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        // Check if a task with the same ID already exists
        final querySnapshot = await taskCollection
            .where('id', isEqualTo: task.key ?? task.id)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return;
        }

        // Add the new task
        final taskData = {
          'id': task.id,
          'title': task.title,
          'description': task.description,
          'date': task.date,
          'priority': task.priority,
          'createdAt': task.createdAt,
          'updatedAt': task.updatedAt,
        };

        // Generate a new document reference and set the data in the transaction
        final newTaskDoc = taskCollection.doc();
        transaction.set(newTaskDoc, taskData);
      });
    } catch (e) {}
  }

  // //Not using this function for syncing
  // static Future<void> syncTasksToFirebase() async {
  //   try {
  //     List<HiveTaskModel>? allTask = await PersistentDataService().getAllTask();
  //     // PersistentDataModel? allTask = null;
  //     if (allTask.isNotEmpty) {
  //       List<HiveTaskModel>? getAllUnsyncedTask = allTask
  //           .where((task) => (task.isSynced == false || task.isSynced == null))
  //           .toList();
  //       if (getAllUnsyncedTask.isNotEmpty) {
  //         for (var task in getAllUnsyncedTask) {
  //           await saveTaskToFirebase(task.copyWith(
  //             isSynced: true,
  //             id: task.key ?? task.id,
  //           ));
  //         }
  //       }
  //     }
  //   } catch (e) {
  //     throw FlutterError('Something went wrong while uploading data');
  //   }
  // }

  // static Future<void> updateTask1(HiveTaskModel task) async {
  //   try {
  //     // Reference to the tasks collection
  //     final taskCollection = _firestore.collection('tasks');

  //     // Query the task with the matching ID
  //     final querySnapshot = await taskCollection
  //         .where('id', isEqualTo: task.key ?? task.id)
  //         .get();

  //     if (querySnapshot.docs.isNotEmpty) {
  //       // Get the document ID for the task
  //       final docId = querySnapshot.docs.first.id;

  //       // Update the task document
  //       await taskCollection.doc(docId).update(task.toJson());
  //     } else {}
  //   } catch (e) {}
  // }

  static Future<void> updateTask(HiveTaskModel task) async {
    try {
      // Reference to the tasks collection
      final taskCollection = FirebaseFirestore.instance.collection('tasks');

      // Query the task with the matching ID
      final querySnapshot = await taskCollection
          .where('id', isEqualTo: task.key ?? task.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document reference for the task
        final taskDoc = querySnapshot.docs.first.reference;

        // Perform a transaction to handle concurrent updates
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          // Read the current task document
          final snapshot = await transaction.get(taskDoc);

          if (!snapshot.exists) {
            return;
          }

          // Optionally merge existing fields with new ones
          final updatedData = {
            'title': task.title ?? snapshot['title'],
            'description': task.description ?? snapshot['description'],
            'date': task.date ?? snapshot['date'],
            'priority': task.priority ?? snapshot['priority'],
            'updatedAt': task.updatedAt ?? snapshot['updatedAt'],
          };

          // Update the task document in the transaction
          transaction.update(taskDoc, updatedData);
        });
      }
    } catch (e) {}
  }

  static Future<void> deleteTask(HiveTaskModel task) async {
    try {
      // Reference to the tasks collection
      final taskCollection = _firestore.collection('tasks');

      // Query the task with the matching ID
      final querySnapshot = await taskCollection
          .where('id', isEqualTo: task.key ?? task.id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Get the document ID for the task
        final docId = querySnapshot.docs.first.id;

        // Delete the task document
        await taskCollection.doc(docId).delete();
      } else {}
    } catch (e) {
      rethrow;
    }
  }
}
