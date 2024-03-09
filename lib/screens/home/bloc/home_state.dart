part of 'home_bloc.dart';

abstract class HomeState {}

class HomeStateInitial extends HomeState {}

class HomeStateLoading extends HomeState {}

class HomeStateSuccess extends HomeState {
  final List<Task> items;

  HomeStateSuccess(this.items);
}

class HomeStateEmpty extends HomeState {}

class HomeStateError extends HomeState {
  final String errorMessage;
  HomeStateError(this.errorMessage);
}
