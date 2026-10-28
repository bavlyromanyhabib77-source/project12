part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}
class GetTodosLoading extends HomeState{}
class GetTodosError extends HomeState{
  final String message;

  GetTodosError(this.message);
}
class GetTodosSuccess extends HomeState{
  final List<Todo> todos;

  GetTodosSuccess(this.todos);
}