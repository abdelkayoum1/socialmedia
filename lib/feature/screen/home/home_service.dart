import 'package:socialmedia/core/supabase_database.dart';
import 'package:socialmedia/feature/screen/home/model/post_model.dart';

class HomeService {
  final supabase = SupabaseDatabase();

  Future<List<PostModel>> fetchrows() async {
    try {
      return await supabase.fetchrows(
        primaryKey: ['id'],
        table: 'post',
        builder: (data, id) => PostModel.fromMap(data),
      );
    } catch (e) {
      rethrow;
    }
  }
}
