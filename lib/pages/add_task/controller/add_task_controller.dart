import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/const/enums/task_priority.dart';
import 'package:task_management_app/pages/home_page/controller/home_page_controller.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';
import 'package:task_management_app/services/connection_services.dart';
import 'package:task_management_app/services/persistent_data.service.dart';

final addTaskControllerProvider = Provider<AddTaskPageController?>((ref) {
  return AddTaskPageController(
    providerRef: ref,
  );
});

final selectedDateProvider = StateProvider<String?>((ref) {
  return null;
});

final selectedPriority = StateProvider.autoDispose<TaskPriority>((ref) {
  return TaskPriority.low;
});

class AddTaskPageController extends StateNotifier {
  AddTaskPageController({
    required this.providerRef,
  }) : super(null);

  ProviderRef providerRef;
  PersistentDataService database = PersistentDataService();

  Future<void> submitForm(
    GlobalKey<FormState> formKey,
    HiveTaskModel task,
    BuildContext context,
  ) async {
    try {
      await database.insertTask(
          task, await ConnectivityService.checkConnection());
      await providerRef.read(homePageController.notifier).getAllTask();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task added successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enable to add task'),
          backgroundColor: Colors.red,
        ),
      );
    }
    providerRef.read(selectedDateProvider.notifier).update((state) => null);
  }

  Future<void> updateTask(
    GlobalKey<FormState> formKey,
    HiveTaskModel task,
    BuildContext context, {
    String? title,
    String? description,
    String? date,
    String? priority,
    DateTime? updatedAt,
  }) async {
    if (formKey.currentState!.validate()) {
      try {
        await database.updateTask(
          task,
          await ConnectivityService.checkConnection(),
          title: title,
          description: description,
          date: date,
          priority: priority,
        );
        await providerRef.read(homePageController.notifier).getAllTask();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Task updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enable to edit task'),
            backgroundColor: Colors.red,
          ),
        );
      }
      providerRef.read(selectedDateProvider.notifier).update((state) => null);
    }
  }

  Future<void> deleteTask(
    HiveTaskModel task,
    BuildContext context,
  ) async {
    try {
      await database.deleteTask(
          task, await ConnectivityService.checkConnection());
      await providerRef.read(homePageController.notifier).getAllTask();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enable to delete task'),
          backgroundColor: Colors.red,
        ),
      );
    }
    providerRef.read(selectedDateProvider.notifier).update((state) => null);
  }
}
