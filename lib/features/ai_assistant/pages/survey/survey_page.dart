import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/ai_assistant/data/datasources/gemini_remote_data_source.dart';
import 'package:timesheet_project/features/ai_assistant/data/repositories/survey_repository_impl.dart';
import 'package:timesheet_project/features/ai_assistant/domain/usecases/gen_survey.dart';
import 'package:timesheet_project/features/ai_assistant/domain/usecases/send_answers.dart';
import 'package:timesheet_project/features/ai_assistant/pages/question/question_card.dart';
import 'package:timesheet_project/features/ai_assistant/pages/survey/survey_cubit.dart';
import 'package:timesheet_project/features/ai_assistant/pages/survey/survey_state.dart';


class SurveyPage extends StatelessWidget {
  const SurveyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SurveyCubit(
          GenerateSurvey(
            SurveyRepositoryImpl(
              GeminiRemoteImpl(),
            ),
          ),
          SendAnswersToGemini(SurveyRepositoryImpl(GeminiRemoteImpl())))
        ..loadSurvey(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Khảo sát')),
        body: BlocBuilder<SurveyCubit, SurveyState>(
          builder: (context, state) {
            if (state is SurveyLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SurveyError) {
              return Center(child: Text(state.message));
            } else if (state is SurveyResult) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Phản hồi từ AI:',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.feedback,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            context
                                .read<SurveyCubit>()
                                .loadSurvey();
                          },
                          child: const Text('Làm lại khảo sát'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (state is SurveyLoaded || state is SurveyCompleted) {
              final questions = (state as dynamic).questions;

              return ListView.builder(
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return QuestionCard(
                    key: ValueKey('question_$index'),
                    question: question,
                    index: index,
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
        bottomNavigationBar: BlocBuilder<SurveyCubit, SurveyState>(
          builder: (context, state) {
            if (state is SurveyCompleted) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    context.read<SurveyCubit>().submitAnswers();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã gửi kết quả lên AI')),
                    );
                  },
                  child: const Text('Gửi khảo sát'),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
