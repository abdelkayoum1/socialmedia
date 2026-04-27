import 'dart:collection';

import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabase {
  SupabaseClient supabase = Supabase.instance.client;
  final supabasee = Supabase.instance.client.auth;

  Future<void> insertrow({
    required String table,
    required Map<String, dynamic> data,
    String? select,
  }) async {
    try {
      await supabase.from(table).insert(data);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> updaterow({
    required String table,
    required Map<String, dynamic> data,
    required String col,
    required String value,
  }) async {
    try {
      await supabase.from(table).update(data).eq(col, value);
    } catch (e) {
      print('update error on  $table where $col==$value:${e.toString()}');
      rethrow;
    }
  }

  Future<void> upsert({
    required String table,
    required Map<String, dynamic> data,
    required String onconflit,
    bool ingoreduplicates = true,
  }) async {
    try {
      await supabase
          .from(table)
          .upsert(
            data,
            onConflict: onconflit,
            ignoreDuplicates: ingoreduplicates,
          );
    } catch (e) {
      print('upsert error on  $table ${e.toString()}');
      rethrow;
    }
  }

  Future<void> deleterow({
    required String table,

    required String col,
    required String value,
  }) async {
    try {
      await supabase.from(table).delete().eq(col, value);
    } catch (e) {
      print('delate error on  $table where $col==$value:${e.toString()}');
      rethrow;
    }
  }

  Stream<List<T>> streamtable<T>({
    required List<String> primaryKey,
    required String table,
    required T Function(Map<String, dynamic>, String id) builder,
  }) {
    final db = supabase.from(table).stream(primaryKey: primaryKey);
    return db.map((rows) {
      final list = rows.map((row) {
        final id = row[primaryKey.first]?.toString() ?? '';
        return builder(row, id);
      }).toList();
      return list;
    });
  }

  Future<List<T>> fetchrows<T>({
    required List<String> primaryKey,
    required String table,
    String? selectquery,
    required T Function(Map<String, dynamic>, String id) builder,
    PostgrestFilterBuilder Function(PostgrestFilterBuilder query)? filter,
  }) async {
    var db =
        supabase.from(table).select(selectquery ?? '*')
            as PostgrestFilterBuilder;
    if (filter != null) {
      db = filter(db);
    }
    final rows = (await db) as List<dynamic>;
    final maplist = rows.map((row) {
      // final list = row as Map<String, dynamic>;

      final id = row[primaryKey.first]?.toString() ?? '';
      return builder(row, id);
    }).toList();
    return maplist;
  }

  Future<T> fetchrow<T>({
    required String primaryKey,
    required String table,
    required String id,
    String? text,
    PostgrestFilterBuilder Function(PostgrestFilterBuilder query)? filter,
    required T Function(Map<String, dynamic>, String id) builder,
  }) async {
    var db = await supabase.from(table).select().eq(primaryKey, id).single();

    return builder(db, db[primaryKey]?.toString() ?? '');
  }

  User? getuser() {
    return supabasee.currentUser;
  }
}
