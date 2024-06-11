import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

const String supabaseUrl = 'https://sezusjbiuccuqlyjjkud.supabase.co';
const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNlenVzamJpdWNjdXFseWpqa3VkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTcxMzQ1NjgsImV4cCI6MjAzMjcxMDU2OH0.Mh_0jV_SUaq_PccmiCQWhOy8xWbS9CwJknXKnbrLUhM';

Future<void> initSupabase() async {
  await Hive.initFlutter();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );
}
