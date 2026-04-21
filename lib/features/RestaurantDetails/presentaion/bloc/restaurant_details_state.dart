import 'package:equatable/equatable.dart';
import '../../../Restaurant/data/model/restaurant_model.dart';

abstract class RestaurantDetailsState extends Equatable {
  const RestaurantDetailsState();

  @override
  List<Object?> get props => [];
}

class RestaurantDetailsInitial extends RestaurantDetailsState {}

class RestaurantDetailsLoading extends RestaurantDetailsState {}

class RestaurantDetailsLoaded extends RestaurantDetailsState {
  final RestaurantModel restaurant;

  const RestaurantDetailsLoaded(this.restaurant);

  @override
  List<Object?> get props => [restaurant];
}

class RestaurantDetailsError extends RestaurantDetailsState {
  final String message;

  const RestaurantDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}