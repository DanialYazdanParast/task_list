part of 'home_bloc.dart';

abstract class HomeEvent {}

class HomeEventStarted extends HomeEvent {}

class HomeEventSerarch extends HomeEvent {
  final String serarchTerm;
  HomeEventSerarch(this.serarchTerm);
}

class HomeEventDeletAll extends HomeEvent {}

class HomeEventDelet extends HomeEvent {
  final Task task;
  HomeEventDelet(this.task);
}
