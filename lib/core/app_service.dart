import 'package:supabase_flutter/supabase_flutter.dart';

class AppService {
  static final String apiurl = 'https://uutmgmxjzpynmykdvxxl.supabase.co';
  static final String apikey = 'sb_publishable_cOxeIrVrSx20UT0tuQNtSQ_E5U44Td_';

  static Future<void> init() async {
    await Supabase.initialize(url: apiurl, anonKey: apikey);
  }
}
