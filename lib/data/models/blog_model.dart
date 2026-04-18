class BlogModel {
  final int id;
  final String title;
  final String category;
  final String description;
  final String content;
  final String? imageUrl;

  const BlogModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.content,
    this.imageUrl,
  });

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      title: json['title'],
      category: json['category'],
      description: json['description'],
      content: json['content'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'content': content,
      'imageUrl': imageUrl,
    };
  }
}
