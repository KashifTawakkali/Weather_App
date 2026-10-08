import 'dart:ui';

import 'package:flutter/material.dart';

import '../../data/models/country_model.dart';
import '../../../weather/presentation/screens/weather_screen.dart';

class CountryDetailsScreen extends StatelessWidget {
  const CountryDetailsScreen({
    super.key,
    required this.country,
  });

  final CountryModel country;

  String _value(String value) {
    if (value.trim().isEmpty || value.trim().toLowerCase() == 'null') {
      return 'N/A';
    }

    return value;
  }

  String _listValue(List<String> value) {
    if (value.isEmpty) {
      return 'N/A';
    }

    return value.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final latitude = country.latitude;
    final longitude = country.longitude;

    final hasValidCoordinates = latitude != 0.0 || longitude != 0.0;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ============================================================
          // BACKGROUND GLOW
          // ============================================================

          Positioned(
            top: -120,
            left: -120,
            child: _Glow(
              color: const Color(0xFF673AB7),
              size: 350,
            ),
          ),

          Positioned(
            top: 100,
            right: -130,
            child: _Glow(
              color: const Color(0xFFFFAB40),
              size: 320,
            ),
          ),

          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 100,
              sigmaY: 100,
            ),
            child: Container(
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ),

          // ============================================================
          // CONTENT
          // ============================================================

          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                40,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // HEADER
                  // ======================================================

                  Row(
                    children: [
                      _GlassIconButton(
                        icon: Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Expanded(
                        child: Text(
                          'Country Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 46),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ======================================================
                  // COUNTRY HEADER
                  // ======================================================

                  Center(
                    child: Column(
                      children: [
                        _FlagWidget(
                          flagUrl: country.flagUrl,
                          flagEmoji: country.flag,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          _value(country.name),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 7),
                        if (country.officialName.isNotEmpty &&
                            country.officialName != country.name)
                          Text(
                            country.officialName,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white.withValues(
                                alpha: 0.55,
                              ),
                              fontSize: 13,
                            ),
                          ),
                        const SizedBox(height: 12),
                        _CodeBadge(
                          code: _value(country.code),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ======================================================
                  // BASIC INFORMATION
                  // ======================================================

                  _SectionTitle(
                    title: 'Basic Information',
                    icon: Icons.info_outline_rounded,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.location_city_outlined,
                        title: 'Capital',
                        value: _value(country.capital),
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.public_outlined,
                        title: 'Country Code',
                        value: _value(country.code),
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.language_outlined,
                        title: 'Region',
                        value: _value(country.region),
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.map_outlined,
                        title: 'Subregion',
                        value: _value(country.subregion),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // LOCATION
                  // ======================================================

                  _SectionTitle(
                    title: 'Location',
                    icon: Icons.location_on_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.north_outlined,
                        title: 'Latitude',
                        value: hasValidCoordinates
                            ? latitude.toStringAsFixed(6)
                            : 'N/A',
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.east_outlined,
                        title: 'Longitude',
                        value: hasValidCoordinates
                            ? longitude.toStringAsFixed(6)
                            : 'N/A',
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.public_outlined,
                        title: 'Continent',
                        value: _listValue(
                          country.continents,
                        ),
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.schedule_outlined,
                        title: 'Timezones',
                        value: _listValue(
                          country.timezones,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // DEMOGRAPHICS
                  // ======================================================

                  _SectionTitle(
                    title: 'Demographics',
                    icon: Icons.groups_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.people_outline_rounded,
                        title: 'Population',
                        value: country.population > 0
                            ? country.population.toString()
                            : 'N/A',
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.square_foot_outlined,
                        title: 'Area',
                        value: country.area > 0
                            ? country.area.toStringAsFixed(2)
                            : 'N/A',
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.translate_outlined,
                        title: 'Languages',
                        value: _listValue(
                          country.languages,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // ECONOMY
                  // ======================================================

                  _SectionTitle(
                    title: 'Economy & Currency',
                    icon: Icons.account_balance_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.currency_exchange_outlined,
                        title: 'Currencies',
                        value: _listValue(
                          country.currencies,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // POLITICAL INFORMATION
                  // ======================================================

                  _SectionTitle(
                    title: 'Political Information',
                    icon: Icons.account_balance_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.flag_outlined,
                        title: 'Independent',
                        value: country.independent ? 'Yes' : 'No',
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.public_outlined,
                        title: 'UN Member',
                        value: country.unMember ? 'Yes' : 'No',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // TRANSPORT
                  // ======================================================

                  _SectionTitle(
                    title: 'Transport',
                    icon: Icons.directions_car_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.directions_car_outlined,
                        title: 'Driving Side',
                        value: _value(
                          country.drivingSide,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // COMMUNICATION
                  // ======================================================

                  _SectionTitle(
                    title: 'Communication',
                    icon: Icons.phone_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.phone_outlined,
                        title: 'Phone Code',
                        value: _value(
                          country.phoneCode,
                        ),
                      ),
                      _Divider(),
                      _InfoRow(
                        icon: Icons.language_outlined,
                        title: 'Internet Domain',
                        value: _value(
                          country.tld,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ======================================================
                  // BORDERS
                  // ======================================================

                  _SectionTitle(
                    title: 'Borders',
                    icon: Icons.border_all_outlined,
                  ),

                  const SizedBox(height: 12),

                  _InfoCard(
                    children: [
                      _InfoRow(
                        icon: Icons.map_outlined,
                        title: 'Border Countries',
                        value: _listValue(
                          country.borders,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ======================================================
                  // WEATHER BUTTON
                  // ======================================================

                  SizedBox(
                    width: double.infinity,
                    height: 58,
                    child: ElevatedButton.icon(
                      onPressed: hasValidCoordinates
                          ? () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => WeatherScreen(
                                    latitude: latitude,
                                    longitude: longitude,
                                  ),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(
                        Icons.cloud_outlined,
                      ),
                      label: Text(
                        hasValidCoordinates
                            ? 'View Weather'
                            : 'Weather Unavailable',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        disabledBackgroundColor: Colors.white24,
                        disabledForegroundColor: Colors.white54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
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

// ===========================================================================
// FLAG
// ===========================================================================

class _FlagWidget extends StatelessWidget {
  const _FlagWidget({
    required this.flagUrl,
    required this.flagEmoji,
  });

  final String flagUrl;
  final String flagEmoji;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: flagUrl.trim().isNotEmpty
          ? Image.network(
              flagUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return _EmojiFlag(
                  emoji: flagEmoji,
                );
              },
            )
          : _EmojiFlag(
              emoji: flagEmoji,
            ),
    );
  }
}

class _EmojiFlag extends StatelessWidget {
  const _EmojiFlag({
    required this.emoji,
  });

  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        emoji.isNotEmpty ? emoji : '🌐',
        style: const TextStyle(
          fontSize: 55,
        ),
      ),
    );
  }
}

// ===========================================================================
// GLOW
// ===========================================================================

class _Glow extends StatelessWidget {
  const _Glow({
    required this.color,
    required this.size,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}

// ===========================================================================
// HEADER BUTTON
// ===========================================================================

class _GlassIconButton extends StatelessWidget {
  const _GlassIconButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: Colors.white,
            size: 19,
          ),
        ),
      ),
    );
  }
}

// ===========================================================================
// CODE BADGE
// ===========================================================================

class _CodeBadge extends StatelessWidget {
  const _CodeBadge({
    required this.code,
  });

  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 13,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        code,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.8),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

// ===========================================================================
// SECTION TITLE
// ===========================================================================

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 19,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// ===========================================================================
// INFORMATION CARD
// ===========================================================================

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.children,
  });

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.11),
        ),
      ),
      child: Column(
        children: children,
      ),
    );
  }
}

// ===========================================================================
// INFORMATION ROW
// ===========================================================================

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white70,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.45),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ===========================================================================
// DIVIDER
// ===========================================================================

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 0.5,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}
