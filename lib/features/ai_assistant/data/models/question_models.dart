import 'package:freezed_annotation/freezed_annotation.dart';

part 'question_models.g.dart';

part 'question_models.freezed.dart';

@freezed
abstract class QuestionModel with _$QuestionModel {
  const QuestionModel._();

  const factory QuestionModel({
    required String id,
    required String question,
    required List<String> options,
    required String answer,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}
