class Community {
  final String name;
  final String? imageUrl;
  final List<String>? channels;

  const Community({
    required this.name,
    this.imageUrl,
    this.channels,
  });
}