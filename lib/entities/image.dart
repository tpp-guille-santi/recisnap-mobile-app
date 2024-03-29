class Image {
  final String filename;
  final String materialName;
  final List<String>? tags;

  Image(this.filename, this.materialName, this.tags);

  Image.fromJson(Map<String, dynamic> json)
      : filename = json['filename'],
        materialName = json['material_name'],
        tags = json['tags'] != null ? List<String>.from(json['tags']) : null;

  Map<String, dynamic> toJson() => {
        'filename': filename,
        'material_name': materialName,
        'tags': tags,
      };
}
