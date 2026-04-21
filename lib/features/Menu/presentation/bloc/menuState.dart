import '../../data/model/menu_model.dart';

abstract class MenuState {}
class MenuInitial extends MenuState {}
class MenuLoading extends MenuState {}
class MenuLoaded extends MenuState {
  final List<MenuCategoryModel> categories;
  final int selectedCategoryIndex;
  MenuLoaded(this.categories, {this.selectedCategoryIndex = 0});
}
class MenuError extends MenuState {
  final String message;
  MenuError(this.message);
}