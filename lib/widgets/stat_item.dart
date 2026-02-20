/*
 * @author Andrii Yatsun
 */

import 'package:flutter/material.dart';

/**
 * Widget that show profile statistic: Posts, Followers and Followings.
 */
class StatItem extends StatelessWidget {
  final String label;
  final String count;

  const StatItem(this.label, this.count, {super.key});

  /* статистика шаблон */
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        Text(label, style: const TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }
}