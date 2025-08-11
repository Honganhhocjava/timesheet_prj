import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:timesheet_project/features/attendance/presentation/pages/home_page.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_state.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/di/di.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthdayController = TextEditingController();
  final _addressController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedRole;
  final List<String> _roleOptions = ['Nhân viên', 'Quản lý'];

  late UserCubit _userCubit;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userCubit = getIt<UserCubit>();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _birthdayController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  //new code
  File? _avatarFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickAvatar() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _avatarFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadAvatarToCloudinary(File file) async {
    final cloudName = "dfstn25hz";
    final uploadPreset = "unsigned_preset";

    final url =
        Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");

    final request = http.MultipartRequest("POST", url)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['secure_url'];
    } else {
      throw Exception("Upload failed with status: ${response.statusCode}");
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthdayController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày sinh')),
      );
      return;
    }

    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lỗi: Không tìm thấy user hiện tại')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      String avatarUrl =
          'https://hoseiki.vn/wp-content/uploads/2025/03/avatar-mac-dinh-3.jpg';

      if (_avatarFile != null) {
        avatarUrl = await _uploadAvatarToCloudinary(_avatarFile!);
      }

      final userEntity = UserEntity(
        uid: currentUser.uid,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        phone: _phoneController.text.trim(),
        birthday: _selectedDate!,
        address: _addressController.text.trim(),
        avatarUrl: avatarUrl,
        role: _selectedRole ?? 'Nhân viên',
      );

      await _userCubit.saveUser(userEntity);

      if (mounted) {
        TopSnackbar.showGreen(context, ' Đã lưu thông tin thành công!');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } catch (e) {
      if (mounted) {
        TopSnackbar.show(context, ' Lỗi khi lưu thông tin: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  InputDecoration _inputDecoration(String label, [String? hint]) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      labelStyle: const TextStyle(
        color: Colors.black,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE6F0FF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE6F0FF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF0EC2F2), width: 2),
      ),
      fillColor: const Color(0xFFF7FAFF),
      filled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0957AE),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text(
          'Đăng ký thông tin',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0957AE),
        elevation: 0,
      ),
      body: BlocListener<UserCubit, UserState>(
        bloc: _userCubit,
        listener: (context, state) {
          if (state is UserSaved) {
            TopSnackbar.showGreen(context, state.message);
          } else if (state is UserError) {
            TopSnackbar.show(context, state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center(
                  //   child: GestureDetector(
                  //     behavior: HitTestBehavior.opaque,
                  //     onTap: _pickAvatar,
                  //     child: CircleAvatar(
                  //       radius: 50,
                  //       backgroundImage: _avatarFile != null
                  //           ? FileImage(_avatarFile!)
                  //           : NetworkImage(
                  //           'https://hoseiki.vn/wp-content/uploads/2025/03/avatar-mac-dinh-3.jpg',
                  //       ) as ImageProvider,
                  //       child: _avatarFile == null
                  //           ? const Icon(Icons.camera_alt, color: Colors.white, size: 30)
                  //           : null,
                  //     ),
                  //   ),
                  // ),
                  Center(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _pickAvatar,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: _avatarFile != null
                            ? FileImage(_avatarFile!)
                            : null,
                        backgroundColor: Colors.grey[300],
                        child: _avatarFile == null
                            ? const Icon(Icons.camera_alt,
                                color: Colors.white, size: 30)
                            : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 40,
                  ),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: _inputDecoration(
                      'First Name',
                      'Enter first name',
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập First Name'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: _inputDecoration(
                      'Last Name',
                      'Enter last name',
                    ),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập Last Name'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _phoneController,
                    decoration: _inputDecoration('Phone', 'Enter phone number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập Phone'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _birthdayController,
                    decoration: _inputDecoration('Birthday', 'Select birthday'),
                    readOnly: true,
                    onTap: _pickDate,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Vui lòng chọn Birthday'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _addressController,
                    decoration: _inputDecoration('Address', 'Enter address'),
                    validator: (value) =>
                        (value == null || value.trim().isEmpty)
                            ? 'Vui lòng nhập Address'
                            : null,
                  ),
                  const SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: _selectedRole,
                    decoration: _inputDecoration('Role'),
                    items: _roleOptions.map((String role) {
                      return DropdownMenuItem<String>(
                        value: role,
                        child: Text(role),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRole = newValue;
                      });
                    },
                    validator: (value) =>
                        value == null ? 'Vui lòng chọn Role' : null,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0EC2F2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              'Gửi thông tin',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
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
