import 'package:flutter/material.dart';
import 'home_screen.dart'; // Import file màn hình chính của bạn

void main() {
  // Đảm bảo các widget của Flutter đã được khởi tạo trước khi chạy app
  WidgetsFlutterBinding.ensureInitialized();
  
  runApp(const SmartNoteApp());
}

class SmartNoteApp extends StatelessWidget {
  const SmartNoteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Note',
      // Tắt chữ "DEBUG" màu đỏ ở góc trên bên phải màn hình
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Gọi HomeScreen làm màn hình đầu tiên khi mở app
      home: HomeScreen(), 
    );
  }
}