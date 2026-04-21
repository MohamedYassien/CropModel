import 'package:cropmodel/features/Restaurant/presentation/bloc/restaurantEvent.dart';
import 'package:cropmodel/features/Restaurant/presentation/bloc/restaurantState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/GetRestaurantsUseCase.dart';


class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final GetRestaurantsUseCase getRestaurantsUseCase;

  RestaurantBloc(this.getRestaurantsUseCase) : super(RestaurantInitial()) {

    on<LoadRestaurants>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurants = await getRestaurantsUseCase.call();
        if (restaurants.isEmpty) {
          emit(RestaurantError("No restaurants found"));
        } else {
          emit(RestaurantLoaded(restaurants));
        }
      } catch (e) {
        emit(RestaurantError("Failed to fetch restaurants: ${e.toString()}"));
      }
    });
  }
}