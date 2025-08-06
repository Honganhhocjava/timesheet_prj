import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/ai_assistant/domain/entities/question.dart';
import 'package:timesheet_project/features/ai_assistant/pages/survey/survey_cubit.dart';


class QuestionCard extends StatefulWidget {
  final Question question;
  final int index;
  final String? selectedAnswer;


  const QuestionCard({
    super.key,
    required this.question,
    required this.index,
    required this.selectedAnswer,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedAnswer; // Khởi tạo khi widget được tạo
  }

  @override
  void didUpdateWidget(covariant QuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Nếu selectedAnswer trong widget thay đổi thì cập nhật lại state
    if (widget.selectedAnswer != oldWidget.selectedAnswer) {
      setState(() {
        selectedOption = widget.selectedAnswer;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16).copyWith(bottom: 0),
            child: Text(
              'Câu ${widget.index + 1}: ${widget.question.question}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          ...widget.question.options.map(
                (option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              activeColor: Color(0xFF003E83),
              groupValue: selectedOption,

              onChanged: (value) {
                setState(() => selectedOption = value);
                if (value != null) {
                  context.read<SurveyCubit>().setAnswer(widget.index, value);
                }
              },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

