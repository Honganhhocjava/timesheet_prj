import 'package:timesheet_project/features/ai_assistant/data/datasources/gemini_remote_data_source.dart';
import 'package:timesheet_project/features/ai_assistant/data/models/question_models_mapper.dart';
import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';
import 'package:timesheet_project/features/ai_assistant/domain/repositories/survey_repository.dart';

class SurveyRepositoryImpl implements SurveyRepository {
  final GeminiRemote remoteDataSource;

  SurveyRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Question>> generateSurvey() async {
    final models = await remoteDataSource.generateSurvey();
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<String> sendAnswersToGemini(Map<int, String> answers) {
    return remoteDataSource.sendAnswersToAI(answers);
  }
}
