import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';
import 'package:timesheet_project/features/ai_assistant/pages/survey/survey_cubit.dart';


class QuestionCard extends StatefulWidget {
  final Question question;
  final int index;

  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Câu ${widget.index + 1}: ${widget.question.question}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...widget.question.options.map(
              (option) => RadioListTile<String>(
                title: Text(option),
                value: option,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() => selectedOption = value);
                  if (value != null) {
                    context.read<SurveyCubit>().setAnswer(widget.index, value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
