class Channel {
  String name;
  String? id;
  Channel({required this.name, this.id});

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(name: json['channelName'], id: json['_id']);
  }
}
