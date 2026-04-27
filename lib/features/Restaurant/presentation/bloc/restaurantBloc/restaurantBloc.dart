import 'package:cropmodel/features/Restaurant/presentation/bloc/restaurantBloc/restaurantEvent.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/GetRestaurantsUseCase.dart';
import 'restaurantState.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial()) {
    on<LoadRestaurantsEvent>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurants = await GetRestaurantsUseCase().call();
        emit(RestaurantLoaded(restaurants));
      } catch (e) {
        emit(RestaurantError(e.toString()));
      }
    });
  }
}