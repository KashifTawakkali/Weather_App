import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import 'models/country_model.dart';

class CountriesRepository {
  static const String _countriesUrl =
      'https://api.restcountries.com/countries/v5';

  Future<List<CountryModel>> getCountries() async {
    final apiKey = ApiConstants.restCountriesApiKey;

    if (apiKey.isEmpty) {
      throw Exception(
        'REST Countries API key is not configured.',
      );
    }

    if (apiKey == 'rc_live_demo') {
      throw Exception(
        'REST Countries demo API key is being used.',
      );
    }

    final countries = <CountryModel>[];

    const int limit = 100;
    var offset = 0;
    var hasMore = true;
    var loggedSample = false;

    try {
      while (hasMore) {
        final uri = Uri.parse(
          '$_countriesUrl?limit=$limit&offset=$offset',
        );

        final response = await http.get(
          uri,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Accept': 'application/json',
          },
        ).timeout(
          const Duration(seconds: 20),
        );

        if (response.statusCode != 200) {
          throw Exception(
            'Countries API failed: ${response.statusCode}',
          );
        }

        final decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid countries response.',
          );
        }

        final data = decoded['data'];

        if (data is! Map<String, dynamic>) {
          throw const FormatException(
            'Invalid countries data.',
          );
        }

        final objects = data['objects'];

        if (objects is! List) {
          throw const FormatException(
            'Countries list not found.',
          );
        }

        for (final item in objects) {
          if (item is! Map<String, dynamic>) {
            continue;
          }

          if (!loggedSample) {
            debugPrint('COUNTRIES API - first raw country object:');
            debugPrint(
              const JsonEncoder.withIndent('  ').convert(item),
              wrapWidth: 1200,
            );
            loggedSample = true;
          }

          final country = CountryModel.fromJson(item);
          countries.add(country);

          if (countries.length == 1) {
            debugPrint('COUNTRIES API - parsed country:');
            debugPrint(
              const JsonEncoder.withIndent('  ').convert({
                'name': country.name,
                'officialName': country.officialName,
                'capital': country.capital,
                'code': country.code,
                'code3': country.code3,
                'flag': country.flag,
                'flagUrl': country.flagUrl,
                'latitude': country.latitude,
                'longitude': country.longitude,
                'region': country.region,
                'subregion': country.subregion,
                'population': country.population,
                'area': country.area,
                'languages': country.languages,
                'currencies': country.currencies,
              }),
              wrapWidth: 1200,
            );
          }
        }

        final meta = data['meta'];

        if (meta is Map<String, dynamic>) {
          final more = meta['more'];

          if (more is bool) {
            hasMore = more;
          } else {
            hasMore = objects.length >= limit;
          }
        } else {
          hasMore = objects.length >= limit;
        }

        offset += objects.length;

        if (objects.isEmpty) {
          hasMore = false;
        }
      }

      if (countries.isEmpty) {
        throw const FormatException(
          'No countries found.',
        );
      }

      countries.sort(
        (a, b) => a.name.toLowerCase().compareTo(
              b.name.toLowerCase(),
            ),
      );

      return countries;
    } on TimeoutException {
      throw Exception(
        'Countries API request timed out.',
      );
    } on FormatException {
      rethrow;
    } catch (_) {
      throw Exception(
        'Unable to load countries.',
      );
    }
  }
}
