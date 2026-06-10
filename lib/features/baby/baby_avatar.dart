import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'baby_gender.dart';

class BabyAvatar extends StatelessWidget {
  final String name;
  final String gender;
  final Uint8List? photoBytes;
  final double radius;

  const BabyAvatar({
    super.key,
    required this.name,
    required this.gender,
    this.photoBytes,
    this.radius = 36,
  });

  @override
  Widget build(BuildContext context) {
    final g = BabyGender.fromValue(gender);

    if (photoBytes != null && photoBytes!.isNotEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundImage: MemoryImage(photoBytes!),
      );
    }

    return CircleAvatar(
      radius: radius,
      backgroundColor: g.color.withValues(alpha: 0.2),
      child: Icon(g.icon, size: radius * 0.9, color: g.color),
    );
  }
}