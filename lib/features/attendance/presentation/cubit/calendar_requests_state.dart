part of 'calendar_requests_cubit.dart';

abstract class CalendarRequestsState {}

class CalendarRequestsInitial extends CalendarRequestsState {}

class CalendarRequestsLoading extends CalendarRequestsState {}

class CalendarRequestsLoaded extends CalendarRequestsState {
  final Map<DateTime, CalendarDayRequests> requestsByDay;
  CalendarRequestsLoaded(this.requestsByDay);
}

class CalendarRequestsError extends CalendarRequestsState {
  final String message;
  CalendarRequestsError(this.message);
}
