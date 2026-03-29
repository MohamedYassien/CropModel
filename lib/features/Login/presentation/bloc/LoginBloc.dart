import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/service/BiometricService.dart';
import '../../data/service/SecureStorage.dart';
import 'LoginEvent.dart';
import 'LoginState.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final BiometricService biometricService;
  final SecureStorage secureStorage;

  LoginBloc({
    required this.biometricService,
    required this.secureStorage,
  }) : super(LoginInitial()) {
     on<LoginWithEmailEvent>(_onLogin);
    on<BiometricLoginEvent>(_onBiometricLogin);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onLogin(
      LoginWithEmailEvent event, Emitter<LoginState> emit) async {
    emit(LoginLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));

      await secureStorage.saveEmail(event.email);
      await secureStorage.savePassword(event.password);

      emit(LoginSuccess());
    } catch (e) {
      emit(LoginFailure(e.toString()));
    }
  }

  Future<void> _onBiometricLogin(
      BiometricLoginEvent event, Emitter<LoginState> emit) async {

    final isEnabled = await secureStorage.isBiometricEnabled();
    print("Biometric enabled value: $isEnabled");
    if (!isEnabled) {
      emit(LoginFailure('Biometric login not enabled'));
      return;
    }

    final isAvailable = await biometricService.checkBiometricAvailability();
    if (!isAvailable) {
      emit(BiometricNotAvailable());
      return;
    }

    final authenticated = await biometricService.authenticate();
    if (!authenticated) {
      emit(LoginFailure('Biometric authentication failed'));
      return;
    }

    final email = await secureStorage.getEmail();
    final password = await secureStorage.getPassword();

    print("Saved email: '$email'");
    print("Saved password: '$password'");

    if (email.isNotEmpty && password.isNotEmpty) {
      emit(LoginSuccess());
    } else {
      emit(LoginFailure('No saved credentials found'));
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<LoginState> emit) async {
    final biometricEnabled = await secureStorage.isBiometricEnabled();

    if (!biometricEnabled) {
      await secureStorage..clearData();
    }

    emit(LoginInitial());
  }
}
