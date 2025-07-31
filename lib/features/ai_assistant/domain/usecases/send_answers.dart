import 'package:timesheet_project/features/ai_assistant/domain/repositories/survey_repository.dart';

class SendAnswersToGemini {
  final SurveyRepository repository;

  SendAnswersToGemini(this.repository);

  Future<String> call(Map<int, String> answers) {
    return repository.sendAnswersToGemini(answers);
  }
}
