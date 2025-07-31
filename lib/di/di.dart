import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:timesheet_project/features/auth/data/repositories/auth_repository.dart';

// User imports
import 'package:timesheet_project/features/user/domain/repositories/user_repository.dart';
import 'package:timesheet_project/features/user/data/repositories/user_repository_impl.dart';
import 'package:timesheet_project/features/user/domain/usecases/save_user_usecase.dart';
import 'package:timesheet_project/features/user/domain/usecases/get_user_usecase.dart';
import 'package:timesheet_project/features/user/domain/usecases/update_user_usecase.dart';
import 'package:timesheet_project/features/user/domain/usecases/check_user_exists_usecase.dart';

// Leave Request imports
import 'package:timesheet_project/features/leave_request/domain/repositories/leave_request_repository.dart';
import 'package:timesheet_project/features/leave_request/data/repositories/leave_request_repository_impl.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/create_leave_request_usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/get_managers_usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/update_leave_request_usecase.dart';
import 'package:timesheet_project/features/leave_request/domain/usecases/delete_leave_request_usecase.dart';

// Attendance Adjustment imports
import 'package:timesheet_project/features/attendance_adjustment/domain/repositories/attendance_adjustment_repository.dart';
import 'package:timesheet_project/features/attendance_adjustment/data/repositories/attendance_adjustment_repository_impl.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/usecases/create_attendance_adjustment_usecase.dart';
import 'package:timesheet_project/features/attendance_adjustment/domain/usecases/get_managers_usecase.dart'
    as attendance_adjustment;

// Overtime Request imports
import 'package:timesheet_project/features/overtime_request/domain/repositories/overtime_request_repository.dart';
import 'package:timesheet_project/features/overtime_request/data/repositories/overtime_request_repository_impl.dart';
import 'package:timesheet_project/features/overtime_request/domain/usecases/create_overtime_request_usecase.dart';
import 'package:timesheet_project/features/overtime_request/domain/usecases/get_managers_usecase.dart'
    as overtime_request;

// Work Log imports
import 'package:timesheet_project/features/work_log/domain/repositories/work_log_repository.dart';
import 'package:timesheet_project/features/work_log/data/repositories/work_log_repository_impl.dart';
import 'package:timesheet_project/features/work_log/domain/usecases/create_work_log_usecase.dart';
import 'package:timesheet_project/features/work_log/domain/usecases/get_managers_usecase.dart'
    as work_log;
import 'package:cloud_firestore/cloud_firestore.dart';

// Attendance imports
import 'package:timesheet_project/features/attendance/presentation/cubit/home_cubit.dart';

import 'package:timesheet_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';
import 'package:timesheet_project/features/leave_request/presentation/cubit/leave_request_cubit.dart';
import 'package:timesheet_project/features/attendance_adjustment/presentation/cubit/attendance_adjustment_cubit.dart';
import 'package:timesheet_project/features/overtime_request/presentation/cubit/overtime_request_cubit.dart';
import 'package:timesheet_project/features/attendance/presentation/cubit/timesheets_cubit.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:timesheet_project/features/work_log/presentation/cubit/work_log_cubit.dart';

// Calendar imports
import 'package:timesheet_project/features/attendance/domain/repositories/calendar_repository.dart';
import 'package:timesheet_project/features/attendance/data/repositories/calendar_repository_impl.dart';
import 'package:timesheet_project/features/attendance/domain/usecases/get_calendar_events_usecase.dart';
import 'package:timesheet_project/features/attendance/domain/usecases/get_events_by_date_usecase.dart';


final GetIt getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  getIt.registerLazySingleton(() => Dio());
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());

  // User Repository - Interface and Implementation
  getIt.registerLazySingleton<UserRepository>(() => UserRepositoryImpl());

  // User Usecases
  getIt.registerLazySingleton<SaveUserUsecase>(
    () => SaveUserUsecase(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<GetUserUsecase>(
    () => GetUserUsecase(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<UpdateUserUsecase>(
    () => UpdateUserUsecase(getIt<UserRepository>()),
  );
  getIt.registerLazySingleton<CheckUserExistsUsecase>(
    () => CheckUserExistsUsecase(getIt<UserRepository>()),
  );

  // Leave Request Repository - Interface and Implementation
  getIt.registerLazySingleton<LeaveRequestRepository>(
    () => LeaveRequestRepositoryImpl(),
  );

  // Leave Request Usecases
  getIt.registerLazySingleton<CreateLeaveRequestUsecase>(
    () => CreateLeaveRequestUsecase(getIt<LeaveRequestRepository>()),
  );
  getIt.registerLazySingleton<GetManagersUsecase>(
    () => GetManagersUsecase(getIt<LeaveRequestRepository>()),
  );
  getIt.registerLazySingleton<UpdateLeaveRequestUseCase>(
    () => UpdateLeaveRequestUseCase(getIt<LeaveRequestRepository>()),
  );
  getIt.registerLazySingleton<DeleteLeaveRequestUseCase>(
    () => DeleteLeaveRequestUseCase(getIt<LeaveRequestRepository>()),
  );

  // Attendance Adjustment Repository - Interface and Implementation
  getIt.registerLazySingleton<AttendanceAdjustmentRepository>(
    () => AttendanceAdjustmentRepositoryImpl(),
  );

  // Attendance Adjustment Usecases
  getIt.registerLazySingleton<CreateAttendanceAdjustmentUsecase>(
    () => CreateAttendanceAdjustmentUsecase(
      getIt<AttendanceAdjustmentRepository>(),
    ),
  );
  getIt.registerLazySingleton<attendance_adjustment.GetManagersUsecase>(
    () => attendance_adjustment.GetManagersUsecase(
      getIt<AttendanceAdjustmentRepository>(),
    ),
  );

  // Overtime Request Repository - Interface and Implementation
  getIt.registerLazySingleton<OvertimeRequestRepository>(
    () => OvertimeRequestRepositoryImpl(),
  );

  // Overtime Request Usecases
  getIt.registerLazySingleton<CreateOvertimeRequestUsecase>(
    () => CreateOvertimeRequestUsecase(
      repository: getIt<OvertimeRequestRepository>(),
    ),
  );
  getIt.registerLazySingleton<overtime_request.GetManagersUsecase>(
    () => overtime_request.GetManagersUsecase(
      repository: getIt<OvertimeRequestRepository>(),
    ),
  );

  // Work Log Repository - Interface and Implementation
  getIt.registerLazySingleton<WorkLogRepository>(
    () => WorkLogRepositoryImpl(FirebaseFirestore.instance),
  );

  // Work Log Usecases
  getIt.registerLazySingleton<CreateWorkLogUsecase>(
    () => CreateWorkLogUsecase(getIt<WorkLogRepository>()),
  );
  getIt.registerLazySingleton<work_log.GetManagersUsecase>(
    () => work_log.GetManagersUsecase(getIt<WorkLogRepository>()),
  );

  // Calendar Repository - Interface and Implementation
  getIt.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(),
  );

  // Calendar Usecases
  getIt.registerLazySingleton<GetCalendarEventsUseCase>(
    () => GetCalendarEventsUseCase(getIt<CalendarRepository>()),
  );
  getIt.registerLazySingleton<GetEventsByDateUseCase>(
    () => GetEventsByDateUseCase(getIt<CalendarRepository>()),
  );


  // Cubits
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));
  getIt.registerFactory<UserCubit>(
    () => UserCubit(
      getIt<SaveUserUsecase>(),
      getIt<GetUserUsecase>(),
      getIt<UpdateUserUsecase>(),
      getIt<CheckUserExistsUsecase>(),
    ),
  );
  getIt.registerFactory<HomeCubit>(() => HomeCubit());
  getIt.registerFactory<LeaveRequestCubit>(
    () => LeaveRequestCubit(
      getIt<CreateLeaveRequestUsecase>(),
      getIt<GetManagersUsecase>(),
      getIt<UpdateLeaveRequestUseCase>(),
      getIt<DeleteLeaveRequestUseCase>(),
    ),
  );
  getIt.registerFactory<AttendanceAdjustmentCubit>(
    () => AttendanceAdjustmentCubit(
      getIt<CreateAttendanceAdjustmentUsecase>(),
      getIt<attendance_adjustment.GetManagersUsecase>(),
    ),
  );
  getIt.registerFactory<OvertimeRequestCubit>(
    () => OvertimeRequestCubit(
      getIt<CreateOvertimeRequestUsecase>(),
      getIt<overtime_request.GetManagersUsecase>(),
    ),
  );
  getIt.registerFactory<TimesheetsCubit>(
    () => TimesheetsCubit(
      getIt<LeaveRequestRepository>(),
      getIt<AttendanceAdjustmentRepository>(),
      getIt<OvertimeRequestRepository>(),
    ),
  );
  getIt.registerFactory<RequestsCubit>(
    () => RequestsCubit(
      getIt<LeaveRequestRepository>(),
      getIt<AttendanceAdjustmentRepository>(),
      getIt<OvertimeRequestRepository>(),
      getIt<UserRepository>(),
    ),
  );
  getIt.registerFactory<WorkLogCubit>(
    () => WorkLogCubit(
      getIt<CreateWorkLogUsecase>(),
      getIt<work_log.GetManagersUsecase>(),
    ),
  );
}
