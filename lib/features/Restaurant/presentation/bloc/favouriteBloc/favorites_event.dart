import 'package:equatable/equatable.dart';

import '../../../data/model/restaurant_model.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final RestaurantModel restaurant;

  const ToggleFavoriteEvent(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final String restaurantId;

  const RemoveFavoriteEvent(this.restaurantId);

  @override
  List<Object?> get props => [restaurantId];
}

class ClearFavoritesEvent extends FavoritesEvent {}
