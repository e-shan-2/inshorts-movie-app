import 'package:hive/hive.dart';
import 'movie_model.dart';

class MovieModelAdapter extends TypeAdapter<MovieModel> {
  @override
  final int typeId = 0;

  @override
  MovieModel read(BinaryReader reader) {
    final fields = Map.fromEntries(
      List.generate(reader.readByte(), (_) {
        final key = reader.readByte();
        final value = reader.read();
        return MapEntry(key, value);
      }),
    );

    return MovieModel(
      id: fields[0] as int?,
      title: fields[1] as String?,
      posterPath: fields[2] as String?,
      overview: fields[3] as String?,
      releaseDate: fields[4] as String?,
      genreIds: (fields[5] as List?)?.cast<int>(),
      originalTitle: fields[6] as String?,
      originalLanguage: fields[7] as String?,
      backdropPath: fields[8] as String?,
      adult: fields[9] as bool?,
      video: fields[10] as bool?,
      popularity: fields[11] as double?,
      voteCount: fields[12] as int?,
      voteAverage: fields[13] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, MovieModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.posterPath)
      ..writeByte(3)..write(obj.overview)
      ..writeByte(4)..write(obj.releaseDate)
      ..writeByte(5)..write(obj.genreIds)
      ..writeByte(6)..write(obj.originalTitle)
      ..writeByte(7)..write(obj.originalLanguage)
      ..writeByte(8)..write(obj.backdropPath)
      ..writeByte(9)..write(obj.adult)
      ..writeByte(10)..write(obj.video)
      ..writeByte(11)..write(obj.popularity)
      ..writeByte(12)..write(obj.voteCount)
      ..writeByte(13)..write(obj.voteAverage);
  }
}
