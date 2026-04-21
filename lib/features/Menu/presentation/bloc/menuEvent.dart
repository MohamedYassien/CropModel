abstract class MenuEvent {}
class LoadMenu extends MenuEvent {
  final String restaurantId;
  LoadMenu(this.restaurantId);
}