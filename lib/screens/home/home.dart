import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import 'package:provider/provider.dart';
import 'package:task_list/data/repo/repository.dart';
import 'package:task_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:task_list/screens/edit/edit.dart';
import 'package:task_list/screens/home/bloc/home_bloc.dart';

import '../../data/data.dart';
import '../../main.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    EditTaskCubit(Task(), context.read<Repository<Task>>()),
                child: EditTaskScreen(),
              ),
            ));
          },
          label: Row(
            children: const [
              Text('Add New Task'),
              SizedBox(
                width: 5,
              ),
              Icon(
                CupertinoIcons.add,
              )
            ],
          )),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 110,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  themeData.colorScheme.primary,
                  themeData.colorScheme.primaryVariant
                ]),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'To Do List',
                        style: themeData.textTheme.headline6!
                            .apply(color: themeData.colorScheme.onPrimary),
                      ),
                      Icon(
                        CupertinoIcons.share,
                        color: themeData.colorScheme.onPrimary,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                        color: themeData.colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(19),
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              color: Colors.black.withOpacity(0.1))
                        ]),
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        context.read<HomeBloc>().add(HomeEventSerarch(value));
                      },
                      decoration: const InputDecoration(
                          prefixIcon: Icon(CupertinoIcons.search),
                          label: Text('Search tasks...'),
                          floatingLabelBehavior: FloatingLabelBehavior.never),
                    ),
                  )
                ]),
              ),
            ),
            Expanded(child: Consumer<Repository<Task>>(
              builder: (context, value, child) {
                context.read<HomeBloc>().add(HomeEventStarted());
                return BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeStateSuccess) {
                      return TaskList(items: state.items, themeData: themeData);
                    } else if (state is HomeStateEmpty) {
                      return const EmptyState();
                    } else if (state is HomeStateLoading ||
                        state is HomeStateInitial) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (state is HomeStateError) {
                      return Center(
                        child: Text(state.errorMessage),
                      );
                    } else {
                      throw Exception('stat is not valid..');
                    }
                  },
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<Task> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today',
                    style: themeData.textTheme.headline6!
                        .apply(fontSizeFactor: 0.9),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Container(
                    height: 3,
                    width: 70,
                    decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(1.5)),
                  )
                ],
              ),
              MaterialButton(
                color: const Color(0xffeaeff5),
                textColor: secondaryTextColor,
                elevation: 0,
                onPressed: () {
                  context.read<HomeBloc>().add(HomeEventDeletAll());
                },
                child: Row(
                  children: const [
                    Text('Delete All'),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      CupertinoIcons.delete_solid,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else {
          final Task task = items[index - 1];
          return TaskItem(task: task);
        }
      },
    );
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final Task task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final priorityColor;

    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriority;
        break;

      case Priority.normal:
        priorityColor = normalPriority;
        break;
      case Priority.high:
        priorityColor = primaryColor;
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlocProvider(
              create: (context) => EditTaskCubit(
                widget.task,
                context.read<Repository<Task>>(),
              ),
              child: EditTaskScreen(),
            ),
          ),
        );
      },
      onLongPress: () {
        context.read<HomeBloc>().add(HomeEventDelet(widget.task));
      },
      child: Container(
        height: 74,
        padding: const EdgeInsets.only(left: 16, right: 0),
        margin: const EdgeInsets.only(
          top: 8,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: themeData.colorScheme.surface,
            boxShadow: [
              BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(0.08))
            ]),
        child: Row(
          children: [
            MyCheckBox(
              onTap: () {
                setState(() {
                  widget.task.isCompleted = !widget.task.isCompleted;
                });
              },
              value: widget.task.isCompleted,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Text(
                widget.task.name,
                style: TextStyle(
                    overflow: TextOverflow.fade,
                    decoration: widget.task.isCompleted
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Container(
              width: 5,
              height: 84,
              decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8))),
            )
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;
  MyCheckBox({super.key, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: value ? primaryColor : null,
          borderRadius: BorderRadius.circular(12),
          border: !value
              ? Border.all(
                  width: 2,
                  color: secondaryTextColor,
                )
              : null,
        ),
        child: value
            ? Icon(
                CupertinoIcons.check_mark,
                color: themeData.colorScheme.onPrimary,
                size: 16,
              )
            : null,
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        SvgPicture.asset(
          'assets/images/empty_state.svg',
          height: 130,
        ),
        const SizedBox(height: 12),
        const Text('Your task list is empty'),
      ],
    );
  }
}
