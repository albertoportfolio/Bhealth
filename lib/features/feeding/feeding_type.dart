import 'package:flutter/material.dart';

enum FeedingType {
  breastLeft,
  breastRight,
  bottleFormula,
  bottleBreastMilk;

  String get label {
    switch (this) {
      case FeedingType.breastLeft:
        return 'Pecho izquierdo';
      case FeedingType.breastRight:
        return 'Pecho derecho';
      case FeedingType.bottleFormula:
        return 'Biberón – fórmula';
      case FeedingType.bottleBreastMilk:
        return 'Biberón – leche materna';
    }
  }

  String get shortLabel {
    switch (this) {
      case FeedingType.breastLeft:
        return 'Pecho izq.';
      case FeedingType.breastRight:
        return 'Pecho der.';
      case FeedingType.bottleFormula:
        return 'Fórmula';
      case FeedingType.bottleBreastMilk:
        return 'L. materna';
    }
  }

  /// Value stored in the database.
  String get value {
    switch (this) {
      case FeedingType.breastLeft:
        return 'breast_left';
      case FeedingType.breastRight:
        return 'breast_right';
      case FeedingType.bottleFormula:
        return 'bottle_formula';
      case FeedingType.bottleBreastMilk:
        return 'bottle_breast_milk';
    }
  }

  IconData get icon {
    switch (this) {
      case FeedingType.breastLeft:
      case FeedingType.breastRight:
        return Icons.child_friendly_rounded;
      case FeedingType.bottleFormula:
      case FeedingType.bottleBreastMilk:
        return Icons.local_drink_outlined;
    }
  }

  Color get color {
    switch (this) {
      case FeedingType.breastLeft:
        return const Color(0xFFFF8FAB);
      case FeedingType.breastRight:
        return const Color(0xFFFFB3C6);
      case FeedingType.bottleFormula:
        return const Color(0xFF89CFF0);
      case FeedingType.bottleBreastMilk:
        return const Color(0xFFA8E6CF);
    }
  }

  bool get isBottle =>
      this == FeedingType.bottleFormula ||
      this == FeedingType.bottleBreastMilk;

  static FeedingType fromValue(String value) => FeedingType.values.firstWhere(
        (t) => t.value == value,
        orElse: () => FeedingType.breastLeft,
      );
}