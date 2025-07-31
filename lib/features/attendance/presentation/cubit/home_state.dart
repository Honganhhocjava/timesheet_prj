class HomeState {
  final bool isRequestPage;
  final int selectedTabIndex;
  final bool hasNotification;

  const HomeState({
    this.isRequestPage = false,
    this.selectedTabIndex = 0,
    this.hasNotification = false,
  });

  HomeState copyWith({
    bool? isRequestPage,
    int? selectedTabIndex,
    bool? hasNotification,
  }) {
    return HomeState(
      isRequestPage: isRequestPage ?? this.isRequestPage,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
      hasNotification: hasNotification ?? this.hasNotification,
    );
  }
}
