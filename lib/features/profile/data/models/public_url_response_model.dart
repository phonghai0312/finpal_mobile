class PublicUrlResponseModel {
  final String url;
  final String path;

  PublicUrlResponseModel({
    required this.url,
    required this.path,
  });

  factory PublicUrlResponseModel.fromJson(Map<String, dynamic> json) {
    return PublicUrlResponseModel(
      url: json['url']?.toString() ?? '',
      path: json['path']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'url': url, 'path': path};
  }
}


