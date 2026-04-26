import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
// Note: Notifications and Timezone imports are commented out to fix the build error
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;

class QuoteService {
  final _supabase = Supabase.instance.client;

  // We leave this empty for now so your other code doesn't break
  Future<void> initNotifications() async {
    // Temporarily disabled to bypass build errors
    debugPrint("Notification service is temporarily on standby.");
  }

  // --- Fetch 3 random quotes from Supabase ---
  // This still works perfectly for your UI!
  Future<List<Map<String, dynamic>>> fetchDailyQuotes() async {
    try {
      final response = await _supabase.from('quotes').select();
      final List<dynamic> allQuotes = response as List;

      if (allQuotes.isEmpty) return [];

      allQuotes.shuffle(); // Randomize the list
      return allQuotes.take(3).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching quotes: $e");
      return [];
    }
  }

  // --- Schedule notifications ---
  Future<void> scheduleDailyNotifications(List<Map<String, dynamic>> quotes) async {
    // Temporarily disabled to bypass build errors
    debugPrint("Scheduling skipped: Notification logic disabled.");
  }

  // Time logic hidden until we fix the timezone package issue
  /*
  tz.TZDateTime _nextInstanceOfTime(int hour) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
  */
}