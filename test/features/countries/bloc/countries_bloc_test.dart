import 'package:flutter_test/flutter_test.dart';

import 'package:country_weather_explorer/features/countries/bloc/countries_bloc.dart';
import 'package:country_weather_explorer/features/countries/bloc/countries_event.dart';
import 'package:country_weather_explorer/features/countries/bloc/countries_state.dart';
import 'package:country_weather_explorer/features/countries/data/countries_repository.dart';
import 'package:country_weather_explorer/features/countries/data/models/country_model.dart';

void main() {
  group('CountriesBloc search', () {
    late CountriesBloc bloc;
    late _FakeCountriesRepository repository;

    setUp(() {
      repository = _FakeCountriesRepository([
        _country('Canada', 'CA', 'Ottawa'),
        _country('India', 'IN', 'New Delhi'),
      ]);
      bloc = CountriesBloc(
        countriesRepository: repository,
      );
    });

    tearDown(() async {
      await bloc.close();
    });

    test('matches a country name, handles no results, and clears the query',
        () async {
      final initialLoad = _nextLoadedState(bloc);
      bloc.add(const CountriesStarted());
      await initialLoad;

      final matchingResults = _nextLoadedState(bloc);
      bloc.add(const CountriesSearchChanged('  can  '));
      final matched = await matchingResults;
      expect(matched.countries.map((country) => country.name), ['Canada']);

      final noResults = _nextLoadedState(bloc);
      bloc.add(const CountriesSearchChanged('Atlantis'));
      expect((await noResults).countries, isEmpty);

      final clearedResults = _nextLoadedState(bloc);
      bloc.add(const CountriesSearchChanged('   '));
      expect(
        (await clearedResults).countries.map((country) => country.name),
        ['Canada', 'India'],
      );
    });

    test('reloading fetches countries again and clears active search',
        () async {
      final initialLoad = _nextLoadedState(bloc);
      bloc.add(const CountriesStarted());
      await initialLoad;

      final matchingResults = _nextLoadedState(bloc);
      bloc.add(const CountriesSearchChanged('Canada'));
      await matchingResults;

      final refreshedResults = _nextLoadedState(bloc);
      bloc.add(const CountriesStarted());
      final refreshed = await refreshedResults;

      expect(repository.loadCount, 2);
      expect(
        refreshed.countries.map((country) => country.name),
        ['Canada', 'India'],
      );
      expect(refreshed.searchQuery, isEmpty);
    });
  });
}

Future<CountriesLoaded> _nextLoadedState(CountriesBloc bloc) {
  return bloc.stream
      .where((state) => state is CountriesLoaded)
      .cast<CountriesLoaded>()
      .first;
}

CountryModel _country(
  String name,
  String code,
  String capital,
) {
  return CountryModel.fromJson({
    'names': {'common': name, 'official': name},
    'codes': {'alpha_2': code},
    'capitals': [
      {'name': capital},
    ],
  });
}

class _FakeCountriesRepository extends CountriesRepository {
  _FakeCountriesRepository(this.countries);

  final List<CountryModel> countries;
  var loadCount = 0;

  @override
  Future<List<CountryModel>> getCountries() async {
    loadCount++;
    return countries;
  }
}
