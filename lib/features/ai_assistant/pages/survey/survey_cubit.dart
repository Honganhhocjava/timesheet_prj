import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';
import 'package:timesheet_project/features/ai_assistant/domain/usecases/gen_survey.dart';
import 'package:timesheet_project/features/ai_assistant/domain/usecases/send_answers.dart';
import 'survey_state.dart';

class SurveyCubit extends Cubit<SurveyState> {
  final GenerateSurvey _generateSurvey;
  final SendAnswersToGemini _sendAnswersToGemini;

  List<Question> _questions = [];
  final Map<int, String> _answers = {};

  SurveyCubit(this._generateSurvey, this._sendAnswersToGemini)
      : super(SurveyInitial());

  void loadSurvey() async {
    emit(SurveyLoading());
    try {
      final questions = await _generateSurvey.genSurvey();
      _questions = questions;
      emit(SurveyLoaded(questions: questions, answers: {}));
    } catch (e) {
      emit(SurveyError("Không thể tải khảo sát: $e"));
    }
  }

  void setAnswer(int index, String answer) {
    _answers[index] = answer;
    if (_answers.length == _questions.length) {
      emit(SurveyCompleted(questions: _questions, answers: _answers));
    } else {
      emit(SurveyLoaded(questions: _questions, answers: _answers));
    }
  }

  void submitAnswers() async {
    emit(SurveyLoading());
    try {
      final feedback = await _sendAnswersToGemini(_answers);
      emit(SurveyResult(feedback));
    } catch (e) {
      emit(SurveyError("Lỗi gửi lên AI: $e"));
    }
  }
}
