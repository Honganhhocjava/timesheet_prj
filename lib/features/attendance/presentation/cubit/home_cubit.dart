import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(const HomeState());

  void openRequestPage() {
    emit(state.copyWith(isRequestPage: true));
  }

  void closeRequestPage() {
    emit(state.copyWith(isRequestPage: false));
  }

  void selectTab(int index) {
    emit(state.copyWith(selectedTabIndex: index));
  }

  void setNotification(bool hasNotification) {
    emit(state.copyWith(hasNotification: hasNotification));
  }
}
