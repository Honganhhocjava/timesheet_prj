import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/attendance/domain/entities/calendar_event_entity.dart';
import 'package:timesheet_project/features/attendance/domain/repositories/calendar_repository.dart';

class CalendarRepositoryImpl implements CalendarRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<CalendarEventEntity>> getCalendarEvents(DateTime month) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final startOfMonth = DateTime(month.year, month.month, 1);
      final endOfMonth = DateTime(month.year, month.month + 1, 0);

      print('DEBUG: Getting calendar events for user: ${user.uid}');
      print(
        'DEBUG: Month range: ${startOfMonth.toIso8601String()} to ${endOfMonth.toIso8601String()}',
      );

      final List<CalendarEventEntity> events = [];

      // First, let's check ALL requests for this user (without date filter)
      final allLeaveDocs = await _firestore
          .collection('leave_requests')
          .where('idUser', isEqualTo: user.uid)
          .get();

      final allOvertimeDocs = await _firestore
          .collection('overtime_requests')
          .where('idUser', isEqualTo: user.uid)
          .get();

      final allAttendanceDocs = await _firestore
          .collection('attendance_adjustments')
          .where('idUser', isEqualTo: user.uid)
          .get();

      print('DEBUG: User has ${allLeaveDocs.docs.length} total leave requests');
      print(
        'DEBUG: User has ${allOvertimeDocs.docs.length} total overtime requests',
      );
      print(
        'DEBUG: User has ${allAttendanceDocs.docs.length} total attendance adjustments',
      );

      // Debug: Check if any requests are in current month
      final currentMonth = DateTime.now();
      final currentMonthStart = DateTime(
        currentMonth.year,
        currentMonth.month,
        1,
      );
      final currentMonthEnd = DateTime(
        currentMonth.year,
        currentMonth.month + 1,
        0,
      );

      print(
        'DEBUG: Current month range: ${currentMonthStart.toIso8601String()} to ${currentMonthEnd.toIso8601String()}',
      );

      // Check leave requests in current month
      int currentMonthLeaves = 0;
      for (final doc in allLeaveDocs.docs) {
        final data = doc.data();
        final startDate = DateTime.tryParse(data['startDate'] ?? '');
        if (startDate != null &&
            startDate.isAfter(
              currentMonthStart.subtract(const Duration(days: 1)),
            ) &&
            startDate.isBefore(currentMonthEnd.add(const Duration(days: 1)))) {
          currentMonthLeaves++;
          print(
            'DEBUG: Found leave request in current month: ${doc.id} - ${data['status']} - ${startDate.toIso8601String()}',
          );
        }
      }
      print('DEBUG: Found $currentMonthLeaves leave requests in current month');

      // Show some sample data
      if (allLeaveDocs.docs.isNotEmpty) {
        final sampleDoc = allLeaveDocs.docs.first;
        final sampleData = sampleDoc.data();
        print('DEBUG: Sample leave request data: ${sampleData.keys}');
        print('DEBUG: Sample leave request status: ${sampleData['status']}');
        print(
          'DEBUG: Sample leave request startDate: ${sampleData['startDate']}',
        );
      }

      // Get leave requests for the month
      final leaveDocs = await _firestore
          .collection('leave_requests')
          .where('idUser', isEqualTo: user.uid)
          .where(
            'startDate',
            isGreaterThanOrEqualTo: startOfMonth.toIso8601String(),
          )
          .where('startDate', isLessThanOrEqualTo: endOfMonth.toIso8601String())
          .get();

      print(
        'DEBUG: Found ${leaveDocs.docs.length} leave requests for this month',
      );

      for (final doc in leaveDocs.docs) {
        final data = doc.data();
        final startDate = DateTime.tryParse(data['startDate'] ?? '');
        if (startDate != null) {
          events.add(
            CalendarEventEntity(
              id: doc.id,
              requestId: doc.id,
              requestType: 'leave',
              status: data['status'] ?? 'pending',
              date: startDate,
              title: 'Đơn nghỉ phép',
              reason: data['reason'] ?? '',
            ),
          );
          print(
            'DEBUG: Added leave request: ${doc.id} - ${data['status']} - ${startDate.toIso8601String()}',
          );
        }
      }

      // Get overtime requests
      final overtimeDocs = await _firestore
          .collection('overtime_requests')
          .where('idUser', isEqualTo: user.uid)
          .where(
            'overtimeDate',
            isGreaterThanOrEqualTo: startOfMonth.toIso8601String(),
          )
          .where(
            'overtimeDate',
            isLessThanOrEqualTo: endOfMonth.toIso8601String(),
          )
          .get();

      print(
        'DEBUG: Found ${overtimeDocs.docs.length} overtime requests for this month',
      );

      for (final doc in overtimeDocs.docs) {
        final data = doc.data();
        final overtimeDate = DateTime.tryParse(data['overtimeDate'] ?? '');
        if (overtimeDate != null) {
          events.add(
            CalendarEventEntity(
              id: doc.id,
              requestId: doc.id,
              requestType: 'overtime',
              status: data['status'] ?? 'pending',
              date: overtimeDate,
              title: 'Đơn làm thêm giờ',
              reason: data['reason'] ?? '',
            ),
          );
          print(
            'DEBUG: Added overtime request: ${doc.id} - ${data['status']} - ${overtimeDate.toIso8601String()}',
          );
        }
      }

      // Get attendance adjustments
      final attendanceDocs = await _firestore
          .collection('attendance_adjustments')
          .where('idUser', isEqualTo: user.uid)
          .where(
            'adjustmentDate',
            isGreaterThanOrEqualTo: startOfMonth.toIso8601String(),
          )
          .where(
            'adjustmentDate',
            isLessThanOrEqualTo: endOfMonth.toIso8601String(),
          )
          .get();

      print(
        'DEBUG: Found ${attendanceDocs.docs.length} attendance adjustments for this month',
      );

      for (final doc in attendanceDocs.docs) {
        final data = doc.data();
        final adjustmentDate = DateTime.tryParse(data['adjustmentDate'] ?? '');
        if (adjustmentDate != null) {
          events.add(
            CalendarEventEntity(
              id: doc.id,
              requestId: doc.id,
              requestType: 'attendance',
              status: data['status'] ?? 'pending',
              date: adjustmentDate,
              title: 'Đơn điều chỉnh chấm công',
              reason: data['reason'] ?? '',
            ),
          );
          print(
            'DEBUG: Added attendance adjustment: ${doc.id} - ${data['status']} - ${adjustmentDate.toIso8601String()}',
          );
        }
      }

      print('DEBUG: Total events found: ${events.length}');

      // Debug: Show all events found
      for (final event in events) {
        print(
          'DEBUG: Event: ${event.title} - ${event.status} - ${event.date.toIso8601String()}',
        );
      }

      return events;
    } catch (e) {
      print('DEBUG: Error in getCalendarEvents: $e');
      throw Exception('Lỗi khi lấy dữ liệu calendar: $e');
    }
  }

  @override
  Future<List<CalendarEventEntity>> getEventsByDate(DateTime date) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return [];

      final dateString = date.toIso8601String().split(
        'T',
      )[0]; // YYYY-MM-DD format
      final List<CalendarEventEntity> events = [];

      // Get leave requests for the specific date
      final leaveDocs = await _firestore
          .collection('leave_requests')
          .where('idUser', isEqualTo: user.uid)
          .get();

      for (final doc in leaveDocs.docs) {
        final data = doc.data();
        final startDate = DateTime.tryParse(data['startDate'] ?? '');
        final endDate = DateTime.tryParse(data['endDate'] ?? '');

        if (startDate != null && endDate != null) {
          // Check if the date falls within the leave period
          if (date.isAfter(startDate.subtract(const Duration(days: 1))) &&
              date.isBefore(endDate.add(const Duration(days: 1)))) {
            events.add(
              CalendarEventEntity(
                id: doc.id,
                requestId: doc.id,
                requestType: 'leave',
                status: data['status'] ?? 'pending',
                date: startDate,
                title: 'Đơn nghỉ phép',
                reason: data['reason'] ?? '',
              ),
            );
          }
        }
      }

      // Get overtime requests for the specific date
      final overtimeDocs = await _firestore
          .collection('overtime_requests')
          .where('idUser', isEqualTo: user.uid)
          .get();

      for (final doc in overtimeDocs.docs) {
        final data = doc.data();
        final overtimeDate = DateTime.tryParse(data['overtimeDate'] ?? '');

        if (overtimeDate != null) {
          final overtimeDateString = overtimeDate.toIso8601String().split(
            'T',
          )[0];
          if (dateString == overtimeDateString) {
            events.add(
              CalendarEventEntity(
                id: doc.id,
                requestId: doc.id,
                requestType: 'overtime',
                status: data['status'] ?? 'pending',
                date: overtimeDate,
                title: 'Đơn làm thêm giờ',
                reason: data['reason'] ?? '',
              ),
            );
          }
        }
      }

      // Get attendance adjustments for the specific date
      final attendanceDocs = await _firestore
          .collection('attendance_adjustments')
          .where('idUser', isEqualTo: user.uid)
          .get();

      for (final doc in attendanceDocs.docs) {
        final data = doc.data();
        final adjustmentDate = DateTime.tryParse(data['adjustmentDate'] ?? '');

        if (adjustmentDate != null) {
          final adjustmentDateString = adjustmentDate.toIso8601String().split(
            'T',
          )[0];
          if (dateString == adjustmentDateString) {
            events.add(
              CalendarEventEntity(
                id: doc.id,
                requestId: doc.id,
                requestType: 'attendance',
                status: data['status'] ?? 'pending',
                date: adjustmentDate,
                title: 'Đơn điều chỉnh chấm công',
                reason: data['reason'] ?? '',
              ),
            );
          }
        }
      }

      return events;
    } catch (e) {
      throw Exception('Lỗi khi lấy dữ liệu events theo ngày: $e');
    }
  }
}
