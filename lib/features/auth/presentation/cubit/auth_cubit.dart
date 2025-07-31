import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/auth/data/repositories/auth_repository.dart';
import 'package:timesheet_project/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(AuthInitial());

  Future<void> signUp(String email, String password) async {
    emit(AuthLoading());
    try {
      User? user = await _authRepository.signUpWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Đăng ký thất bại. Vui lòng thử lại.'));
      }
    } catch (e) {
      emit(AuthError('Lỗi: $e'));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      User? user = await _authRepository.signInWithEmailAndPassword(
        email,
        password,
      );
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthError('Đăng nhập thất bại. Vui lòng kiểm tra kết nối đường truyền.'));
      }
    } catch (e) {
      emit(AuthError('Lỗi: $e'));
    }
  }

  Future<void> signOut() async {
    emit(AuthLoading());
    try {
      await _authRepository.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError('Lỗi đăng xuất: $e'));
    }
  }

  void getCurrentUser() {
    User? user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthSignedOut());
    }
  }

  void resetState() {
    emit(AuthInitial());
  }
}
