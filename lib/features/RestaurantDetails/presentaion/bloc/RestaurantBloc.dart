import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/usecases/GetRestaurantDetails.dart';
import '../../domain/usecases/getRestaurantsList.dart';
import 'RestaurantEvent.dart';
import 'RestaurantState.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  // final GetRestaurantDetailsUseCase _getDetails = GetRestaurantDetailsUseCase();
  // final GetRestaurantsListUseCase _getList = GetRestaurantsListUseCase();

  RestaurantBloc() : super(RestaurantInitial()) {
    // on<FetchRestaurantDetails>(_onFetchDetails);
    // on<FetchRestaurantsList>(_onFetchList);
  }

  // Future<void> _onFetchDetails(
  //     FetchRestaurantDetails event,
  //     Emitter<RestaurantState> emit,
  //     ) async {
  //   emit(RestaurantLoading());
  //   try {
  //     // final restaurant = await _getDetails.call(event.restaurantId);
  //
  //     if (restaurant != null) {
  //       // Create Google Maps marker from API data
  //       final marker = Marker(
  //         markerId: MarkerId(restaurant.id),
  //         position: LatLng(restaurant.latitude, restaurant.longitude),
  //         infoWindow: InfoWindow(
  //           title: restaurant.name,
  //           snippet: restaurant.address,
  //         ),
  //       );
  //
  //       // Camera position centered on restaurant location from API
  //       final cameraPosition = CameraPosition(
  //         target: LatLng(restaurant.latitude, restaurant.longitude),
  //         zoom: 15,
  //       );
  //
  //       emit(RestaurantDetailsLoaded(
  //         restaurant: restaurant,
  //         markers: {marker},
  //         cameraPosition: cameraPosition,
  //       ));
  //     } else {
  //       emit(const RestaurantError('Restaurant not found'));
  //     }
  //   } catch (e) {
  //     emit(RestaurantError(e.toString()));
  //   }
  // }

  // Future<void> _onFetchList(
  //     FetchRestaurantsList event,
  //     Emitter<RestaurantState> emit,
  //     ) async {
  //   emit(RestaurantLoading());
  //   try {
  //     final restaurants = await _getList.call();
  //     emit(RestaurantListLoaded(restaurants));
  //   } catch (e) {
  //     emit(RestaurantError(e.toString()));
  //   }
  // }
}