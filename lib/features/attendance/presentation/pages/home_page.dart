import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:timesheet_project/di/di.dart';
import 'package:timesheet_project/features/ai_assistant/pages/icon_ai_assistant/floating_ai_ball.dart';

import 'package:timesheet_project/features/attendance/presentation/cubit/home_cubit.dart';
import 'package:timesheet_project/features/attendance/presentation/cubit/home_state.dart';
import 'package:timesheet_project/features/auth/presentation/pages/login_page.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/presentation/pages/edit_profile_page.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/create_leave_request_page.dart';
import 'package:timesheet_project/features/attendance_adjustment/presentation/pages/create_attendance_adjustment_page.dart';
import 'package:timesheet_project/features/overtime_request/presentation/pages/create_overtime_request_page.dart';
import 'package:timesheet_project/features/attendance/presentation/pages/timesheets_page.dart';
import 'package:timesheet_project/features/requests/presentation/pages/sent_to_me_page.dart';
import 'package:timesheet_project/features/requests/presentation/pages/created_by_me_page.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_cubit.dart';
import 'package:timesheet_project/features/requests/presentation/cubit/requests_state.dart';
import 'package:timesheet_project/features/work_log/presentation/pages/create_work_log_page.dart';
import 'package:timesheet_project/features/attendance/presentation/pages/notifications_page.dart';

class CustomizeFloatingLocation extends FloatingActionButtonLocation {
  FloatingActionButtonLocation location;
  double offsetX;
  double offsetY;

  CustomizeFloatingLocation(this.location, this.offsetX, this.offsetY);

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    Offset offset = location.getOffset(scaffoldGeometry);
    return Offset(offset.dx + offsetX, offset.dy + offsetY);
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _createdByMeCount = 0;

  // Pre-create all tab widgets to avoid rebuilding
  late final List<Widget> _tabWidgets;

  // Cache floatingActionButtonLocation to avoid rebuilding
  FloatingActionButtonLocation? _cachedFloatingButtonLocation;

  @override
  void initState() {
    super.initState();
    _loadCreatedByMeCount();
    _initializeTabWidgets();
  }

  void _initializeTabWidgets() {
    _tabWidgets = [
      _HomeTab(createdByMeCount: _createdByMeCount),
      const TimesheetsPage(),
      const NotificationsPage(),
      _ProfileTab(),
    ];
  }

  FloatingActionButtonLocation get floatingActionButtonLocationWidget {
    return _cachedFloatingButtonLocation ??= CustomizeFloatingLocation(
      FloatingActionButtonLocation.centerDocked,
      0.0,
      12.0,
    );
  }

  Future<void> _loadCreatedByMeCount() async {
    try {
      final tempCubit = RequestsCubit(getIt(), getIt(), getIt(), getIt());

      await tempCubit.getCreatedByMeCount();

      // Listen to the state once
      tempCubit.stream.listen((state) {
        if (state is RequestsLoaded && mounted) {
          setState(() {
            _createdByMeCount = state.totalCount;
            // Update home tab with new count
            _tabWidgets[0] = _HomeTab(createdByMeCount: _createdByMeCount);
          });
        }
      });
    } catch (e) {
      debugPrint('Error loading created by me count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => HomeCubit()),
        BlocProvider(
          create: (context) {
            final cubit = getIt<RequestsCubit>();
            cubit.getPendingRequestsCount();
            return cubit;
          },
        ),
      ],
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Stack(
            children: [
              Scaffold(
                backgroundColor: const Color(0xFFF7FAFF),
                body: IndexedStack(
                  index: state.selectedTabIndex,
                  children: _tabWidgets,
                ),
                floatingActionButton: const _CachedFloatingActionButton(),
                floatingActionButtonLocation:
                    floatingActionButtonLocationWidget,
                bottomNavigationBar: BottomAppBar(
                  color: Colors.white,
                  child: SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _NavIcon(
                          icon: Icons.home,
                          isActive: state.selectedTabIndex == 0,
                          onTap: () => context.read<HomeCubit>().selectTab(0),
                        ),
                        _NavIcon(
                          icon: Icons.assignment_outlined,
                          isActive: state.selectedTabIndex == 1,
                          onTap: () => context.read<HomeCubit>().selectTab(1),
                        ),
                        const SizedBox(width: 80),
                        _NavIcon(
                          icon: Icons.notifications_none,
                          isActive: state.selectedTabIndex == 2,
                          onTap: () => context.read<HomeCubit>().selectTab(2),
                          showBadge: state.hasNotification,
                        ),
                        _NavIcon(
                          icon: Icons.person_outline,
                          isActive: state.selectedTabIndex == 3,
                          onTap: () => context.read<HomeCubit>().selectTab(3),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // AI Assistant Ball
              const FloatingAIBall(),
            ],
          );
        },
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final int createdByMeCount;

  const _HomeTab({required this.createdByMeCount});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCubit>()..getCurrentUser(),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 120 + MediaQuery.paddingOf(context).top,
                decoration: const BoxDecoration(color: Color(0xFF0A357D)),
                padding: EdgeInsets.only(
                  top: 20 + MediaQuery.paddingOf(context).top,
                  left: 20,
                  right: 20,
                  bottom: 20,
                ),
                child: BlocBuilder<UserCubit, UserState>(
                  builder: (context, userState) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _getDisplayName(userState),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                              Text(
                                _getDisplayRole(userState),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        _buildUserAvatar(userState),
                      ],
                    );
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 56),
                        const Text(
                          'TẠO ĐỀ XUẤT',
                          style: TextStyle(
                            color: Color(0xFF0A357D),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GridView.count(
                          padding: EdgeInsets.only(top: 0),
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 1.1,
                          children: [
                            _ProposalButton(
                              widget: SvgPicture.asset(
                                'assets/image/leave.svg',
                                width: 50,
                                height: 50,
                              ),
                              label: 'Xin nghỉ phép',
                              color: Color(0xFF4DD0FE),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateLeaveRequestPage(),
                                  ),
                                );
                              },
                            ),
                            _ProposalButton(
                              widget: SvgPicture.asset(
                                'assets/image/log_work.svg',
                                width: 50,
                                height: 50,
                              ),
                              label: 'Log work',
                              color: Color(0xFF5B8DF6),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateWorkLogPage(),
                                  ),
                                );
                              },
                            ),
                            _ProposalButton(
                              widget: SvgPicture.asset(
                                'assets/image/attended_aj.svg',
                                width: 50,
                                height: 50,
                              ),
                              label: 'Điều chỉnh\nchấm công',
                              color: Color(0xFF3A7FF6),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateAttendanceAdjustmentPage(),
                                  ),
                                );
                              },
                            ),
                            _ProposalButton(
                              widget: SvgPicture.asset(
                                'assets/image/attended.svg',
                                width: 50,
                                height: 50,
                              ),
                              label: 'Làm thêm giờ',
                              color: Color(0xFF0EC2F2),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CreateOvertimeRequestPage(),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'DANH SÁCH ĐỀ XUẤT',
                              style: TextStyle(
                                color: Color(0xFF0A357D),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CreatedByMePage(),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                  horizontal: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFD6F8FF),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'View all',
                                  style: TextStyle(
                                    color: Color(0xFF0EC2F2),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        BlocBuilder<RequestsCubit, RequestsState>(
                          builder: (context, requestsState) {
                            int count = 0;
                            debugPrint(
                              'DEBUG: RequestsState type: ${requestsState.runtimeType}',
                            );
                            if (requestsState is RequestsLoaded) {
                              count = requestsState.totalCount;
                              debugPrint(
                                'DEBUG: Total count from RequestsLoaded: $count',
                              );
                            } else if (requestsState
                                is RequestsLoadedWithUserNames) {
                              count = requestsState.totalCount;
                              debugPrint(
                                'DEBUG: Total count from RequestsLoadedWithUserNames: $count',
                              );
                            } else if (requestsState is RequestsError) {
                              debugPrint(
                                'DEBUG: RequestsError: ${requestsState.message}',
                              );
                            }
                            debugPrint('DEBUG: Final count for badge: $count');
                            return _RequestListItem(
                              widget: SvgPicture.asset(
                                'assets/image/sent_to_me.svg',
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                              ),
                              label: 'Sent to me',
                              count: count,
                              color: Color(0xFF0EC2F2),
                              hasNotification: count > 0,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SentToMePage(),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 12),
                        _RequestListItem(
                          widget: SvgPicture.asset(
                            'assets/image/created_by_me.svg',
                            width: 42,
                            height: 42,
                          ),

                          label: 'Created by me',
                          count: createdByMeCount,
                          color: Color(0xFF5B8DF6),
                          hasNotification: createdByMeCount > 0,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreatedByMePage(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 56),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 76 + MediaQuery.paddingOf(context).top,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.read<HomeCubit>().selectTab(1);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            width: 54,
                            height: 54,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0EC2F2),
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(8),
                            child: SvgPicture.asset(
                              'assets/image/chamcong.svg',
                              width: 26,
                              height: 27,
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Chấm công',
                                  style: TextStyle(
                                    color: Color(0xFF0A357D),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Theo dõi, kiểm tra chi tiết chấm công,...',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getDisplayName(UserState userState) {
    if (userState is UserLoaded) {
      final user = userState.user;
      final fullName = '${user.firstName} ${user.lastName}'.trim();
      return fullName.isNotEmpty ? fullName : 'Người dùng';
    } else if (userState is UserLoading) {
      return 'Đang tải...';
    } else if (userState is UserError) {
      return 'Lỗi tải thông tin';
    }
    return 'Người dùng';
  }

  String _getDisplayRole(UserState userState) {
    if (userState is UserLoaded) {
      final user = userState.user;
      return user.role.isNotEmpty ? '@${user.role}' : '@Nhân viên';
    } else if (userState is UserLoading) {
      return 'Đang tải...';
    } else if (userState is UserError) {
      return 'Không xác định';
    }
    return '@Nhân viên';
  }

  Widget _buildUserAvatar(UserState userState) {
    if (userState is UserLoaded) {
      final user = userState.user;
      final fullName = '${user.firstName} ${user.lastName}'.trim();

      return CircleAvatar(
        radius: 22,
        backgroundColor: const Color(0xFF0A357D),
        backgroundImage: user.avatarUrl.isNotEmpty
            ? NetworkImage(user.avatarUrl)
            : null,
        child: user.avatarUrl.isEmpty
            ? Text(
                fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )
            : null,
      );
    }

    // Default avatar for loading/error states
    return const CircleAvatar(
      radius: 22,
      backgroundColor: Colors.white,
      child: Icon(Icons.person, color: Color(0xFF0A357D), size: 24),
    );
  }
}

class _ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<UserCubit>(),
      child: BlocBuilder<UserCubit, UserState>(
        builder: (context, state) {
          if (state is UserInitial) {
            context.read<UserCubit>().getCurrentUser();
          }

          return Column(
            children: [
              // AppBar Section
              SizedBox(
                height: 200,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      height: 150,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 12),
                      color: Color(0xFF0A357D),
                      child: SafeArea(
                        child: Text(
                          'Thông tin cá nhân',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      left: 10,
                      right: 10,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: _buildUserInfoCard(state),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),

              // Content Section with proper Expanded usage
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(bottom: 32),
                  child: _buildProfileDetailsList(state, context),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard(UserState state) {
    if (state is UserLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0A357D)),
      );
    }

    if (state is UserLoaded) {
      final user = state.user;
      final fullName = '${user.lastName} ${user.firstName}'.trim();

      return Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF0A357D),
            backgroundImage: user.avatarUrl.isNotEmpty
                ? NetworkImage(user.avatarUrl)
                : null,
            child: user.avatarUrl.isEmpty
                ? Text(
                    fullName.isNotEmpty ? fullName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),
          // User Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fullName.isNotEmpty ? fullName : 'Người dùng',
                  style: const TextStyle(
                    color: Color(0xFF0A357D),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  user.role.isNotEmpty ? user.role : 'Nhân viên',
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      );
    }

    if (state is UserError) {
      return Center(
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 8),
            Text(
              'Lỗi: ${state.message}',
              style: const TextStyle(color: Colors.red, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return const Center(
      child: Text(
        'Đang tải thông tin...',
        style: TextStyle(color: Color(0xFF0A357D), fontSize: 16),
      ),
    );
  }

  Widget _buildProfileDetailsList(UserState state, BuildContext context) {
    if (state is UserLoaded) {
      final user = state.user;
      return Column(
        children: [
          _ProfileDetailItem(
            icon: Icons.phone,
            value: _maskPhoneNumber(user.phone),
          ),
          const Divider(
            color: Colors.black87,
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          _ProfileDetailItem(
            icon: Icons.calendar_today,
            value: _formatDate(user.birthday),
          ),
          const Divider(
               color: Colors.black87,
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          _ProfileDetailItem(
            icon: Icons.location_on,
            value: user.address.isNotEmpty ? user.address : 'Chưa cập nhật',
          ),
          const Divider(
               color: Colors.black87,
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          GestureDetector(
            onTap: () => _showLogoutDialog(context),
            child: _ProfileDetailItem(icon: Icons.logout, value: 'Logout'),
          ),
          const Divider(
               color: Colors.black87,
            thickness: 1,
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
          SizedBox(height: 50),
          TextButton(
            onPressed: () => _navigateToEditProfile(context, user),
            child: Text(
              'Cập nhật thông tin',
              style: TextStyle(
                color: Color(0xFF00C7F2),
                fontWeight: FontWeight.w500,
                fontSize: 17,
              ),
            ),
          ),
          // Logout Option
        ],
      );
    }
    return const Center(
      child: Text(
        'Đang tải thông tin...',
        style: TextStyle(color: Color(0xFF0A357D), fontSize: 16),
      ),
    );
  }

  String _maskPhoneNumber(String phoneNumber) {
    if (phoneNumber.length <= 5) return phoneNumber;
    return phoneNumber.substring(0, 5) + 'x' * (phoneNumber.length - 5);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _navigateToEditProfile(BuildContext context, UserEntity user) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditProfilePage(user: user)),
    );
  }
}

class _CachedFloatingActionButton extends StatelessWidget {
  const _CachedFloatingActionButton();

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      child: _CustomFloatingActionButton(
        onPressed: () {
          _showRequestOptions(context);
        },
      ),
    );
  }

  void _showRequestOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Tạo đề xuất',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A357D),
                  ),
                ),
                const SizedBox(height: 20),

                // Request Options
                Stack(
                  children: [
                    _RequestOption(
                      icon: Icons.event,
                      title: 'Xin nghỉ phép',
                      subtitle: 'Tạo đơn xin nghỉ phép',
                      color: const Color(0xFF4DD0FE),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const CreateLeaveRequestPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                _RequestOption(
                  icon: Icons.access_time,
                  title: 'Log work',
                  subtitle: 'Ghi nhận thời gian làm việc',
                  color: const Color(0xFF5B8DF6),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateWorkLogPage(),
                      ),
                    );
                  },
                ),
                _RequestOption(
                  icon: Icons.edit,
                  title: 'Điều chỉnh chấm công',
                  subtitle: 'Yêu cầu điều chỉnh thời gian',
                  color: const Color(0xFF3A7FF6),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const CreateAttendanceAdjustmentPage(),
                      ),
                    );
                  },
                ),
                _RequestOption(
                  icon: Icons.alarm,
                  title: 'Làm thêm giờ',
                  subtitle: 'Đăng ký làm thêm giờ',
                  color: const Color(0xFF0EC2F2),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CreateOvertimeRequestPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Widget cho request option trong bottom sheet
class _RequestOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _RequestOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[200]!),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0A357D),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Widget cho proposal button
class _ProposalButton extends StatelessWidget {
  final Widget widget;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const _ProposalButton({
    required this.widget,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          bottom: -8,
          left: 0,
          right: 0,
          child: Container(
            height: 20,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(16),
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                height: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        widget,
                        Icon(
                          Icons.keyboard_arrow_right_rounded,
                          color: Colors.white,
                          size: 25,
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RequestListItem extends StatelessWidget {
  final Widget widget;
  final String label;
  final int count;
  final Color color;
  final bool hasNotification;
  final VoidCallback? onTap;

  const _RequestListItem({
    required this.widget,
    required this.label,
    required this.count,
    required this.color,
    required this.hasNotification,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Row(
            children: [
              widget,
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF0A357D),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              if (hasNotification && count > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              const Icon(
                Icons.keyboard_arrow_right,
                color: Colors.grey,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CustomFloatingActionButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3),
          color: Color(0xFF00C7F2),
        ),
        child: const Center(
          child: Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }
}

// Widget icon cho bottom navigation
class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final bool showBadge;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF00C2FF) : const Color(0xFFB0B0B0);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          height: 60,
          child: Center(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: color, size: 32),
                if (showBadge)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00C2FF),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileDetailItem extends StatelessWidget {
  final IconData icon;
  final String value;

  const _ProfileDetailItem({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87, size: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
