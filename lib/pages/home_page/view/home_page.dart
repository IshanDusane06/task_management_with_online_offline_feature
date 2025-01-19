import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:task_management_app/pages/add_task/controller/add_task_controller.dart';
import 'package:task_management_app/pages/add_task/views/add_task.dart';
import 'package:task_management_app/pages/home_page/controller/home_page_controller.dart';
import 'package:task_management_app/pages/home_page/widgets/task.widget.dart';
import 'package:task_management_app/services/connection_services.dart';
import 'package:task_management_app/services/sync_manager.service.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});
  static const String id = '/home-page';

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ConnectivityService _connectivityService = ConnectivityService();
  late Stream<bool> _connectionStream;
  @override
  void initState() {
    SyncManager().setupRealTimeListener(context, ref);

    _connectionStream = _connectivityService.connectionStatusStream;

    _connectionStream.listen((isConnected) async {
      print('internet connected: $isConnected');

      if (isConnected) {
        // ref.read(isConnectedToInternet.notifier).update((state) => isConnected);
        // await FirebaseService.syncTasksToFirebase();
        await SyncManager.syncData(ref);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(homePageController.notifier).getAllTask();
      // final result = await _connectivityService.checkConnection();
    });
    super.initState();
  }

  @override
  void dispose() async {
    ConnectivityService().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Tasks'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        color: Colors.black,
        child: Consumer(
          builder: (context, ref, child) {
            final allTask = ref.watch(homePageController);
            return Visibility(
              visible: allTask != null,
              replacement: Visibility(
                  visible: allTask != null && allTask.isEmpty,
                  replacement: const Center(
                      child: Center(
                    child: Text(
                      'Add Task',
                      style: TextStyle(color: Colors.pinkAccent, fontSize: 30),
                    ),
                  )),
                  child: const Center(
                    child: Text('Add Task'),
                  )),
              child: ListView.builder(
                itemCount: allTask?.length ?? 0,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GestureDetector(
                      onTap: () {
                        context.go('${HomePage.id}/${AddTask.id}', extra: {
                          'task': allTask?[index],
                          'isUpdate': true,
                        });
                      },
                      child: Dismissible(
                        direction: DismissDirection.startToEnd,
                        key: Key(allTask?[index].key.toString() ?? ''),
                        onDismissed: (direction) {
                          ref
                              .read(addTaskControllerProvider)
                              ?.deleteTask(allTask![index], context);
                        },
                        background: Container(color: Colors.red),
                        secondaryBackground: Row(children: const [
                          Icon(Icons.delete),
                          SizedBox(
                            width: 10,
                          ),
                          Text('Delete')
                        ]),
                        child: TasksTile(
                          title: allTask?[index].title ?? '',
                          description: allTask?[index].description ?? '',
                          date: allTask?[index].date ?? '',
                          priority: allTask?[index].priority ?? 'low',
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('${HomePage.id}/${AddTask.id}'),
        tooltip: 'Increment',
        child: Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.purpleAccent],
            ),
          ),
          child: const Icon(
            Icons.add,
            size: 40,
          ),
        ),
      ),
      bottomNavigationBar: Consumer(
        builder: (context, ref, child) {
          final progress = ref.watch(progressIndicatorProvider);
          if (progress == null) {
            return const SizedBox.shrink();
          } else {
            return Container(
              color: Colors.black,
              child: Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(
                  10,
                ),
                decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () =>
                          ref.invalidate(progressIndicatorProvider),
                      icon: const Icon(
                        Icons.close_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            progress == 1
                                ? 'Data Sync Completed'
                                : 'Syncing Data to DB',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          LinearProgressIndicator(
                            value: ref.watch(progressIndicatorProvider),
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation<Color?>(
                                Colors.blue[500]),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
