import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/countries_bloc.dart';
import '../../bloc/countries_event.dart';
import '../../bloc/countries_state.dart';
import '../../data/countries_repository.dart';
import '../widgets/country_card.dart';
import '../screens/country_details_screen.dart';

class CountriesScreen extends StatelessWidget {
  const CountriesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CountriesBloc(
        countriesRepository: CountriesRepository(),
      )..add(const CountriesStarted()),
      child: const _CountriesView(),
    );
  }
}

class _CountriesView extends StatefulWidget {
  const _CountriesView();

  @override
  State<_CountriesView> createState() => _CountriesViewState();
}

class _CountriesViewState extends State<_CountriesView> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Purple background glow
          Align(
            alignment: const Alignment(-1.3, -0.8),
            child: Container(
              height: 350,
              width: 350,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF673AB7),
              ),
            ),
          ),

          // Orange background glow
          Align(
            alignment: const Alignment(1.3, -0.25),
            child: Container(
              height: 300,
              width: 300,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFFAB40),
              ),
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 100,
              sigmaY: 100,
            ),
            child: Container(
              color: Colors.transparent,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                22,
                18,
                22,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Explore',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(height: 4),

                  const Text(
                    'Countries',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Choose a country to explore its weather.',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Search
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<CountriesBloc>().add(
                            CountriesSearchChanged(value),
                          );
                    },
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search country...',
                      hintStyle: const TextStyle(
                        color: Colors.white54,
                      ),
                      prefixIcon: const Icon(
                        Icons.search_rounded,
                        color: Colors.white70,
                      ),
                      suffixIcon: ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          if (value.text.isEmpty) {
                            return const SizedBox.shrink();
                          }

                          return IconButton(
                            onPressed: () {
                              _searchController.clear();

                              context.read<CountriesBloc>().add(
                                    const CountriesSearchChanged(''),
                                  );
                            },
                            icon: const Icon(
                              Icons.close_rounded,
                              color: Colors.white70,
                            ),
                          );
                        },
                      ),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.12),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: const BorderSide(
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Expanded(
                    child: BlocBuilder<CountriesBloc, CountriesState>(
                      builder: (context, state) {
                        if (state is CountriesLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          );
                        }

                        if (state is CountriesFailure) {
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        if (state is CountriesLoaded) {
                          if (state.countries.isEmpty) {
                            return const Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.search_off_rounded,
                                    color: Colors.white54,
                                    size: 50,
                                  ),
                                  SizedBox(height: 12),
                                  Text(
                                    'No countries found',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          return ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(
                              bottom: 24,
                            ),
                            itemCount: state.countries.length,
                            separatorBuilder: (_, __) {
                              return const SizedBox(height: 12);
                            },
                            itemBuilder: (context, index) {
                              final country = state.countries[index];

                              return CountryCard(
                                country: country,
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => CountryDetailsScreen(
                                        country: country,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        }

                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
