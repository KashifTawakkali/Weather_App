import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather/weather.dart';

import '../../../core/constants/api_constants.dart';
import 'weather_event.dart';
import 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(const WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(const WeatherLoading());

    try {
      print('========== WEATHER REQUEST ==========');
      print('LATITUDE: ${event.latitude}');
      print('LONGITUDE: ${event.longitude}');
      print('=====================================');

      final apiKey = ApiConstants.openWeatherApiKey;

      if (apiKey.isEmpty) {
        emit(
          const WeatherFailure(
            'Weather API key is not configured.',
          ),
        );
        return;
      }

      final weatherFactory = WeatherFactory(
        apiKey,
        language: Language.ENGLISH,
      );

      final weather = await weatherFactory.currentWeatherByLocation(
        event.latitude,
        event.longitude,
      );

      print('========== WEATHER RESPONSE ==========');
      print('CITY: ${weather.areaName}');
      print('CONDITION: ${weather.weatherMain}');
      print('TEMP: ${weather.temperature?.celsius}');
      print('======================================');

      emit(
        WeatherSuccess(weather),
      );
    } catch (e) {
      print('========== WEATHER ERROR ==========');
      print(e);
      print('===================================');

      emit(
        const WeatherFailure(
          'Unable to load weather. Please try again.',
        ),
      );
    }
  }
}
