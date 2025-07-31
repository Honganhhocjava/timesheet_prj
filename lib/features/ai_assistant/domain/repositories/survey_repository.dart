import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';

abstract class SurveyRepository {
  Future<List<Question>> generateSurvey();
  Future<String> sendAnswersToGemini(Map<int, String> answers);
}
