import 'package:timesheet_project/features/attendance/domain/entities/calendar_event_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/calendar_repository.dart';

class GetCalendarEventsUseCase {
  final CalendarRepository _repository;

  GetCalendarEventsUseCase(this._repository);

  Future<List<CalendarEventEntity>> call(DateTime month) async {
    return await _repository.getCalendarEvents(month);
  }
}
