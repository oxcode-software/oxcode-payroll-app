import 'package:flutter/material.dart';

enum SubscriptionPlan {
  free,
  basic,
  premium;

  bool get isPremium => this == SubscriptionPlan.premium;
  bool get isBasic =>
      this == SubscriptionPlan.basic || this == SubscriptionPlan.premium;
}

class SubscriptionProvider with ChangeNotifier {
  SubscriptionPlan _currentPlan = SubscriptionPlan.free;

  SubscriptionPlan get currentPlan => _currentPlan;

  void setPlan(SubscriptionPlan plan) {
    _currentPlan = plan;
    notifyListeners();
  }

  bool isFeatureEnabled(String featureKey) {
    switch (featureKey) {
      case 'attendance_analytics':
        return _currentPlan != SubscriptionPlan.free;
      case 'advanced_reporting':
        return _currentPlan == SubscriptionPlan.premium;
      case 'team_management':
        return _currentPlan != SubscriptionPlan.free;
      default:
        return true;
    }
  }

  String getPlanName() {
    switch (_currentPlan) {
      case SubscriptionPlan.free:
        return 'Free';
      case SubscriptionPlan.basic:
        return 'Basic';
      case SubscriptionPlan.premium:
        return 'Premium';
    }
  }

  Color getPlanColor() {
    switch (_currentPlan) {
      case SubscriptionPlan.free:
        return Colors.grey;
      case SubscriptionPlan.basic:
        return Colors.blue;
      case SubscriptionPlan.premium:
        return const Color(0xFFFFD700); // Gold
    }
  }
}
