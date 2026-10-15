import 'package:flutter/material.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: Text(
          'Xin chào!\nKhám phá sản phẩm hôm nay',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      const SizedBox(width: 12),
      Stack(
        children: [
          const Padding(
            padding: EdgeInsets.all(8),
            child: Icon(Icons.notifications_outlined, size: 32),
          ),
          Positioned(
            top: 6,
            right: 6,
            child: Semantics(
              label: 'Có thông báo mới',
              child: const CircleAvatar(radius: 5, backgroundColor: Colors.red),
            ),
          ),
        ],
      ),
    ],
  );
}
