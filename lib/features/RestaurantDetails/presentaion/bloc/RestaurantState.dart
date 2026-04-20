import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../data/model/RestaurantModel.dart';

abstract class RestaurantState extends Equatable {
  const RestaurantState();
  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}

class RestaurantLoading extends RestaurantState {}

class RestaurantDetailsLoaded extends RestaurantState {
  final RestaurantModel? restaurant;
  final Set<Marker> markers;
  final CameraPosition cameraPosition;

  const RestaurantDetailsLoaded({
    required this.restaurant,
    required this.markers,
    required this.cameraPosition,
  });

  @override
  List<Object?> get props => [restaurant, markers, cameraPosition];
}

class RestaurantListLoaded extends RestaurantState {
  final List<RestaurantModel>? restaurants;
  const RestaurantListLoaded(this.restaurants);

  @override
  List<Object?> get props => [restaurants];
}

class RestaurantError extends RestaurantState {
  final String message;
  const RestaurantError(this.message);

  @override
  List<Object?> get props => [message];
}