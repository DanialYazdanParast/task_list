part of 'edit_task_cubit.dart';

abstract class EditTaskState {
  final Task task;
const  EditTaskState(this.task);
}

class EditTaskInitial extends EditTaskState {
 const EditTaskInitial(super.task);
}

class EditTaskPriorityChange extends EditTaskState {
 const EditTaskPriorityChange(super.task);
  
}
