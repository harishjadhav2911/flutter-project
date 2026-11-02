import '../models/movie.dart';

/// Curated demo movie catalog for FlixGo.
/// Uses legitimate publicly accessible cinematic photography with reliable CDNs.
class DemoMovies {
  static const Movie featuredMovie = Movie(
    id: 'dune-2',
    title: 'Dune: Part Two',
    overview:
        'Paul Atreides unites with Chani and the Fremen while seeking revenge against the conspirators who destroyed his family. Facing a choice between the love of his life and the fate of the universe, he endeavors to prevent a terrible future only he can foresee.',
    posterUrl:
        'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=600&auto=format&fit=crop&q=80',
    backdropUrl:
        'https://images.unsplash.com/photo-1509316975850-ff9c5deb0cd9?w=1600&auto=format&fit=crop&q=80',
    rating: 8.6,
    voteCount: 428000,
    releaseYear: 2024,
    duration: '2h 46m',
    ageRating: '16+',
    quality: '4K Ultra HD',
    genres: ['Sci-Fi', 'Adventure', 'Action'],
    director: 'Denis Villeneuve',
    cast: [
      'Timothée Chalamet',
      'Zendaya',
      'Rebecca Ferguson',
      'Javier Bardem',
      'Austin Butler',
    ],
    category: 'trending',
    trailerUrl: 'https://www.youtube.com/watch?v=Way9Dexny3w',
    trailerTitle: 'Dune: Part Two — Official Trailer',
    isFeatured: true,
  );

  static final List<Movie> allMovies = [
    featuredMovie,
    const Movie(
      id: 'interstellar',
      title: 'Interstellar',
      overview:
          'When Earth becomes uninhabitable in the future, a farmer and ex-NASA pilot, Joseph Cooper, is tasked to pilot a spacecraft, along with a team of researchers, to find a new planet for humans.',
      posterUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=1600&auto=format&fit=crop&q=80',
      rating: 8.7,
      voteCount: 1980000,
      releaseYear: 2014,
      duration: '2h 49m',
      ageRating: '13+',
      quality: '4K Ultra HD',
      genres: ['Sci-Fi', 'Adventure', 'Drama'],
      director: 'Christopher Nolan',
      cast: [
        'Matthew McConaughey',
        'Anne Hathaway',
        'Jessica Chastain',
        'Michael Caine',
      ],
      category: 'top_rated',
      trailerUrl: 'https://www.youtube.com/watch?v=zSWdZVtXT7E',
      trailerTitle: 'Interstellar — Official Trailer',
    ),
    const Movie(
      id: 'cyberpunk-neon',
      title: 'Cyberpunk: Neon Horizon',
      overview:
          'In a dystopian metropolis teeming with corruption and cybernetic implants, a rogue street hacker stumbles into a corporate conspiracy that threatens to rewire human consciousness.',
      posterUrl:
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1600&auto=format&fit=crop&q=80',
      rating: 8.4,
      voteCount: 310000,
      releaseYear: 2023,
      duration: '1h 58m',
      ageRating: '18+',
      quality: '4K Ultra HD',
      genres: ['Sci-Fi', 'Action', 'Thriller'],
      director: 'Kenji Kamiyama',
      cast: ['Aoi Yuuki', 'Hiroshi Kamiya', 'Daisuke Ono'],
      category: 'scifi',
      trailerUrl: 'https://www.youtube.com/watch?v=JtqIas3bYhg',
      trailerTitle: 'Cyberpunk: Edgerunners — Official Trailer',
    ),
    const Movie(
      id: 'oppenheimer',
      title: 'Oppenheimer',
      overview:
          'The story of American scientist J. Robert Oppenheimer and his role in the development of the atomic bomb during World War II, exploring moral dilemmas and political fallout.',
      posterUrl:
          'https://images.unsplash.com/photo-1440404653325-ab127d49abc1?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=1600&auto=format&fit=crop&q=80',
      rating: 8.9,
      voteCount: 720000,
      releaseYear: 2023,
      duration: '3h 00m',
      ageRating: '16+',
      quality: '4K Ultra HD',
      genres: ['Biography', 'Drama', 'History'],
      director: 'Christopher Nolan',
      cast: [
        'Cillian Murphy',
        'Emily Blunt',
        'Matt Damon',
        'Robert Downey Jr.',
      ],
      category: 'trending',
      trailerUrl: 'https://www.youtube.com/watch?v=uYPbbksJxIg',
      trailerTitle: 'Oppenheimer — Official Main Trailer',
    ),
    const Movie(
      id: 'the-dark-knight',
      title: 'The Dark Knight',
      overview:
          'When the menace known as the Joker wreaks havoc and chaos on the people of Gotham, Batman must accept one of the greatest psychological and physical tests of his ability to fight injustice.',
      posterUrl:
          'https://images.unsplash.com/photo-1509347528160-9a9e33742cdb?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&auto=format&fit=crop&q=80',
      rating: 9.0,
      voteCount: 2800000,
      releaseYear: 2008,
      duration: '2h 32m',
      ageRating: '16+',
      quality: '4K Ultra HD',
      genres: ['Action', 'Crime', 'Drama'],
      director: 'Christopher Nolan',
      cast: [
        'Christian Bale',
        'Heath Ledger',
        'Aaron Eckhart',
        'Michael Caine',
      ],
      category: 'top_rated',
      trailerUrl: 'https://www.youtube.com/watch?v=EXeTwQWrcwY',
      trailerTitle: 'The Dark Knight — Official Trailer',
    ),
    const Movie(
      id: 'blade-runner-2049',
      title: 'Blade Runner 2049',
      overview:
          'Young Blade Runner K discovers a long-buried secret that leads him to track down former Blade Runner Rick Deckard, who has been missing for thirty years.',
      posterUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1600&auto=format&fit=crop&q=80',
      rating: 8.0,
      voteCount: 610000,
      releaseYear: 2017,
      duration: '2h 44m',
      ageRating: '16+',
      quality: '4K Ultra HD',
      genres: ['Sci-Fi', 'Mystery', 'Action'],
      director: 'Denis Villeneuve',
      cast: ['Ryan Gosling', 'Harrison Ford', 'Ana de Armas', 'Sylvia Hoeks'],
      category: 'scifi',
      trailerUrl: 'https://www.youtube.com/watch?v=gCcx85zbxz4',
      trailerTitle: 'Blade Runner 2049 — Official Trailer',
    ),
    const Movie(
      id: 'inception',
      title: 'Inception',
      overview:
          'A thief who steals corporate secrets through the use of dream-sharing technology is given the inverse task of planting an idea into the mind of a C.E.O., but his tragic past may doom the project.',
      posterUrl:
          'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1477959858617-67f30bc75b82?w=1600&auto=format&fit=crop&q=80',
      rating: 8.8,
      voteCount: 2500000,
      releaseYear: 2010,
      duration: '2h 28m',
      ageRating: '13+',
      quality: '4K Ultra HD',
      genres: ['Action', 'Sci-Fi', 'Adventure'],
      director: 'Christopher Nolan',
      cast: [
        'Leonardo DiCaprio',
        'Joseph Gordon-Levitt',
        'Elliot Page',
        'Tom Hardy',
      ],
      category: 'popular',
      trailerUrl: 'https://www.youtube.com/watch?v=YoHD9XEInc0',
      trailerTitle: 'Inception — Official Theatrical Trailer',
    ),
    const Movie(
      id: 'spider-verse',
      title: 'Across the Spider-Verse',
      overview:
          'Miles Morales catapults across the Multiverse, where he encounters a team of Spider-People charged with protecting its very existence. When heroes clash on handling a new threat, Miles must redefine heroism.',
      posterUrl:
          'https://images.unsplash.com/photo-1635805737707-575885ab0820?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=1600&auto=format&fit=crop&q=80',
      rating: 8.7,
      voteCount: 420000,
      releaseYear: 2023,
      duration: '2h 20m',
      ageRating: 'PG',
      quality: '4K Ultra HD',
      genres: ['Animation', 'Action', 'Adventure'],
      director: 'Joaquim Dos Santos, Kemp Powers',
      cast: [
        'Shameik Moore',
        'Hailee Steinfeld',
        'Oscar Isaac',
        'Daniel Kaluuya',
      ],
      category: 'popular',
      trailerUrl: 'https://www.youtube.com/watch?v=cqGjhVJWtEg',
      trailerTitle: 'Across the Spider-Verse — Official Trailer',
    ),
    const Movie(
      id: 'arcane',
      title: 'Arcane: Piltover Shadows',
      overview:
          'Set in the utopian region of Piltover and the oppressed underground of Zaun, the story follows the origins of two iconic League champions-and the power that will tear them apart.',
      posterUrl:
          'https://images.unsplash.com/photo-1578632767115-351597cf2477?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&auto=format&fit=crop&q=80',
      rating: 9.0,
      voteCount: 260000,
      releaseYear: 2024,
      duration: 'Season 2 • 9 Episodes',
      ageRating: '16+',
      quality: '4K Ultra HD',
      genres: ['Animation', 'Action', 'Sci-Fi'],
      director: 'Christian Linke, Alex Yee',
      cast: ['Hailee Steinfeld', 'Ella Purnell', 'Kevin Alejandro'],
      category: 'trending',
      trailerUrl: 'https://www.youtube.com/watch?v=fX5UShUkLdc',
      trailerTitle: 'Arcane Season 2 — Official Trailer',
    ),
    const Movie(
      id: 'gladiator-2',
      title: 'Gladiator II',
      overview:
          'Years after witnessing the death of the revered hero Maximus at the hands of his uncle, Lucius must enter the Colosseum after his home is conquered by the tyrannical Emperors.',
      posterUrl:
          'https://images.unsplash.com/photo-1533613220915-609f661a6fe1?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1552832230-c0197dd311b5?w=1600&auto=format&fit=crop&q=80',
      rating: 7.8,
      voteCount: 180000,
      releaseYear: 2024,
      duration: '2h 28m',
      ageRating: '18+',
      quality: '4K Ultra HD',
      genres: ['Action', 'Adventure', 'Drama'],
      director: 'Ridley Scott',
      cast: [
        'Paul Mescal',
        'Pedro Pascal',
        'Denzel Washington',
        'Connie Nielsen',
      ],
      category: 'popular',
      trailerUrl: 'https://www.youtube.com/watch?v=4rgYUipGJNo',
      trailerTitle: 'Gladiator II — Official Trailer',
    ),
    const Movie(
      id: 'matrix-resurrections',
      title: 'The Matrix Resurrections',
      overview:
          'Return to a world of two realities: one, everyday life; the other, what lies behind it. To find out if his reality is a construct, to truly know himself, Mr. Anderson will have to choose to follow the white rabbit once more.',
      posterUrl:
          'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1508739773434-c26b3d09e071?w=1600&auto=format&fit=crop&q=80',
      rating: 7.2,
      voteCount: 290000,
      releaseYear: 2021,
      duration: '2h 28m',
      ageRating: '16+',
      quality: '4K Ultra HD',
      genres: ['Sci-Fi', 'Action'],
      director: 'Lana Wachowski',
      cast: [
        'Keanu Reeves',
        'Carrie-Anne Moss',
        'Yahya Abdul-Mateen II',
        'Jessica Henwick',
      ],
      category: 'scifi',
      trailerUrl: 'https://www.youtube.com/watch?v=9ix7TUGVYIo',
      trailerTitle: 'The Matrix Resurrections — Official Trailer',
    ),
    const Movie(
      id: 'stranger-chronicles',
      title: 'Stranger Chronicles',
      overview:
          'When a young boy vanishes into thin air, a small town uncovers a mystery involving secret experiments, terrifying supernatural forces and one strange little girl.',
      posterUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1478760329108-5c3ed9d495a0?w=1600&auto=format&fit=crop&q=80',
      rating: 8.7,
      voteCount: 1200000,
      releaseYear: 2024,
      duration: 'Season 5 • Final Season',
      ageRating: '16+',
      quality: '4K Ultra HD',
      genres: ['Drama', 'Fantasy', 'Horror'],
      director: 'The Duffer Brothers',
      cast: [
        'Millie Bobby Brown',
        'Finn Wolfhard',
        'David Harbour',
        'Winona Ryder',
      ],
      category: 'trending',
      trailerUrl: 'https://www.youtube.com/watch?v=yQEondeGvKo',
      trailerTitle: 'Stranger Chronicles — Official Trailer',
    ),
    const Movie(
      id: 'pulp-fiction',
      title: 'Pulp Fiction',
      overview:
          'The lives of two mob hitmen, a boxer, a gangster and his wife, and a pair of diner bandits intertwine in four tales of violence and redemption in Los Angeles.',
      posterUrl:
          'https://images.unsplash.com/photo-1594909122845-11baa439b7bf?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=1600&auto=format&fit=crop&q=80',
      rating: 8.9,
      voteCount: 2150000,
      releaseYear: 1994,
      duration: '2h 34m',
      ageRating: '18+',
      quality: 'Remastered HD',
      genres: ['Crime', 'Drama'],
      director: 'Quentin Tarantino',
      cast: [
        'John Travolta',
        'Uma Thurman',
        'Samuel L. Jackson',
        'Bruce Willis',
      ],
      category: 'top_rated',
      trailerUrl: 'https://www.youtube.com/watch?v=s7EdQ4FqbhY',
      trailerTitle: 'Pulp Fiction — Official Trailer',
    ),
    const Movie(
      id: 'avengers-endgame',
      title: 'Avengers: Endgame',
      overview:
          'After the devastating events of Infinity War, the universe is in ruins. With the help of remaining allies, the Avengers assemble once more in order to reverse Thanos\' actions and restore balance.',
      posterUrl:
          'https://images.unsplash.com/photo-1607604276583-eef5d076aa5f?w=600&auto=format&fit=crop&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1451187580459-43490279c0fa?w=1600&auto=format&fit=crop&q=80',
      rating: 8.4,
      voteCount: 1250000,
      releaseYear: 2019,
      duration: '3h 01m',
      ageRating: '13+',
      quality: '4K Ultra HD',
      genres: ['Action', 'Adventure', 'Sci-Fi'],
      director: 'Anthony Russo, Joe Russo',
      cast: [
        'Robert Downey Jr.',
        'Chris Evans',
        'Mark Ruffalo',
        'Chris Hemsworth',
        'Scarlett Johansson',
      ],
      category: 'popular',
      trailerUrl: 'https://www.youtube.com/watch?v=TcMBFSGVi1c',
      trailerTitle: 'Avengers: Endgame — Marvel Studios Official Trailer',
    ),
  ];

  static List<Movie> getByCategory(String category) {
    return allMovies.where((m) => m.category == category).toList();
  }

  static List<Movie> get trending => getByCategory('trending');
  static List<Movie> get popular => getByCategory('popular');
  static List<Movie> get topRated => getByCategory('top_rated');
  static List<Movie> get sciFi => getByCategory('scifi');
}
