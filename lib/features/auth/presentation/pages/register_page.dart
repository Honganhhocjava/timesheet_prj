import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/auth/data/repositories/auth_repository.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';
import 'package:timesheet_project/features/auth/presentation/pages/sign_up_page.dart';
import 'package:timesheet_project/features/attendance/presentation/pages/home_page.dart';
import 'package:timesheet_project/di/di.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepository();
  final _userCubit = getIt<UserCubit>();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? firebaseUser = await _authRepository.signUpWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text.trim(),
        );

        if (firebaseUser != null) {
          bool userExists = await _userCubit.checkUserExists(firebaseUser.uid);

          if (mounted) {
            if (userExists) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignUpPage()),
              );
            }
          }
        } else {
          if (mounted) {
            TopSnackbar.show(context, 'Tài khoản email đã tồn tại.');
          }
        }
      } catch (e) {
        if (mounted) {
          TopSnackbar.show(context, 'Lỗi: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  // InputDecoration _inputDecoration(String label) {
  //   return InputDecoration(
  //     labelText: label,
  //     labelStyle: const TextStyle(
  //       fontWeight: FontWeight.bold,
  //       color: Color(0xFF0A357D),
  //     ),
  //     border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
  //     enabledBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: const BorderSide(color: Color(0xFFE6F0FF)),
  //     ),
  //     focusedBorder: OutlineInputBorder(
  //       borderRadius: BorderRadius.circular(12),
  //       borderSide: const BorderSide(color: Color(0xFF0EC2F2), width: 2),
  //     ),
  //     fillColor: const Color(0xFFF7FAFF),
  //     filled: true,
  //     contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0957AE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0957AE),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Tạo tài khoản mới',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: 345,
                    height: 300,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Tên đăng nhập",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // TextFormField(
                            //   controller: _emailController,
                            //   decoration: _inputDecoration('User (Email)'),
                            //   keyboardType: TextInputType.emailAddress,
                            //   validator: (value) {
                            //     if (value == null || value.trim().isEmpty) {
                            //       return 'Vui lòng nhập email';
                            //     }
                            //     final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                            //     if (!emailRegex.hasMatch(value.trim())) {
                            //       return 'Email không hợp lệ';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                labelText: 'User@gmail.com',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.email_outlined),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Vui lòng nhập email';
                                }
                                final emailRegex =
                                    RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                                if (!emailRegex.hasMatch(value.trim())) {
                                  return 'Email không hợp lệ';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Text(
                              "Mật khẩu",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            // TextFormField(
                            //   controller: _passwordController,
                            //   decoration: _inputDecoration('Password'),
                            //   obscureText: true,
                            //   validator: (value) {
                            //     if (value == null || value.trim().isEmpty) {
                            //       return 'Vui lòng nhập mật khẩu';
                            //     }
                            //     if (value.length < 6) {
                            //       return 'Mật khẩu phải có ít nhất 6 ký tự';
                            //     }
                            //     return null;
                            //   },
                            // ),
                            TextFormField(
                              controller: _passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                prefixIcon: const Icon(Icons.lock_outline),
                              ),
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EC2F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Đăng ký',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Đã có tài khoản? Đăng nhập',
                      style: TextStyle(
                        color: Color(0xFF0EC2F2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
