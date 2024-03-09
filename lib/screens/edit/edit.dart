import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'package:task_list/data/data.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';

import '../../data/repo/repository.dart';
import '../../main.dart';

class EditTaskScreen extends StatefulWidget {
  EditTaskScreen({
    super.key,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller;

  @override
  void initState() {
    _controller = TextEditingController(
        text: context.read<EditTaskCubit>().state.task.name);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    Color priorityColor;
    return Scaffold(
      backgroundColor: themeData.colorScheme.surface,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            context.read<EditTaskCubit>().onSaveChangesClick();
            Navigator.pop(context);
          },
          label: Row(
            children: const [
              Text('Save Changes'),
              SizedBox(
                width: 5,
              ),
              Icon(
                CupertinoIcons.check_mark,
                size: 18,
              )
            ],
          )),
      appBar: AppBar(
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        elevation: 0,
        title: Text('Edit Task'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(children: [
            BlocBuilder<EditTaskCubit, EditTaskState>(
              builder: (context, state) {
                final priority = state.task.priority;
                return Flex(
                  direction: Axis.horizontal,
                  children: [
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Priority.high);
                          },
                          label: 'High',
                          color: primaryColor,
                          isSelected: priority == Priority.high,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Priority.normal);
                          },
                          label: 'Normal',
                          color: normalPriority,
                          isSelected: priority == Priority.normal,
                        )),
                    const SizedBox(
                      width: 8,
                    ),
                    Flexible(
                        flex: 1,
                        child: PriorityCheckBox(
                          onTap: () {
                            context
                                .read<EditTaskCubit>()
                                .onPriorityChanged(Priority.low);
                          },
                          label: 'Low',
                          color: lowPriority,
                          isSelected: priority == Priority.low,
                        )),
                  ],
                );
              },
            ),
            TextField(
              controller: _controller,
              onChanged: (value) {
                context.read<EditTaskCubit>().onTextChange(value);
              },
              maxLines: 20,
              decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.always,
                label: Text(
                  'Add a task for today',
                  style:
                      themeData.textTheme.bodyText1!.apply(fontSizeFactor: 1.2),
                ),
              ),
            )
          ]),
        ),
      ),
    );
  }
}

class PriorityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;

  PriorityCheckBox(
      {super.key,
      required this.label,
      required this.color,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
          height: 40,
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  width: 2, color: secondaryTextColor.withOpacity(0.2))),
          child: Stack(
            children: [
              Center(child: Text(label)),
              Positioned(
                  right: 8,
                  top: 0,
                  bottom: 0,
                  child: Center(
                      child: PriorityMyCheckBox(
                    value: isSelected,
                    color: color,
                  )))
            ],
          )),
    );
  }
}

class PriorityMyCheckBox extends StatelessWidget {
  final bool value;
  final Color color;
  PriorityMyCheckBox({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 12,
            )
          : null,
    );
  }
}
