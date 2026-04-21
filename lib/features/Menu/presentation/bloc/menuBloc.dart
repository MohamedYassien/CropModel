import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_menu_usecase.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc() : super(MenuInitial()) {
    on<LoadMenuEvent>((event, emit) async {
      emit(MenuLoading());
      try {
        final categories = await GetMenuUseCase().call(event.restaurantId);
        emit(MenuLoaded(categories));
      } catch (e) {
        emit(MenuError(e.toString()));
      }
    });
  }
}