import 'package:socialmedia/core/supabase_database.dart';
import 'package:socialmedia/feature/screen/home/model/stories_model.dart';

class StoriesSupabase {
  final supabase = SupabaseDatabase();

  Future<List<StoriesModel>> fetchrows() async {
    try {
      final list = await supabase.fetchrows(
        primaryKey: ['id'],
        table: 'stories',
        selectquery: '*,users!stories_user_id_fkey(username,image)',
        builder: (data, id) {
          print(data);
          return StoriesModel.fromMap(data);
        },
      );

      return list;
    } catch (e) {
      rethrow;
    }
  }
}
