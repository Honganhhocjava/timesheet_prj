import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserSaved) {
            TopSnackbar.showGreen(context, ' Đã cập nhật thành công!');
            Navigator.of(context).pop();
          } else if (state is UserError) {
            TopSnackbar.show(context, 'Lỗi: ${state.message}');
          } else if (state is UserLoading) {}
        },
        child: Column(
          children: [
            // Header
            _buildHeader(),
          //  const SizedBox(height: 110),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // User Info Card
                    // _buildUserInfoCard(),
                    // Form
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
            decoration: const BoxDecoration(
              color: Color(0xFF003E83),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: 8.0,
                  top: 44,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ),
                // Title
                const Center(
                  child: Text(
                    'Update Information',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
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
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: const Color(0xFF0A357D),
                  backgroundImage: widget.user.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.user.avatarUrl)
                      : null,
                  child: widget.user.avatarUrl.isEmpty
                      ? Text(
                          widget.user.firstName.isNotEmpty
                              ? widget.user.firstName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                ),
                // Edit avatar button
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 25,
                    height: 25,
                    decoration: const BoxDecoration(
                      color: Color(0xFF00C7F2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // User Info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${widget.user.firstName} ${widget.user.lastName}',
                style: const TextStyle(
                  color: Color(0xFF42425B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.user.role.isNotEmpty ? widget.user.role : 'Nhân viên',
                style: const TextStyle(
                  color: Color(0xFF6C6C81),
                  fontSize: 14,
                ),
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
          const SizedBox(height: 30),
          _buildTextField(
            controller: _firstNameController,
            label: 'First name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập tên';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _lastNameController,
            label: 'Last name',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập họ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _phoneController,
            label: 'Phone',
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
            label: 'Address',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập địa chỉ';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _roleController,
            label: 'Role',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Vui lòng nhập chức vụ';
              }
              return null;
            },
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
                    'Save',
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

  void _saveProfile() {
    debugPrint('EditProfilePage: Save button pressed!');

    if (_formKey.currentState!.validate()) {
      debugPrint('EditProfilePage: Form validation passed');

      // Create updates map
      final updates = {
        'firstName': _firstNameController.text.trim(),
        'lastName': _lastNameController.text.trim(),
        'phone': _phoneController.text.trim(),
        'address': _addressController.text.trim(),
        'role': _roleController.text.trim(),
      };

      debugPrint('EditProfilePage: Calling updateUser with: $updates');
      try {
        context.read<UserCubit>().updateUser(widget.user.uid, updates);
      } catch (e) {
        debugPrint('EditProfilePage: Error calling updateUser: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi gọi updateUser: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
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
}
