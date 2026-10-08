import 'package:flutter_test/flutter_test.dart';

import 'package:country_weather_explorer/features/countries/data/models/country_model.dart';

void main() {
  group('CountryModel.fromJson', () {
    test('reads the REST Countries v5 response shape', () {
      final country = CountryModel.fromJson({
        'names': {
          'common': 'Canada',
          'official': 'Canada',
        },
        'codes': {
          'alpha_2': 'CA',
          'alpha_3': 'CAN',
        },
        'capitals': [
          {
            'name': 'Ottawa',
            'attributes': {'primary': true},
            'coordinates': {'lat': 45.4247, 'lng': -75.695},
          },
        ],
        'currencies': [
          {'code': 'CAD', 'name': 'Canadian dollar', 'symbol': r'$'},
        ],
        'languages': {
          'eng': 'English',
          'fra': 'French',
        },
        'region': 'Americas',
        'subregion': 'North America',
        'population': 41575585,
        'area': {'kilometers': 9984670},
        'timezones': ['UTC-08:00'],
        'continents': ['North America'],
        'borders': ['USA'],
        'calling_codes': ['1'],
        'memberships': {'un': true},
        'flag': {
          'emoji': '🇨🇦',
          'url_svg': 'https://flags.restcountries.com/v5/w320/ca.svg',
        },
        'car': {'side': 'right'},
        'tld': ['.ca'],
      });

      expect(country.name, 'Canada');
      expect(country.officialName, 'Canada');
      expect(country.code, 'CA');
      expect(country.code3, 'CAN');
      expect(country.capital, 'Ottawa');
      expect(country.flag, '🇨🇦');
      expect(
        country.flagUrl,
        'https://flags.restcountries.com/v5/w320/ca.svg',
      );
      expect(country.latitude, 45.4247);
      expect(country.longitude, -75.695);
      expect(country.languages, ['English', 'French']);
      expect(country.currencies, ['Canadian dollar (CAD)']);
      expect(country.phoneCode, '+1');
      expect(country.unMember, isTrue);
    });

    test('continues to read the earlier response field names', () {
      final country = CountryModel.fromJson({
        'names': {
          'common': 'Example',
          'official': 'Example Republic',
        },
        'cca2': 'EX',
        'cca3': 'EXM',
        'capital': ['Example City'],
        'latlng': [10, 20],
        'flags': {'png': 'https://example.com/flag.png'},
        'languages': ['Examplean'],
        'currencies': [
          {'name': 'Example dollar', 'code': 'EXD'},
        ],
      });

      expect(country.name, 'Example');
      expect(country.code, 'EX');
      expect(country.code3, 'EXM');
      expect(country.capital, 'Example City');
      expect(country.latitude, 10);
      expect(country.longitude, 20);
      expect(country.flagUrl, 'https://example.com/flag.png');
      expect(country.languages, ['Examplean']);
      expect(country.currencies, ['Example dollar (EXD)']);
    });
  });
}
