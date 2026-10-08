import 'package:equatable/equatable.dart';

import '../data/models/country_model.dart';

sealed class CountriesState extends Equatable {
  const CountriesState();

  @override
  List<Object?> get props => [];
}

final class CountriesInitial extends CountriesState {
  const CountriesInitial();
}

final class CountriesLoading extends CountriesState {
  const CountriesLoading();
}

final class CountriesLoaded extends CountriesState {
  const CountriesLoaded({
    required this.countries,
    this.searchQuery = '',
  });

  final List<CountryModel> countries;
  final String searchQuery;

  @override
  List<Object?> get props => [
        countries,
        searchQuery,
      ];
}

final class CountriesFailure extends CountriesState {
  const CountriesFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
