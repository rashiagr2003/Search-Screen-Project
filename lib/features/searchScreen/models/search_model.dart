class SearchScreenModel {
  double? score;
  Show? show;

  SearchScreenModel({this.score, this.show});

  factory SearchScreenModel.fromJson(Map<String, dynamic> json) {
    return SearchScreenModel(
      score: json['score'],
      show: json['show'] != null ? Show.fromJson(json['show']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'score': score,
      'show': show?.toJson(),
    };
  }
}

class Show {
  int? id;
  String? url;
  String? name;
  String? type;
  String? language;
  List<String>? genres;
  String? status;
  int? runtime;
  int? averageRuntime;
  String? premiered;
  String? ended; // Changed from Null to String?
  String? officialSite;
  Schedule? schedule;
  Rating? rating;
  int? weight;
  Network? network;
  dynamic webChannel; // Changed from Null
  dynamic dvdCountry; // Changed from Null
  Externals? externals;
  Image? image;
  String? summary;
  int? updated;
  Links? links; // Corrected name from lLinks to links

  Show({
    this.id,
    this.url,
    this.name,
    this.type,
    this.language,
    this.genres,
    this.status,
    this.runtime,
    this.averageRuntime,
    this.premiered,
    this.ended,
    this.officialSite,
    this.schedule,
    this.rating,
    this.weight,
    this.network,
    this.webChannel,
    this.dvdCountry,
    this.externals,
    this.image,
    this.summary,
    this.updated,
    this.links,
  });

  factory Show.fromJson(Map<String, dynamic> json) {
    return Show(
      id: json['id'],
      url: json['url'],
      name: json['name'],
      type: json['type'],
      language: json['language'],
      genres: List<String>.from(json['genres']),
      status: json['status'],
      runtime: json['runtime'],
      averageRuntime: json['averageRuntime'],
      premiered: json['premiered'],
      ended: json['ended'],
      officialSite: json['officialSite'],
      schedule:
          json['schedule'] != null ? Schedule.fromJson(json['schedule']) : null,
      rating: json['rating'] != null ? Rating.fromJson(json['rating']) : null,
      weight: json['weight'],
      network:
          json['network'] != null ? Network.fromJson(json['network']) : null,
      webChannel: json['webChannel'],
      dvdCountry: json['dvdCountry'],
      externals: json['externals'] != null
          ? Externals.fromJson(json['externals'])
          : null,
      image: json['image'] != null ? Image.fromJson(json['image']) : null,
      summary: json['summary'],
      updated: json['updated'],
      links: json['_links'] != null ? Links.fromJson(json['_links']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'name': name,
      'type': type,
      'language': language,
      'genres': genres,
      'status': status,
      'runtime': runtime,
      'averageRuntime': averageRuntime,
      'premiered': premiered,
      'ended': ended,
      'officialSite': officialSite,
      'schedule': schedule?.toJson(),
      'rating': rating?.toJson(),
      'weight': weight,
      'network': network?.toJson(),
      'webChannel': webChannel,
      'dvdCountry': dvdCountry,
      'externals': externals?.toJson(),
      'image': image?.toJson(),
      'summary': summary,
      'updated': updated,
      '_links': links?.toJson(),
    };
  }
}

class Schedule {
  String? time;
  List<String>? days;

  Schedule({this.time, this.days});

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      time: json['time'],
      days: List<String>.from(json['days']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'days': days,
    };
  }
}

class Rating {
  double? average;

  Rating({this.average});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      average: json['average']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'average': average,
    };
  }
}

class Network {
  int? id;
  String? name;
  Country? country;
  String? officialSite;

  Network({this.id, this.name, this.country, this.officialSite});

  factory Network.fromJson(Map<String, dynamic> json) {
    return Network(
      id: json['id'],
      name: json['name'],
      country:
          json['country'] != null ? Country.fromJson(json['country']) : null,
      officialSite: json['officialSite'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country?.toJson(),
      'officialSite': officialSite,
    };
  }
}

class Country {
  String? name;
  String? code;
  String? timezone;

  Country({this.name, this.code, this.timezone});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      name: json['name'],
      code: json['code'],
      timezone: json['timezone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'code': code,
      'timezone': timezone,
    };
  }
}

class Externals {
  int? tvrage;
  int? thetvdb;
  String? imdb;

  Externals({this.tvrage, this.thetvdb, this.imdb});

  factory Externals.fromJson(Map<String, dynamic> json) {
    return Externals(
      tvrage: json['tvrage'],
      thetvdb: json['thetvdb'],
      imdb: json['imdb'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tvrage': tvrage,
      'thetvdb': thetvdb,
      'imdb': imdb,
    };
  }
}

class Image {
  String? medium;
  String? original;

  Image({this.medium, this.original});

  factory Image.fromJson(Map<String, dynamic> json) {
    return Image(
      medium: json['medium'],
      original: json['original'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'medium': medium,
      'original': original,
    };
  }
}

class Links {
  Self? self;
  Previousepisode? previousepisode;

  Links({this.self, this.previousepisode});

  factory Links.fromJson(Map<String, dynamic> json) {
    return Links(
      self: json['self'] != null ? Self.fromJson(json['self']) : null,
      previousepisode: json['previousepisode'] != null
          ? Previousepisode.fromJson(json['previousepisode'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'self': self?.toJson(),
      'previousepisode': previousepisode?.toJson(),
    };
  }
}

class Self {
  String? href;

  Self({this.href});

  factory Self.fromJson(Map<String, dynamic> json) {
    return Self(
      href: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
    };
  }
}

class Previousepisode {
  String? href;
  String? name;

  Previousepisode({this.href, this.name});

  factory Previousepisode.fromJson(Map<String, dynamic> json) {
    return Previousepisode(
      href: json['href'],
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'href': href,
      'name': name,
    };
  }
}
