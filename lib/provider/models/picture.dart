class Picture {
  String id;
  String imgURL;
  String? uploader;

  String get getImgURL {
    return imgURL;
  }

  Picture({required this.id, required this.imgURL, required this.uploader});

  Map<String, dynamic> toJson() => {'id': id, 'img_uploader': uploader, 'img_url': imgURL};
}
