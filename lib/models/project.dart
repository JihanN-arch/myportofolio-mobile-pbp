import 'package:json_annotation/json_annotation.dart';

part 'project.g.dart';

/// Data project yang disinkronkan dengan API Django (/api/v1/projects/).
@JsonSerializable(fieldRename: FieldRename.snake)
class Project {
  const Project({
    required this.title,
    this.id,
    this.image,
    this.githubUrl,
    this.demoUrl,
    this.year,
    this.category = 'web',
    this.categoryDisplay = '',
  });

  factory Project.fromJson(Map<String, dynamic> json) =>
      _$ProjectFromJson(json);

  /// UUID dibuat oleh server, jadi tidak ikut dikirim saat POST.
  @JsonKey(includeToJson: false)
  final String? id;

  final String title;
  final String? image;
  final String? githubUrl;
  final String? demoUrl;
  final int? year;

  @JsonKey(defaultValue: 'web')
  final String category;

  /// Label kategori dari server (read-only), misalnya "Web".
  @JsonKey(includeToJson: false, defaultValue: '')
  final String categoryDisplay;

  Map<String, dynamic> toJson() => _$ProjectToJson(this);
}
