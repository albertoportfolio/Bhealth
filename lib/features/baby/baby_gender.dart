import 'package:flutter/material.dart';

enum BabyGender {
  male,
  female,
  other;

  String get label {
    switch (this) {
      case BabyGender.male:
        return 'Niño';
      case BabyGender.female:
        return 'Niña';
      case BabyGender.other:
        return 'Otro';
    }
  }

  String get value {
    switch (this) {
      case BabyGender.male:
        return 'male';
      case BabyGender.female:
        return 'female';
      case BabyGender.other:
        return 'other';
    }
  }

  Color get color {
    switch (this) {
      case BabyGender.male:
        return const Color(0xFF89CFF0);
      case BabyGender.female:
        return const Color(0xFFFF8FAB);
      case BabyGender.other:
        return const Color(0xFFA8E6CF);
    }
  }

  IconData get icon {
    switch (this) {
      case BabyGender.male:
        return Icons.boy_rounded;
      case BabyGender.female:
        return Icons.girl_rounded;
      case BabyGender.other:
        return Icons.child_care_rounded;
    }
  }

  static BabyGender fromValue(String value) =>
      BabyGender.values.firstWhere(
        (g) => g.value == value,
        orElse: () => BabyGender.other,
      );
}