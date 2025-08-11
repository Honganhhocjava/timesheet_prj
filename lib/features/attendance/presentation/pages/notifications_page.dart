import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/requests/presentation/pages/request_detail_page.dart';
import 'package:timesheet_project/features/requests/presentation/pages/created_by_me_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_state.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/attendance/domain/usecases/get_notifications_by_user_usecase.dart';
import 'package:timesheet_project/features/attendance/domain/entities/notification_entity.dart';
import 'package:timesheet_project/core/usecases/usecase.dart';

// Sử dụng NotificationEntity thay vì NotificationItem

Future<List<NotificationEntity>> fetchAllNotificationsForCurrentUser() async {
  try {
    final getNotificationsUsecase = getIt<GetNotificationsByUserUsecase>();
    final notifications = await getNotificationsUsecase(NoParams());
    return notifications;
  } catch (e) {
    print('Error fetching notifications: $e');
    return [];
  }
}

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<List<NotificationEntity>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = fetchAllNotificationsForCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Thông báo',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF0A357D),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSaved || state is UserLoaded) {
            setState(() {
              _notificationsFuture = fetchAllNotificationsForCurrentUser();
            });
          }
        },
        child: FutureBuilder<List<NotificationEntity>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            }
            final notifications = snapshot.data ?? [];
            if (notifications.isEmpty) {
              return const Center(child: Text('Chưa có thông báo nào'));
            }
            return ListView.separated(
              itemCount: notifications.length,
              padding: const EdgeInsets.symmetric(vertical: 24),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: item.senderAvatar.isNotEmpty
                        ? NetworkImage(item.senderAvatar)
                        : null,
                    child: item.senderAvatar.isEmpty
                        ? Text(
                            item.senderName.isNotEmpty
                                ? item.senderName[0]
                                : '?',
                          )
                        : null,
                  ),
                  title: Text(item.title),
                  subtitle: Text(
                    '${item.senderName}  ${DateFormat('dd/MM/yyyy HH:mm').format(item.createdAt)}',
                  ),
                  onTap: () async {
                    final user = FirebaseAuth.instance.currentUser;
                    final isManager = user != null && item.senderId != user.uid;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RequestDetailPage(
                          request: item.toRequestItem(),
                          isFromSentToMe: isManager,
                        ),
                      ),
                    );
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
            );
          },
        ),
      ),
    );
  }
}
