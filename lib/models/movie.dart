/// Movie represents a film or series entry in the FlixGo catalog.
class Movie {
  final String id;
  final String title;
  final String overview;
  final String posterUrl;
  final String backdropUrl;
  final double rating;
  final int voteCount;
  final int releaseYear;
  final String duration;
  final String ageRating;
  final String quality;
  final List<String> genres;
  final String director;
  final List<String> cast;
  final String category;
  final String trailerUrl;
  final String trailerTitle;
  final bool isFeatured;

  const Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterUrl,
    required this.backdropUrl,
    required this.rating,
    required this.voteCount,
    required this.releaseYear,
    required this.duration,
    this.ageRating = '16+',
    this.quality = '4K UHD',
    required this.genres,
    required this.director,
    required this.cast,
    required this.category,
    this.trailerUrl = '',
    this.trailerTitle = 'Official Trailer',
    this.isFeatured = false,
  });

  /// Extracts the 11-character YouTube video ID if configured.
  String? get youtubeVideoId {
    final trimmed = trailerUrl.trim();
    if (trimmed.isEmpty) return null;

    // Check if directly an 11-character YouTube video ID
    if (RegExp(r'^[a-zA-Z0-9_-]{11}$').hasMatch(trimmed)) {
      return trimmed;
    }

    // Parse from standard YouTube URLs (watch?v=..., youtu.be/..., embed/...)
    final regExp = RegExp(
      r'(?:https?:\/\/)?(?:www\.|m\.)?(?:youtube\.com\/(?:watch\?v=|embed\/|v\/|shorts\/)|youtu\.be\/)([\w-]{11})',
      caseSensitive: false,
    );
    final match = regExp.firstMatch(trimmed);
    if (match != null && match.groupCount >= 1) {
      return match.group(1);
    }

    return null;
  }

  /// Whether a valid YouTube trailer is available for this title.
  bool get hasTrailer => youtubeVideoId != null;

  /// Full legitimate YouTube watch URL for browser navigation or fallback.
  String? get youtubeWatchUrl {
    final id = youtubeVideoId;
    if (id == null) return null;
    return 'https://www.youtube.com/watch?v=$id';
  }

  Movie copyWith({
    String? id,
    String? title,
    String? overview,
    String? posterUrl,
    String? backdropUrl,
    double? rating,
    int? voteCount,
    int? releaseYear,
    String? duration,
    String? ageRating,
    String? quality,
    List<String>? genres,
    String? director,
    List<String>? cast,
    String? category,
    String? trailerUrl,
    String? trailerTitle,
    bool? isFeatured,
  }) {
    return Movie(
      id: id ?? this.id,
      title: title ?? this.title,
      overview: overview ?? this.overview,
      posterUrl: posterUrl ?? this.posterUrl,
      backdropUrl: backdropUrl ?? this.backdropUrl,
      rating: rating ?? this.rating,
      voteCount: voteCount ?? this.voteCount,
      releaseYear: releaseYear ?? this.releaseYear,
      duration: duration ?? this.duration,
      ageRating: ageRating ?? this.ageRating,
      quality: quality ?? this.quality,
      genres: genres ?? this.genres,
      director: director ?? this.director,
      cast: cast ?? this.cast,
      category: category ?? this.category,
      trailerUrl: trailerUrl ?? this.trailerUrl,
      trailerTitle: trailerTitle ?? this.trailerTitle,
      isFeatured: isFeatured ?? this.isFeatured,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'posterUrl': posterUrl,
      'backdropUrl': backdropUrl,
      'rating': rating,
      'voteCount': voteCount,
      'releaseYear': releaseYear,
      'duration': duration,
      'ageRating': ageRating,
      'quality': quality,
      'genres': genres,
      'director': director,
      'cast': cast,
      'category': category,
      'trailerUrl': trailerUrl,
      'trailerTitle': trailerTitle,
      'isFeatured': isFeatured,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      overview: map['overview'] as String? ?? '',
      posterUrl: map['posterUrl'] as String? ?? '',
      backdropUrl: map['backdropUrl'] as String? ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      voteCount: (map['voteCount'] as num?)?.toInt() ?? 0,
      releaseYear: (map['releaseYear'] as num?)?.toInt() ?? 2024,
      duration: map['duration'] as String? ?? '2h',
      ageRating: map['ageRating'] as String? ?? '16+',
      quality: map['quality'] as String? ?? '4K UHD',
      genres: List<String>.from(map['genres'] as List? ?? []),
      director: map['director'] as String? ?? '',
      cast: List<String>.from(map['cast'] as List? ?? []),
      category: map['category'] as String? ?? 'popular',
      trailerUrl: map['trailerUrl'] as String? ?? '',
      trailerTitle: map['trailerTitle'] as String? ?? 'Official Trailer',
      isFeatured: map['isFeatured'] as bool? ?? false,
    );
  }
}
