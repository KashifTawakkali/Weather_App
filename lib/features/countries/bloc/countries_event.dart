import 'package:equatable/equatable.dart';

sealed class CountriesEvent extends Equatable {
  const CountriesEvent();

  @override
  List<Object?> get props => [];
}

final class CountriesStarted extends CountriesEvent {
  const CountriesStarted();
}

final class CountriesSearchChanged extends CountriesEvent {
  const CountriesSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}
