class CountryModel {
  const CountryModel({
    required this.name,
    required this.officialName,
    required this.code,
    required this.code3,
    required this.capital,
    required this.flag,
    required this.flagUrl,
    required this.latitude,
    required this.longitude,
    required this.region,
    required this.subregion,
    required this.population,
    required this.area,
    required this.languages,
    required this.currencies,
    required this.timezones,
    required this.continents,
    required this.borders,
    required this.independent,
    required this.unMember,
    required this.drivingSide,
    required this.phoneCode,
    required this.tld,
  });

  final String name;
  final String officialName;

  final String code;
  final String code3;

  final String capital;

  /// Country flag emoji.
  final String flag;

  /// PNG/SVG URL.
  final String flagUrl;

  final double latitude;
  final double longitude;

  final String region;
  final String subregion;

  final int population;
  final double area;

  final List<String> languages;
  final List<String> currencies;
  final List<String> timezones;
  final List<String> continents;
  final List<String> borders;

  final bool independent;
  final bool unMember;

  final String drivingSide;
  final String phoneCode;
  final String tld;

  // ------------------------------------------------------------
  // DISPLAY HELPERS
  // ------------------------------------------------------------

  String get languagesText {
    return languages.isEmpty ? 'N/A' : languages.join(', ');
  }

  String get currenciesText {
    return currencies.isEmpty ? 'N/A' : currencies.join(', ');
  }

  String get timezonesText {
    return timezones.isEmpty ? 'N/A' : timezones.join(', ');
  }

  String get continentsText {
    return continents.isEmpty ? 'N/A' : continents.join(', ');
  }

  String get bordersText {
    return borders.isEmpty ? 'None' : borders.join(', ');
  }

  String get latitudeText {
    return latitude == 0 ? 'N/A' : latitude.toStringAsFixed(4);
  }

  String get longitudeText {
    return longitude == 0 ? 'N/A' : longitude.toStringAsFixed(4);
  }

  bool get hasCoordinates {
    return latitude != 0 || longitude != 0;
  }

  bool get hasFlagUrl {
    return flagUrl.trim().isNotEmpty;
  }

  // ------------------------------------------------------------
  // JSON
  // ------------------------------------------------------------

  factory CountryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    // ----------------------------------------------------------
    // NAMES
    // ----------------------------------------------------------

    final names = _map(json['names']);
    final apiName = _map(json['name']);

    final name = _string(
      names?['common'],
      _string(
        apiName?['common'] ?? json['name'],
        'Unknown',
      ),
    );

    final officialName = _string(
      names?['official'] ?? apiName?['official'],
      name,
    );

    // ----------------------------------------------------------
    // CAPITAL
    // ----------------------------------------------------------

    final capitalData = json['capitals'] ?? json['capital'];
    final capital = _extractCapital(
      capitalData,
    );

    // ----------------------------------------------------------
    // COUNTRY CODES
    // ----------------------------------------------------------

    final codes = _map(json['codes']);
    final code = _string(
      json['cca2'] ??
          codes?['alpha_2'] ??
          codes?['alpha2'] ??
          json['alpha2Code'] ??
          json['code'],
      '',
    ).toUpperCase();

    final code3 = _string(
      json['cca3'] ??
          codes?['alpha_3'] ??
          codes?['alpha3'] ??
          json['alpha3Code'] ??
          json['code3'],
      '',
    ).toUpperCase();

    // ----------------------------------------------------------
    // LATITUDE / LONGITUDE
    // ----------------------------------------------------------

    double latitude = 0;
    double longitude = 0;

    final latLng = json['latlng'] ?? json['coordinates'];

    if (latLng is List && latLng.length >= 2) {
      latitude = _double(latLng[0]);
      longitude = _double(latLng[1]);
    } else if (latLng is Map) {
      latitude = _double(
        latLng['latitude'] ?? latLng['lat'],
      );
      longitude = _double(
        latLng['longitude'] ?? latLng['lng'] ?? latLng['lon'],
      );
    }

    if (latitude == 0 && longitude == 0) {
      final capitalCoordinates = _extractCapitalCoordinates(capitalData);
      if (capitalCoordinates != null) {
        latitude = capitalCoordinates.$1;
        longitude = capitalCoordinates.$2;
      }
    }

    // Some APIs may provide latitude/longitude separately.
    if (latitude == 0 && longitude == 0) {
      latitude = _double(
        json['latitude'] ?? json['lat'],
      );

      longitude = _double(
        json['longitude'] ?? json['lng'] ?? json['lon'],
      );
    }

    // ----------------------------------------------------------
    // FLAGS
    // ----------------------------------------------------------

    final flags = _map(json['flags']);
    final flagData = json['flag'];
    final flagDetails = _map(flagData);

    String flagUrl = '';

    if (flags != null) {
      flagUrl = _string(
        flags['png'],
        '',
      );

      if (flagUrl.isEmpty) {
        flagUrl = _string(
          flags['svg'],
          '',
        );
      }
    }

    if (flagUrl.isEmpty) {
      flagUrl = _string(
        flagDetails?['url_svg'] ??
            flagDetails?['url_png'] ??
            flagDetails?['url'] ??
            json['flagUrl'] ??
            json['flag_url'],
        '',
      );
    }

    final flag = _string(
      flagDetails?['emoji'] ?? (flagData is String ? flagData : null),
      _flagFromCountryCode(code),
    );

    // ----------------------------------------------------------
    // REGION
    // ----------------------------------------------------------

    final region = _string(
      json['region'],
      'N/A',
    );

    final subregion = _string(
      json['subregion'],
      'N/A',
    );

    // ----------------------------------------------------------
    // POPULATION
    // ----------------------------------------------------------

    final population = _int(
      json['population'],
    );

    // ----------------------------------------------------------
    // AREA
    // ----------------------------------------------------------

    double area = 0;

    final areaMap = _map(json['area']);

    if (areaMap != null) {
      area = _double(
        areaMap['kilometers'],
      );

      if (area == 0) {
        area = _double(
          areaMap['km2'],
        );
      }
    } else {
      area = _double(
        json['area'],
      );
    }

    // ----------------------------------------------------------
    // LANGUAGES
    // ----------------------------------------------------------

    final languages = <String>[];

    final languageData = json['languages'];

    if (languageData is List) {
      for (final item in languageData) {
        if (item is Map) {
          final language = _string(
            item['name'],
            '',
          );

          if (language.isNotEmpty) {
            languages.add(language);
          }
        } else if (item is String && item.isNotEmpty) {
          languages.add(item);
        }
      }
    } else if (languageData is Map) {
      for (final language in languageData.values) {
        final value = _string(language, '');

        if (value.isNotEmpty) {
          languages.add(value);
        }
      }
    }

    // ----------------------------------------------------------
    // CURRENCIES
    // ----------------------------------------------------------

    final currencies = <String>[];

    final currencyData = json['currencies'];

    if (currencyData is List) {
      for (final item in currencyData) {
        if (item is Map) {
          final currencyName = _string(
            item['name'],
            '',
          );

          final currencyCode = _string(
            item['code'],
            '',
          );

          if (currencyName.isNotEmpty && currencyCode.isNotEmpty) {
            currencies.add(
              '$currencyName ($currencyCode)',
            );
          } else if (currencyName.isNotEmpty) {
            currencies.add(currencyName);
          } else if (currencyCode.isNotEmpty) {
            currencies.add(currencyCode);
          }
        } else if (item is String && item.isNotEmpty) {
          currencies.add(item);
        }
      }
    } else if (currencyData is Map) {
      for (final entry in currencyData.entries) {
        final currencyCode = _string(entry.key, '');
        final currency = _map(entry.value);
        final currencyName = _string(
          currency?['name'],
          '',
        );

        if (currencyName.isNotEmpty && currencyCode.isNotEmpty) {
          currencies.add('$currencyName ($currencyCode)');
        } else if (currencyName.isNotEmpty) {
          currencies.add(currencyName);
        } else if (currencyCode.isNotEmpty) {
          currencies.add(currencyCode);
        }
      }
    }

    // ----------------------------------------------------------
    // TIMEZONES
    // ----------------------------------------------------------

    final timezones = <String>[];

    final timezoneData = json['timezones'];

    if (timezoneData is List) {
      for (final item in timezoneData) {
        if (item is String && item.isNotEmpty) {
          timezones.add(item);
        }
      }
    }

    // ----------------------------------------------------------
    // CONTINENTS
    // ----------------------------------------------------------

    final continents = <String>[];

    final continentData = json['continents'];

    if (continentData is List) {
      for (final item in continentData) {
        if (item is String && item.isNotEmpty) {
          continents.add(item);
        }
      }
    }

    // ----------------------------------------------------------
    // BORDERS
    // ----------------------------------------------------------

    final borders = <String>[];

    final borderData = json['borders'];

    if (borderData is List) {
      for (final item in borderData) {
        if (item is String && item.isNotEmpty) {
          borders.add(item);
        }
      }
    }

    // ----------------------------------------------------------
    // INDEPENDENT
    // ----------------------------------------------------------

    final independent = json['independent'] == true;

    // ----------------------------------------------------------
    // UN MEMBER
    // ----------------------------------------------------------

    final memberships = _map(json['memberships']);
    final unMember = json['unMember'] == true || memberships?['un'] == true;

    // ----------------------------------------------------------
    // DRIVING SIDE
    // ----------------------------------------------------------

    var drivingSide = 'N/A';

    final car = _map(json['car']);

    if (car != null) {
      drivingSide = _string(
        car['side'],
        'N/A',
      );
    }

    // ----------------------------------------------------------
    // PHONE CODE
    // ----------------------------------------------------------

    var phoneCode = 'N/A';

    final idd = _map(json['idd']);

    if (idd != null) {
      final root = _string(
        idd['root'],
        '',
      );

      final suffixes = idd['suffixes'];

      if (root.isNotEmpty && suffixes is List && suffixes.isNotEmpty) {
        final suffix = _string(
          suffixes.first,
          '',
        );

        phoneCode = '$root$suffix';
      } else if (root.isNotEmpty) {
        phoneCode = root;
      }
    }

    if (phoneCode == 'N/A') {
      final callingCodes = json['calling_codes'];
      if (callingCodes is List && callingCodes.isNotEmpty) {
        final values = callingCodes
            .map((value) => _string(value, ''))
            .where((value) => value.isNotEmpty)
            .map((value) => value.startsWith('+') ? value : '+$value')
            .toList();
        if (values.isNotEmpty) {
          phoneCode = values.join(', ');
        }
      }
    }

    // ----------------------------------------------------------
    // TLD
    // ----------------------------------------------------------

    var tld = 'N/A';

    final tldData = json['tld'];

    if (tldData is List) {
      final values = tldData
          .whereType<String>()
          .where((value) => value.isNotEmpty)
          .toList();

      if (values.isNotEmpty) {
        tld = values.join(', ');
      }
    } else if (tldData is String && tldData.isNotEmpty) {
      tld = tldData;
    }

    // ----------------------------------------------------------
    // FINAL MODEL
    // ----------------------------------------------------------

    return CountryModel(
      name: name,
      officialName: officialName,
      code: code,
      code3: code3,
      capital: capital,
      flag: flag,
      flagUrl: flagUrl,
      latitude: latitude,
      longitude: longitude,
      region: region,
      subregion: subregion,
      population: population,
      area: area,
      languages: languages,
      currencies: currencies,
      timezones: timezones,
      continents: continents,
      borders: borders,
      independent: independent,
      unMember: unMember,
      drivingSide: drivingSide,
      phoneCode: phoneCode,
      tld: tld,
    );
  }

  // ------------------------------------------------------------
  // HELPERS
  // ------------------------------------------------------------

  static Map<String, dynamic>? _map(
    dynamic value,
  ) {
    if (value is Map<String, dynamic>) {
      return value;
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return null;
  }

  static String _string(
    dynamic value,
    String fallback,
  ) {
    if (value == null) {
      return fallback;
    }

    final result = value.toString().trim();

    if (result.isEmpty || result == 'null') {
      return fallback;
    }

    return result;
  }

  static String _extractCapital(
    dynamic value,
  ) {
    if (value is List) {
      final capitals = value
          .map((item) {
            if (item is Map) {
              return _string(item['name'], '');
            }
            return _string(item, '');
          })
          .where((item) => item.isNotEmpty)
          .toList();

      if (capitals.isNotEmpty) {
        return capitals.join(', ');
      }
    }

    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }

    if (value is Map) {
      return _string(
        value['common'] ?? value['name'],
        'N/A',
      );
    }

    return 'N/A';
  }

  static (double, double)? _extractCapitalCoordinates(dynamic value) {
    if (value is! List) {
      return null;
    }

    final capitalMaps = value.whereType<Map>().toList();
    if (capitalMaps.isEmpty) {
      return null;
    }

    final primaryCapital = capitalMaps.firstWhere(
      (capital) {
        final attributes = _map(capital['attributes']);
        return attributes?['primary'] == true;
      },
      orElse: () => capitalMaps.first,
    );
    final coordinates = _map(primaryCapital['coordinates']);
    if (coordinates != null) {
      final latitude = _double(coordinates['lat'] ?? coordinates['latitude']);
      final longitude = _double(coordinates['lng'] ?? coordinates['longitude']);
      if (latitude != 0 || longitude != 0) {
        return (latitude, longitude);
      }
    }

    final coordinatesList = primaryCapital['coordinates'];
    if (coordinatesList is List && coordinatesList.length >= 2) {
      final latitude = _double(coordinatesList[0]);
      final longitude = _double(coordinatesList[1]);
      if (latitude != 0 || longitude != 0) {
        return (latitude, longitude);
      }
    }

    return null;
  }

  static double _double(
    dynamic value,
  ) {
    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  static int _int(
    dynamic value,
  ) {
    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.toInt();
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }

  // ------------------------------------------------------------
  // COUNTRY CODE -> EMOJI
  // ------------------------------------------------------------

  static String _flagFromCountryCode(
    String code,
  ) {
    if (code.length != 2) {
      return '🌐';
    }

    final upper = code.toUpperCase();

    final first = upper.codeUnitAt(0);
    final second = upper.codeUnitAt(1);

    if (first < 65 || first > 90 || second < 65 || second > 90) {
      return '🌐';
    }

    return String.fromCharCodes([
      first + 127397,
      second + 127397,
    ]);
  }
}
