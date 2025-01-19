import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';
import 'package:task_management_app/services/persistent_data.service.dart';
import 'package:task_management_app/router/router.dart';

final homePageController =
    StateNotifierProvider<HomePageController, List<HiveTaskModel>?>(
  (ref) => HomePageController(
    providerRef: ref,
  ),
);

final isConnectedToInternet = StateProvider<bool?>(
  (ref) => null,
);

final progressIndicatorProvider = StateProvider<double?>(
  (ref) => null,
);

class HomePageController extends StateController<List<HiveTaskModel>?> {
  HomePageController({
    required this.providerRef,
  }) : super(null);
  StateNotifierProviderRef providerRef;
  PersistentDataService database = PersistentDataService();
  Future<void> getAllTask() async {
    try {
      List<HiveTaskModel> allTask = await database.getAllTask();
      // List<HiveTaskModel> allTask = await FirebaseService.getAllTasks();
      // List<HiveTaskModel>? allTask = null;
      if (allTask.isNotEmpty) {
        state = allTask;
      } else {
        throw FlutterError('Unable to fetch task');
      }
    } on FlutterError catch (error) {
      ScaffoldMessenger.of(providerRef
              .read(Routes.appRoutes)
              .configuration
              .navigatorKey
              .currentContext!)
          .showSnackBar(
        SnackBar(
          content: Text(error.message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(providerRef
              .read(Routes.appRoutes)
              .configuration
              .navigatorKey
              .currentContext!)
          .showSnackBar(
        const SnackBar(
          content: Text('Something went wrong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
