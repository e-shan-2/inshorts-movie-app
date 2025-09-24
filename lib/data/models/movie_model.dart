import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class MovieModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? title;

  @HiveField(2)
  @JsonKey(name: 'poster_path')
  final String? posterPath;

  @HiveField(3)
  @JsonKey(name: 'overview')
  final String? overview;

  @HiveField(4)
  @JsonKey(name: 'release_date')
  final String? releaseDate;

  @HiveField(5)
  @JsonKey(name: 'genre_ids')
  final List<int>? genreIds;

  @HiveField(6)
  @JsonKey(name: 'original_title')
  final String? originalTitle;

  @HiveField(7)
  @JsonKey(name: 'original_language')
  final String? originalLanguage;

  @HiveField(8)
  @JsonKey(name: 'backdrop_path')
  final String? backdropPath;

  @HiveField(9)
  final bool? adult;

  @HiveField(10)
  final bool? video;

  @HiveField(11)
  final double? popularity;

  @HiveField(12)
  @JsonKey(name: 'vote_count')
  final int? voteCount;

  @HiveField(13)
  @JsonKey(name: 'vote_average')
  final double? voteAverage;
  @HiveField(14)
@JsonKey(name: 'bookMarked')
  final bool? bookMarked;
  MovieModel({
    this.id,
    this.title,
    this.posterPath,
    this.overview,
    this.releaseDate,
    this.genreIds,
    this.originalTitle,
    this.originalLanguage,
    this.backdropPath,
    this.adult,
    this.video,
    this.popularity,
    this.voteCount,
    this.voteAverage,
    this.bookMarked
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) =>
      _$MovieModelFromJson(json);

  Map<String, dynamic> toJson() => _$MovieModelToJson(this);
}
