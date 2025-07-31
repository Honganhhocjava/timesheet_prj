import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';
import 'package:timesheet_project/features/ai_assistant/domain/repositories/survey_repository.dart';

class GenerateSurvey {
  final SurveyRepository repository;

  GenerateSurvey(this.repository);

  Future<List<Question>> genSurvey() async {
    return await repository.generateSurvey();
  }
}
