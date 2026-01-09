class PresignedUrlResponseModel {
  final String url;
  final String name;
  final String path;

  PresignedUrlResponseModel({
    required this.url,
    required this.name,
    required this.path,
  });

  factory PresignedUrlResponseModel.fromJson(Map<String, dynamic> json) {
    return PresignedUrlResponseModel(
      url: json['url']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'name': name, 'path': path};
  }
}

