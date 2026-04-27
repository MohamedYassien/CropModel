import 'package:equatable/equatable.dart';

import '../../../data/model/restaurant_model.dart';

abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {}

class FavoritesLoading extends FavoritesState {}

class FavoritesLoaded extends FavoritesState {
  final List<RestaurantModel> favoriteRestaurants;

  const FavoritesLoaded(this.favoriteRestaurants);

  @override
  List<Object?> get props => [favoriteRestaurants];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
