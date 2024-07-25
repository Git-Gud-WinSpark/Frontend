import 'package:frontend/models/channel.dart';

class Community {
  final String? id;
  final String name;
  // final String? imageUrl;
  final List<Channel>? channels;

  const Community({
    this.id,
    required this.name,
    // this.imageUrl,
    this.channels,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    print(json);
    return Community(
      id: json['_id'],
      name: json['communityName'],
      // imageUrl: json['image'],
      channels: (json['channels'] as List).map((i)=>Channel.fromJson(i)).toList(),
    );
  }
}
