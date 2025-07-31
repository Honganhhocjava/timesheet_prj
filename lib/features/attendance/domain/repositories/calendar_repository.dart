import 'package:timesheet_project/features/attendance/domain/entities/calendar_event_entity.dart';

abstract class CalendarRepository {
  Future<List<CalendarEventEntity>> getCalendarEvents(DateTime month);
  Future<List<CalendarEventEntity>> getEventsByDate(DateTime date);
}
