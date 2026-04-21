import 'package:equatable/equatable.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object> get props => [];
}

class LoadMenuEvent extends MenuEvent {
  final String restaurantId;

  const LoadMenuEvent(this.restaurantId);

  @override
  List<Object> get props => [restaurantId];
}