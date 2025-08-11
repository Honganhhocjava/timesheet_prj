// import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timesheet_project/core/firebase_options.dart';
import 'package:timesheet_project/features/auth/presentation/pages/auth_wrapper.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  await setupDependencyInjection();
  await initializeDateFormatting('vi_VN', '');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (context) => getIt<AuthCubit>()),
        BlocProvider<UserCubit>(create: (context) => getIt<UserCubit>()),
      ],
      child: MaterialApp(
        title: 'Timesheet Project',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        home: const AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
