import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:timesheet_project/features/leave_request/presentation/pages/top_snackbar.dart';
import 'package:timesheet_project/features/user/domain/entities/user_entity.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_cubit.dart';
import 'package:timesheet_project/features/user/presentation/cubit/user_state.dart';

class EditProfilePage extends StatefulWidget {
  final UserEntity user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _roleController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.user.firstName);
    _lastNameController = TextEditingController(text: widget.user.lastName);
    _phoneController = TextEditingController(text: widget.user.phone);
    _addressController = TextEditingController(text: widget.user.address);
    _roleController = TextEditingController(text: widget.user.role);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _roleController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSaved) {
            TopSnackbar.showGreen(context, ' Đã cập nhật thành công!');
            Navigator.of(context).pop();
          } else if (state is UserError) {
            TopSnackbar.show(context, 'Lỗi: ${state.message}');
          } else if (state is UserLoading) {
            CircularProgressIndicator();
          } else if (state is UserLoaded) {
            final user = state.user;
            _firstNameController.text = user.firstName;
            _lastNameController.text = user.lastName;
            _phoneController.text = user.phone;
            _addressController.text = user.address;
          }
        },
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildForm(),
                    const SizedBox(height: 32),

                    // Save Button
                    _buildSaveButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(color: Color(0xFF003E83)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                // Title
                Expanded(
                  child: Text(
                    'Cập nhật thông tin',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 40)
              ],
            ),
          ),
          Positioned(
            top: 110,
            left: 10,
            right: 10,
            child: _buildUserInfoCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          // Avatar
          SizedBox(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // CircleAvatar(
                //   radius: 30,
                //   backgroundColor: const Color(0xFF0A357D),
                //   backgroundImage: widget.user.avatarUrl.isNotEmpty
                //       ? NetworkImage(widget.user.avatarUrl)
                //       : null,
                //   child: widget.user.avatarUrl.isEmpty
                //       ? Text(
                //           widget.user.firstName.isNotEmpty
                //               ? widget.user.firstName[0].toUpperCase()
                //               : 'U',
                //           style: const TextStyle(
                //             color: Colors.white,
                //             fontSize: 24,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         )
                //       : null,
                // ),
                // Edit avatar button
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF0A357D),
                  backgroundImage: _avatarFile != null
                      ? FileImage(_avatarFile!)
                      : (() {
                          final s = context.watch<UserCubit>().state;
                          final u = s is UserLoaded ? s.user : widget.user;
                          return u.avatarUrl.isNotEmpty
                              ? NetworkImage(u.avatarUrl)
                              : null;
                        })() as ImageProvider?,
                  child: (() {
                    final s = context.watch<UserCubit>().state;
                    final u = s is UserLoaded ? s.user : widget.user;
                    if (_avatarFile == null && u.avatarUrl.isEmpty) {
                      return Text(
                        u.firstName.isNotEmpty
                            ? u.firstName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    }
                    return null;
                  })(),
                ),
                Positioned(
                  bottom: -32,
                  right: -18,
                  child: GestureDetector(
                    onTap: _pickAvatar,
                    child: SvgPicture.asset(
                      'assets/image/add_photo.svg',
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 30,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                () {
                  final s = context.watch<UserCubit>().state;
                  final u = s is UserLoaded ? s.user : widget.user;
                  return '${u.firstName} ${u.lastName}';
                }(),
                style: const TextStyle(
                  color: Color(0xFF42425B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                () {
                  final s = context.watch<UserCubit>().state;
                  final u = s is UserLoaded ? s.user : widget.user;
                  return u.role.isNotEmpty ? u.role : 'Nhân viên';
                }(),
                style: const TextStyle(color: Color(0xFF6C6C81), fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 12),
          _buildTextField(
            controller: _firstNameController,
            label: 'Họ',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _lastNameController,
            label: 'Tên',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Số điện thoại',
            keyboardType: TextInputType.phone,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập số điện thoại';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _addressController,
            label: 'Địa chỉ',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          IgnorePointer(
            child: Opacity(
              opacity: 0.65,
              child: _buildTextField(
                controller: _roleController,
                label: 'Role',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập chức vụ';
                  }
                  return null;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF42425B), fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFE5EAF3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF0A357D)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        final isLoading = state is UserLoading;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          width: double.infinity,
          height: 51,
          child: ElevatedButton(
            onPressed: isLoading ? null : _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00C7F2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 8,
            ),
            child: isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  )
                : const Text(
                    'Lưu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        );
      },
    );
  }

  // void _saveProfile() {
  //   debugPrint('EditProfilePage: Save button pressed!');
  //
  //   if (_formKey.currentState!.validate()) {
  //     debugPrint('EditProfilePage: Form validation passed');
  //
  //     // Create updates map
  //     final updates = {
  //       'firstName': _firstNameController.text.trim(),
  //       'lastName': _lastNameController.text.trim(),
  //       'phone': _phoneController.text.trim(),
  //       'address': _addressController.text.trim(),
  //       'role': _roleController.text.trim(),
  //     };
  //
  //     debugPrint('EditProfilePage: Calling updateUser with: $updates');
  //     try {
  //       context.read<UserCubit>().updateUser(widget.user.uid, updates);
  //     } catch (e) {
  //       debugPrint('EditProfilePage: Error calling updateUser: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Lỗi khi gọi updateUser: $e'),
  //           backgroundColor: Colors.red,
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } else {
  //     debugPrint('EditProfilePage: Form validation failed');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(' Vui lòng kiểm tra lại thông tin!'),
  //         backgroundColor: Colors.orange,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }
  void _saveProfile() async {
    debugPrint('EditProfilePage: Save button pressed!');

    if (_formKey.currentState!.validate()) {
      debugPrint('EditProfilePage: Form validation passed');

      final updates = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'role': _roleController.text.trim(),
      };

      try {
        if (_avatarFile != null) {
          debugPrint('Uploading avatar to Cloudinary...');
          final avatarUrl = await _uploadAvatarToCloudinary(_avatarFile!);
          updates['avatarUrl'] = avatarUrl;
          debugPrint('Uploaded avatar: $avatarUrl');
        }

        debugPrint('EditProfilePage: Calling updateUser with: $updates');
        if (!mounted) return;
        await context.read<UserCubit>().updateUser(widget.user.uid, updates);
      } catch (e) {
        debugPrint('EditProfilePage: Error calling updateUser: $e');
        TopSnackbar.show(context, 'Lỗi $e');
      }
    } else {
      debugPrint('EditProfilePage: Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(' Vui lòng kiểm tra lại thông tin!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
  // Future<void> _saveProfile() async {
  //   debugPrint('EditProfilePage: Save button pressed!');
  //
  //   if (_formKey.currentState!.validate()) {
  //     debugPrint('EditProfilePage: Form validation passed');
  //
  //     final updates = {
  //       'firstName': _firstNameController.text.trim(),
  //       'lastName': _lastNameController.text.trim(),
  //       'phone': _phoneController.text.trim(),
  //       'address': _addressController.text.trim(),
  //       'role': _roleController.text.trim(),
  //       'avatar': _avatarFile.toString(),
  //     };
  //
  //     debugPrint('EditProfilePage: Calling updateUser with: $updates');
  //     try {
  //       await context.read<UserCubit>().updateUser(widget.user.uid, updates);
  //     } catch (e) {
  //       debugPrint('EditProfilePage: Error calling updateUser: $e');
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text('Lỗi khi gọi updateUser: $e'),
  //           backgroundColor: Colors.red,
  //           duration: const Duration(seconds: 3),
  //         ),
  //       );
  //     }
  //   } else {
  //     debugPrint('EditProfilePage: Form validation failed');
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text(' Vui lòng kiểm tra lại thông tin!'),
  //         backgroundColor: Colors.orange,
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //   }
  // }
}
