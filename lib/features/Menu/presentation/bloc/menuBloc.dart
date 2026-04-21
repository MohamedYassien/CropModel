import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/get_menu_usecase.dart';
import 'menuEvent.dart';
import 'menuState.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final GetMenuUseCase getMenuUseCase;

  MenuBloc(this.getMenuUseCase) : super(MenuInitial()) {
    on<LoadMenu>((event, emit) async {
      emit(MenuLoading());
      try {
        final data = await getMenuUseCase.call(event.restaurantId);
        emit(MenuLoaded(data));
      } catch (e) {
        emit(MenuError("Failed to fetch menu"));
      }
    });
  }
}