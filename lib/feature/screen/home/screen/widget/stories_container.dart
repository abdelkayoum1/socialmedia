import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:socialmedia/feature/screen/home/model/stories_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Storiescontainer extends StatelessWidget {
  final bool isstories;
  final StoriesModel? stories;
  const Storiescontainer({super.key, this.isstories = false, this.stories});

  @override
  Widget build(BuildContext context) {
    final image = stories?.image != null
        ? Supabase.instance.client.storage
              .from('image')
              .getPublicUrl(stories!.image!)
        : null;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            width: 100,
            // height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.blueAccent, width: 2),
              // borderRadius: BorderRadius.circular(12),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(image ?? 'assets/logo.png'),
              radius: 30,
              backgroundColor: isstories ? Colors.blue : null,
              child: isstories ? Icon(Icons.add, color: Colors.white) : null,
            ),
          ),
          isstories
              ? Text('Add Stories')
              : Text(
                  stories?.username ?? 'kh',
                  style: TextStyle(color: Colors.red),
                ),
        ],
      ),
    );
  }
}
