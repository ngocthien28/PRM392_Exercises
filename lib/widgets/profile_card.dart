import 'package:flutter/material.dart';

/// Thông tin mẫu; thay bằng thông tin của bạn trước khi nộp.
class ProfileCard extends StatelessWidget {
  const ProfileCard({super.key});

  @override
  Widget build(BuildContext context) => const Card(
    child: Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(radius: 36, child: Icon(Icons.person, size: 42)),
          SizedBox(height: 12),
          Text(
            'Nguyễn Văn A',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text('Sinh viên • Flutter Developer'),
          SizedBox(height: 8),
          Text(
            'Tôi đang học xây dựng ứng dụng đa nền tảng với Flutter.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
