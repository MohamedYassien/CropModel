import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/room/data/model/room.dart';

class RoomState {
  final bool loadingRestaurants;
  final String? errorMessage;
  final List<RestaurantModel> restaurants;
  final RestaurantModel? selectedRestaurant;
  final List<Room> openRooms;

  const RoomState({
    required this.loadingRestaurants,
    required this.errorMessage,
    required this.restaurants,
    required this.selectedRestaurant,
    required this.openRooms,
  });

  factory RoomState.initial() {
    return const RoomState(
      loadingRestaurants: false,
      errorMessage: null,
      restaurants: <RestaurantModel>[],
      selectedRestaurant: null,
      openRooms: <Room>[],
    );
  }

  RoomState copyWith({
    bool? loadingRestaurants,
    String? errorMessage,
    List<RestaurantModel>? restaurants,
    RestaurantModel? selectedRestaurant,
    List<Room>? openRooms,
  }) {
    return RoomState(
      loadingRestaurants: loadingRestaurants ?? this.loadingRestaurants,
      errorMessage: errorMessage,
      restaurants: restaurants ?? this.restaurants,
      selectedRestaurant: selectedRestaurant ?? this.selectedRestaurant,
      openRooms: openRooms ?? this.openRooms,
    );
  }
}
