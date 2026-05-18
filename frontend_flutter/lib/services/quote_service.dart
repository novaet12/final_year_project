import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class QuoteService {
  final _supabase = Supabase.instance.client;

  
  Future<void> initNotifications() async {

    debugPrint("Notification service is temporarily on standby.");
  }


  Future<List<Map<String, dynamic>>> fetchDailyQuotes() async {
    try {
      final response = await _supabase.from('quotes').select();
      final List<dynamic> allQuotes = response as List;

      if (allQuotes.isEmpty) return [];

      allQuotes.shuffle(); 
      return allQuotes.take(3).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      print("Error fetching quotes: $e");
      return [];
    }
  }


  Future<void> scheduleDailyNotifications(List<Map<String, dynamic>> quotes) async {

    debugPrint("Scheduling skipped: Notification logic disabled.");
  }


}