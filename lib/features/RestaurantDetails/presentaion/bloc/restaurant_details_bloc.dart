import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Restaurant/domain/usecases/get_restaurant_details.dart';
import 'restaurant_details_event.dart';
import 'restaurant_details_state.dart';

class RestaurantDetailsBloc extends Bloc<RestaurantDetailsEvent, RestaurantDetailsState> {
  RestaurantDetailsBloc() : super(RestaurantDetailsInitial()) {
    on<LoadRestaurantDetailsEvent>((event, emit) async {
      emit(RestaurantDetailsLoading());
      try {
        final restaurant = await GetRestaurantDetailsUseCase().call(event.restaurantId);
        emit(RestaurantDetailsLoaded(restaurant));
      } catch (e) {
        emit(RestaurantDetailsError(e.toString()));
      }
    });
  }
}