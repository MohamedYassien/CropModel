abstract class RestaurantEvent {}

class FetchRestaurantDetails extends RestaurantEvent {
  final String restaurantId;
  FetchRestaurantDetails(this.restaurantId);
}

class FetchRestaurantsList extends RestaurantEvent {}

class RefreshRestaurant extends RestaurantEvent {}