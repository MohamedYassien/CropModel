abstract class HomeState {}

class HomeInitial extends HomeState {}
class HomeLoading extends HomeState {}
class HomeSuccess extends HomeState {}
class HomeEmpty extends HomeState {}
class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
