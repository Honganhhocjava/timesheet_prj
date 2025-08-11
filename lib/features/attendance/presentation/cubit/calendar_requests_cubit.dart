import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/calendar_day_requests.dart';

part 'calendar_requests_state.dart';

class CalendarRequestsCubit extends Cubit<CalendarRequestsState> {
  CalendarRequestsCubit() : super(CalendarRequestsInitial());

  Future<void> fetchAllRequests() async {
    emit(CalendarRequestsLoading());
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(CalendarRequestsError('User not logged in'));
        return;
      }
      final userId = user.uid;
      final firestore = FirebaseFirestore.instance;

      final leaveDocsByUser = await firestore
          .collection('leave_requests')
          .where('idUser', isEqualTo: userId)
          .get();
      final leaveDocsToUser = await firestore
          .collection('leave_requests')
          .where('idManager', isEqualTo: userId)
          .get();

      final overtimeDocsByUser = await firestore
          .collection('overtime_requests')
          .where('idUser', isEqualTo: userId)
          .get();
      final overtimeDocsToUser = await firestore
          .collection('overtime_requests')
          .where('idManager', isEqualTo: userId)
          .get();

      final attendanceDocsByUser = await firestore
          .collection('attendance_adjustments')
          .where('idUser', isEqualTo: userId)
          .get();
      final attendanceDocsToUser = await firestore
          .collection('attendance_adjustments')
          .where('idManager', isEqualTo: userId)
          .get();

      final workLogDocsByUser = await firestore
          .collection('work_logs')
          .where('idUser', isEqualTo: userId)
          .get();
      final workLogDocsToUser = await firestore
          .collection('work_logs')
          .where('idManager', isEqualTo: userId)
          .get();

      // Gom tất cả docs lại
      final allLeaveDocs = [...leaveDocsByUser.docs, ...leaveDocsToUser.docs];
      final allOvertimeDocs = [
        ...overtimeDocsByUser.docs,
        ...overtimeDocsToUser.docs
      ];
      final allAttendanceDocs = [
        ...attendanceDocsByUser.docs,
        ...attendanceDocsToUser.docs
      ];
      final allWorkLogDocs = [
        ...workLogDocsByUser.docs,
        ...workLogDocsToUser.docs
      ];

      // Map về CalendarDayRequests
      final Map<DateTime, CalendarDayRequests> requestsByDay = {};

      void addRequest(DateTime date, String type, Map<String, dynamic> data) {
        final key = DateTime.utc(date.year, date.month, date.day);
        requestsByDay.putIfAbsent(key, () => CalendarDayRequests());
        requestsByDay[key]!.addRequest(type, data);
      }

      for (final doc in allLeaveDocs) {
        final data = doc.data();
        final date = DateTime.parse(data['startDate']);
        addRequest(date, 'leave', data);
      }
      for (final doc in allOvertimeDocs) {
        final data = doc.data();
        final date = DateTime.parse(data['overtimeDate']);
        addRequest(date, 'overtime', data);
      }
      for (final doc in allAttendanceDocs) {
        final data = doc.data();
        final date = DateTime.parse(data['adjustmentDate']);
        addRequest(date, 'attendance', data);
      }
      for (final doc in allWorkLogDocs) {
        final data = doc.data();
        final date = DateTime.parse(data['workDate']);
        addRequest(date, 'worklog', data);
      }

      emit(CalendarRequestsLoaded(requestsByDay));
    } catch (e) {
      emit(CalendarRequestsError(e.toString()));
    }
  }
}
