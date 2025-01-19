import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:task_management_app/const/enums/task_priority.dart';
import 'package:task_management_app/pages/add_task/views/add_task.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';
import 'package:task_management_app/pages/home_page/model/task.model.dart';
import 'package:task_management_app/pages/home_page/view/home_page.dart';

class Routes {
  static final appRoutes = Provider(
    (ref) => GoRouter(
      initialLocation: HomePage.id,
      routes: [
        GoRoute(
            path: HomePage.id,
            pageBuilder: (context, state) => const NoTransitionPage(
                  child: HomePage(),
                ),
            routes: [
              GoRoute(
                  path: AddTask.id,
                  pageBuilder: (context, state) {
                    if (state.extra != null) {
                      return NoTransitionPage(
                        child: AddTask(
                          task: (state.extra! as Map)['task'],
                          isUpdate: (state.extra! as Map)['isUpdate'],
                        ),
                      );
                    } else {
                      return const NoTransitionPage(
                        child: AddTask(),
                      );
                    }
                  }),
            ])
      ],
    ),
  );
}

/// Custom transition page with no transition.
class NoTransitionPage<T> extends CustomTransitionPage<T> {
  /// Constructor for a page with no transition functionality.
  const NoTransitionPage({
    required super.child,
    super.name,
    super.arguments,
    super.restorationId,
    super.key,
  }) : super(
          transitionsBuilder: _transitionsBuilder,
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        );

  static Widget _transitionsBuilder(
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child) =>
      child;
}
