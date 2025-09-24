import 'package:inshort_app/data/models/date_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'movie_model.dart';

part 'movie_response.g.dart';

@JsonSerializable()
class MovieResponse {
  @JsonKey(name: 'dates')
  final DateModel? date;
  final int? page;

  @JsonKey(name: 'results')
  final List<MovieModel>? movies;
  @JsonKey(name: 'total_pages')
  final int? totalPages;
  @JsonKey(name: 'total_results')
  final int? totalResult;

  MovieResponse(
      {this.page, this.movies, this.date, this.totalPages, this.totalResult});

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}
