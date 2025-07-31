
//not use
class QuestionState {
  final Map<String, String> selectedOptions;

  QuestionState({required this.selectedOptions});

  QuestionState copyWith({Map<String, String>? selectedOptions}) {
    return QuestionState(
      selectedOptions: selectedOptions ?? this.selectedOptions,
    );
  }
}
