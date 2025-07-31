import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';

abstract class SurveyState {}

class SurveyInitial extends SurveyState {}

class SurveyLoading extends SurveyState {}

class SurveyLoaded extends SurveyState {
  final List<Question> questions;
  final Map<int, String> answers;

  SurveyLoaded({required this.questions, required this.answers});
}

class SurveyCompleted extends SurveyState {
  final List<Question> questions;
  final Map<int, String> answers;

  SurveyCompleted({required this.questions, required this.answers});
}

class SurveyError extends SurveyState {
  final String message;

  SurveyError(this.message);
}
class SurveyResult extends SurveyState {
  final String feedback;

  SurveyResult(this.feedback);
}

