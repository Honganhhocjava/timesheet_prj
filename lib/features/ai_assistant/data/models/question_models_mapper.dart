import 'package:timesheet_project/features/ai_assistant/data/models/question_models.dart';
import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';

extension QuestionModelX on QuestionModel {
  Question toEntity() => Question(
    id: id,
    question: question,
    options: options,
    answer: answer,
  );
}

extension QuestionX on Question {
  QuestionModel toModel() => QuestionModel(
    id: id,
    question: question,
    options: options,
    answer: answer,
  );
}
