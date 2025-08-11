import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/ai_assistant/pages/question/question_state.dart';

// not use
class QuestionCubit extends Cubit<QuestionState> {
  QuestionCubit() : super(QuestionState(selectedOptions: {}));

  void setOption(String questionId, String selectedOption) {
    final updated = Map<String, String>.from(state.selectedOptions);
    updated[questionId] = selectedOption;
    emit(state.copyWith(selectedOptions: updated));
  }
}
