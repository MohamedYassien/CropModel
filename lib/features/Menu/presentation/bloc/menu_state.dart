import 'package:equatable/equatable.dart';

import '../../data/model/menu_model.dart';

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<MenuCategoryModel> categories;

  const MenuLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class MenuError extends MenuState {
  final String message;

  const MenuError(this.message);

  @override
  List<Object?> get props => [message];
}