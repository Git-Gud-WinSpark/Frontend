import 'package:frontend/models/channel.dart';

class Community {
  final String? id;
  final String name;
  final String? imageUrl;
  final List<String>? tags;
  final List<Channel>? channels;

  const Community({
    this.id,
    required this.name,
    this.imageUrl,
    this.channels,
    this.tags,
  });

  factory Community.fromJson(Map<String, dynamic> json) {
    return Community(
      id: json['_id'],
      name: json['communityName'],
      imageUrl: json['profilePicture'],
      tags: json['tag'] != null
          ? (json['tag'] as List).map((i) => i.toString()).toList()
          : [],
      channels: json['channels'] != null?
          (json['channels'] as List).map((i) => Channel.fromJson(i)).toList():[],
    );
  }
}
