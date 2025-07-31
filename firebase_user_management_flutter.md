
# Tích hợp Firebase Authentication, Firestore và Cloud Storage trong Flutter

## 1. Firebase Authentication: Đăng ký và Đăng nhập

### Cài đặt

Thêm vào `pubspec.yaml`:

```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.x.x
  firebase_auth: ^4.x.x
```

Chạy:

```bash
flutter pub get
```

### Khởi tạo Firebase trong `main.dart`

```dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}
```

### Đăng ký người dùng với Email và Mật khẩu

```dart
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Lỗi đăng ký: \${e.code} - \${e.message}");
      return null;
    } catch (e) {
      print("Lỗi không xác định: \$e");
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      print("Lỗi đăng nhập: \${e.code} - \${e.message}");
      return null;
    }
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    print("Đã đăng xuất.");
  }
}
```

---

## 2. Cloud Firestore: Lưu trữ thông tin người dùng

### Cài đặt

```yaml
dependencies:
  firebase_core: ^2.x.x
  cloud_firestore: ^4.x.x
```

Chạy:

```bash
flutter pub get
```

### Lưu thông tin chi tiết người dùng

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserData(
    String uid, {
    required String firstName,
    required String lastName,
    required String phone,
    required String birthday,
    required String address,
    required String avatarUrl,
    required String role,
  }) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'firstname': firstName,
        'lastname': lastName,
        'phone': phone,
        'birthday': birthday,
        'address': address,
        'avatar': avatarUrl,
        'role': role,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Lỗi khi lưu thông tin người dùng: \$e");
    }
  }

  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        print("Tài liệu không tồn tại.");
        return null;
      }
    } catch (e) {
      print("Lỗi khi đọc thông tin người dùng: \$e");
      return null;
    }
  }

  Future<void> updateUserData(String uid, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('users').doc(uid).update(updates);
    } catch (e) {
      print("Lỗi cập nhật: \$e");
    }
  }
}
```

### Tích hợp sau khi đăng ký

```dart
void handleUserRegistration() async {
  String email = 'newuser@example.com';
  String password = 'securepassword';
  String firstName = 'Nguyen';
  String lastName = 'Thi C';
  String phone = '0901234567';
  String birthday = '2000-10-25';
  String address = '789 Cong Hoa, HCM';
  String avatarUrl = 'https://example.com/default_avatar.jpg';
  String role = 'user';

  AuthService authService = AuthService();
  UserService userService = UserService();

  User? firebaseUser = await authService.signUpWithEmailAndPassword(email, password);

  if (firebaseUser != null) {
    await userService.saveUserData(
      firebaseUser.uid,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      birthday: birthday,
      address: address,
      avatarUrl: avatarUrl,
      role: role,
    );
  } else {
    print("Đăng ký không thành công.");
  }
}
```

---

## 3. Cloud Storage: Lưu trữ ảnh đại diện (Avatar)

### Cài đặt

```yaml
dependencies:
  firebase_core: ^2.x.x
  firebase_storage: ^11.x.x
  image_picker: ^1.x.x
```

Chạy:

```bash
flutter pub get
```

### Upload ảnh đại diện

```dart
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String?> uploadAvatar(String uid, XFile imageFile) async {
    try {
      File file = File(imageFile.path);
      Reference ref = _storage.ref().child('avatars').child('\$uid.jpg');
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Lỗi khi tải ảnh đại diện: \$e");
      return null;
    }
  }
}
```

### Chọn và tải ảnh

```dart
Future<void> _pickAndUploadAvatar() async {
  final ImagePicker _picker = ImagePicker();
  final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      StorageService storageService = StorageService();
      String? avatarUrl = await storageService.uploadAvatar(currentUserId, image);

      if (avatarUrl != null) {
        UserService userService = UserService();
        await userService.updateUserData(currentUserId, {'avatar': avatarUrl});
      }
    } else {
      print("Không có người dùng đang đăng nhập.");
    }
  } else {
    print("Người dùng đã hủy chọn ảnh.");
  }
}
```

---


Bằng cách kết hợp:

- **Firebase Authentication** để xác thực người dùng
- **Cloud Firestore** để lưu thông tin chi tiết
- **Cloud Storage** để lưu ảnh đại diện

Bạn đã có hệ thống quản lý người dùng hoàn chỉnh trong ứng dụng Flutter.

---
