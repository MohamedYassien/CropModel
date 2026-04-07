import 'package:get_it/get_it.dart';

import '../../features/Change_password/data/repositories/change_password_repository_impl.dart';
import '../../features/Change_password/data/service/change_password_service.dart';
import '../../features/Change_password/domain/repositories/change_password_repository.dart';
import '../../features/Change_password/domain/usecases/change_password_usecase.dart';
import '../../features/Change_password/presentaion/bloc/Change_password_bloc.dart';
import '../network/api_client.dart';

final GetIt sl = GetIt.instance;

Future<void> setupServiceLocator() async {

  sl.registerLazySingleton<APIClient>(() => APIClient());

  sl.registerLazySingleton<ChangePasswordService>(
    () => ChangePasswordService(sl<APIClient>()),
  );
  sl.registerLazySingleton<ChangePasswordRepository>(
    () => ChangePasswordRepositoryImpl(sl<ChangePasswordService>()),
  );
  sl.registerLazySingleton<ChangePasswordUseCase>(
    () => ChangePasswordUseCase(sl<ChangePasswordRepository>()),
  );
  sl.registerFactory<ChangePasswordBloc>(
    () => ChangePasswordBloc(
      changePasswordUseCase: sl<ChangePasswordUseCase>(),
    ),
  );
}
