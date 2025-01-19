import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/const/enums/task_priority.dart';
import 'package:task_management_app/pages/add_task/controller/add_task_controller.dart';
import 'package:task_management_app/pages/home_page/controller/home_page_controller.dart';
import 'package:task_management_app/pages/home_page/model/persistent_data.model.dart';

class AddTask extends ConsumerStatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();

  static const String id = 'add-task-page';

  const AddTask({
    this.task,
    this.isUpdate = false,
  });

  final bool isUpdate;
  final HiveTaskModel? task;
}

class _AddTaskState extends ConsumerState<AddTask> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;

  void _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2031));

    // await showDatePicker(
    //   context: context,
    //   initialDate: DateTime.now(),
    //   firstDate: DateTime(2000),
    //   lastDate: DateTime(2100),
    // );

    if (pickedDate != null) {
      setState(() {
        _selectedDate = DateTime.parse(pickedDate.toString());
      });
    }
  }

  @override
  void initState() {
    _titleController.text =
        widget.task?.title != null ? widget.task!.title! : '';
    _descriptionController.text =
        widget.task?.description != null ? widget.task!.description! : '';
    _selectedDate =
        widget.task?.date != null ? DateTime.parse(widget.task!.date!) : null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Task'),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Input
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                          colors: [Colors.pinkAccent, Colors.purpleAccent])
                      .createShader(bounds);
                },
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _titleController,
                  decoration: InputDecoration(
                    // labelText: "Title",
                    // focusColor: Colors.pinkAccent,
                    label: const Text(
                      'Title',
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                    floatingLabelStyle:
                        const TextStyle(color: Colors.pinkAccent),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Description Input
              ShaderMask(
                shaderCallback: (bounds) {
                  return const LinearGradient(
                          colors: [Colors.pinkAccent, Colors.purpleAccent])
                      .createShader(bounds);
                },
                child: TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    // labelText: "Description",
                    label: const Text(
                      'Description',
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      // borderSide: BorderSide(),
                    ),
                    //fillColor: Colors.green
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: const BorderSide(
                        color: Colors.purpleAccent,
                      ),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Date Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'No date selected'
                          : 'Selected Date: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}',
                      style: const TextStyle(
                          color: Colors.pinkAccent, fontSize: 18),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Colors.pinkAccent, Colors.purpleAccent],
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ElevatedButton(
                      onPressed: _pickDate,
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent),
                      child: const Text('Pick Date'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  const Text(
                    'Priority:',
                    style: TextStyle(color: Colors.pinkAccent, fontSize: 18),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Consumer(
                    builder: (context, ref, child) {
                      // final selectedPriorityProvider =
                      //     ref.watch(selectedPriority);
                      final selectedPriorityProvider =
                          ref.watch(selectedPriority);

                      // Determine the current value for the DropdownButton
                      final currentPriority = widget.task?.priority != null
                          ? (widget.task!.priority == 'low'
                              ? TaskPriority.low
                              : widget.task!.priority == 'moderate'
                                  ? TaskPriority.moderate
                                  : TaskPriority.high)
                          : selectedPriorityProvider;
                      return DropdownButton<TaskPriority>(
                        value: currentPriority,
                        style: const TextStyle(
                            color: Colors.pinkAccent, fontSize: 18),
                        items: [
                          DropdownMenuItem<TaskPriority>(
                            value: TaskPriority.low,
                            child: Text(TaskPriority.low.name),
                          ),
                          DropdownMenuItem<TaskPriority>(
                            value: TaskPriority.moderate,
                            child: Text(TaskPriority.moderate.name),
                          ),
                          DropdownMenuItem<TaskPriority>(
                            value: TaskPriority.high,
                            child: Text(TaskPriority.high.name),
                          ),
                        ],
                        dropdownColor: Colors.black.withOpacity(0.8),
                        onChanged: (value) => {
                          widget.task?.priority = null,
                          ref
                              .read(selectedPriority.notifier)
                              .update((state) => value!),
                          if (widget.task != null)
                            {
                              widget.task!.priority = null,
                            }
                        },
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              // Submit Button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Colors.pinkAccent, Colors.purpleAccent],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (!widget.isUpdate) {
                        await ref.read(addTaskControllerProvider)?.submitForm(
                              _formKey,
                              HiveTaskModel(
                                title: _titleController.text,
                                description: _descriptionController.text,
                                date: _selectedDate?.toIso8601String(),
                                priority: ref.read(selectedPriority).name,
                                createdAt: DateTime.now(),
                                updatedAt: DateTime.now(),
                              ),
                              context,
                            );
                      } else {
                        await ref.read(addTaskControllerProvider)?.updateTask(
                              _formKey,
                              widget.task!,
                              context,
                              title: _titleController.text,
                              description: _descriptionController.text,
                              priority: ref.read(selectedPriority).name,
                              date: _selectedDate!.toIso8601String(),
                              updatedAt: DateTime.now(),
                            );
                      }
                      _titleController.clear();
                      _descriptionController.clear();
                      _selectedDate = null;
                      await ref.read(homePageController.notifier).getAllTask();
                      context.pop();
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('One or more values are empty'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: Text(widget.isUpdate ? 'Update Task' : 'Add Task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
