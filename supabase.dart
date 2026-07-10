import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> initSupabase() async {
  try {
    await dotenv.load(fileName: '.env');
    
    // Validate required environment variables
    final supabaseUrl = dotenv.env['SUPABASE_URL'];
    final supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'];
    
    if (supabaseUrl == null || supabaseUrl.isEmpty) {
      throw Exception('Missing SUPABASE_URL in .env file');
    }
    if (supabaseAnonKey == null || supabaseAnonKey.isEmpty) {
      throw Exception('Missing SUPABASE_ANON_KEY in .env file');
    }
    
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  } catch (e) {
    throw Exception('Failed to initialize Supabase: ${e.toString()}');
  }
}

SupabaseClient get db => Supabase.instance.client;
