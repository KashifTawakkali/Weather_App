import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/countries_repository.dart';
import '../data/models/country_model.dart';
import 'countries_event.dart';
import 'countries_state.dart';

class CountriesBloc extends Bloc<CountriesEvent, CountriesState> {
  CountriesBloc({
    required CountriesRepository countriesRepository,
  })  : _countriesRepository = countriesRepository,
        super(const CountriesInitial()) {
    on<CountriesStarted>(_onCountriesStarted);
    on<CountriesSearchChanged>(_onCountriesSearchChanged);
  }

  final CountriesRepository _countriesRepository;

  List<CountryModel> _allCountries = [];

  Future<void> _onCountriesStarted(
    CountriesStarted event,
    Emitter<CountriesState> emit,
  ) async {
    emit(const CountriesLoading());

    try {
      _allCountries = await _countriesRepository.getCountries();

      emit(
        CountriesLoaded(
          countries: _allCountries,
        ),
      );
    } catch (_) {
      emit(
        const CountriesFailure(
          'Unable to load countries. Please try again.',
        ),
      );
    }
  }

  void _onCountriesSearchChanged(
    CountriesSearchChanged event,
    Emitter<CountriesState> emit,
  ) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(
        CountriesLoaded(
          countries: _allCountries,
        ),
      );
      return;
    }

    final filteredCountries = _allCountries.where((country) {
      return country.name.toLowerCase().contains(query) ||
          country.code.toLowerCase().contains(query) ||
          country.capital.toLowerCase().contains(query);
    }).toList();

    emit(
      CountriesLoaded(
        countries: filteredCountries,
        searchQuery: event.query,
      ),
    );
  }
}
