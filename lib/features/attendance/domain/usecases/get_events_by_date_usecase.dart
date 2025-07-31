import 'package:timesheet_project/features/attendance/domain/entities/calendar_event_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/calendar_repository.dart';

class GetEventsByDateUseCase {
  final CalendarRepository _repository;

  GetEventsByDateUseCase(this._repository);

  Future<List<CalendarEventEntity>> call(DateTime date) async {
    return await _repository.getEventsByDate(date);
  }
}
