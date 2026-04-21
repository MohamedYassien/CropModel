// import 'package:cropmodel/features/HomePage/domain/usecases/lastorder_usecases.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import 'homepage_state.dart';
//
// class HomeBloc extends Bloc<HomeEvent, HomeState> {
//   final LastOrderUseCase getLastOrders;
//
//   HomeBloc(this.getLastOrders) : super(HomeInitial()) {
//     on<LastOrderUseCase>((event, emit) async {
//       emit(HomeLoading());
//
//       final result = await LastOrderUseCase();
//
//       result.fold(
//             (failure) => emit(HomeError(failure.message)),
//             (orders) {
//           if (orders.isEmpty) {
//             emit(HomeEmpty());
//           } else {
//             emit(HomeSuccess(orders));
//           }
//         },
//       );
//     });
//   }
// }