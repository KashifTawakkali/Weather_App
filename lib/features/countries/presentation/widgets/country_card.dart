import 'package:flutter/material.dart';

import '../../data/models/country_model.dart';

class CountryCard extends StatelessWidget {
  const CountryCard({
    super.key,
    required this.country,
    required this.onTap,
  });

  final CountryModel country;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // =========================================================
                // FLAG
                // =========================================================
                _FlagWidget(
                  flagUrl: country.flagUrl,
                  flagEmoji: country.flag,
                ),

                const SizedBox(width: 16),

                // =========================================================
                // COUNTRY INFORMATION
                // =========================================================
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Country name
                      Text(
                        country.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 5),

                      // Official name
                      if (country.officialName.isNotEmpty &&
                          country.officialName != country.name)
                        Text(
                          country.officialName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: 0.55,
                            ),
                            fontSize: 12,
                          ),
                        ),

                      const SizedBox(height: 8),

                      // Capital
                      Row(
                        children: [
                          Icon(
                            Icons.location_city_outlined,
                            size: 15,
                            color: Colors.white.withValues(
                              alpha: 0.60,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              country.capital,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.70,
                                ),
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // Region
                      Row(
                        children: [
                          Icon(
                            Icons.public_outlined,
                            size: 15,
                            color: Colors.white.withValues(
                              alpha: 0.60,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: Text(
                              _regionText(),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.60,
                                ),
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 10),

                // =========================================================
                // CODE + ARROW
                // =========================================================
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (country.code.isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.08,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          country.code,
                          style: TextStyle(
                            color: Colors.white.withValues(
                              alpha: 0.75,
                            ),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 15,
                      color: Colors.white.withValues(
                        alpha: 0.50,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _regionText() {
    if (country.subregion != 'N/A' && country.subregion.isNotEmpty) {
      return '${country.region} • ${country.subregion}';
    }

    return country.region;
  }
}

// ===========================================================================
// FLAG WIDGET
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
      width: 68,
      height: 68,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.10),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildFlag(),
    );
  }

  Widget _buildFlag() {
    // =========================================================
    // 1. Try real flag URL
    // =========================================================
    if (flagUrl.isNotEmpty) {
      return Image.network(
        flagUrl,
        width: 68,
        height: 68,
        fit: BoxFit.cover,
        loadingBuilder: (
          context,
          child,
          loadingProgress,
        ) {
          if (loadingProgress == null) {
            return child;
          }

          return _emojiFallback();
        },
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return _emojiFallback();
        },
      );
    }

    // =========================================================
    // 2. Fallback to emoji
    // =========================================================
    return _emojiFallback();
  }

  Widget _emojiFallback() {
    return Center(
      child: Text(
        flagEmoji.isNotEmpty ? flagEmoji : '🌐',
        style: const TextStyle(
          fontSize: 38,
        ),
      ),
    );
  }
}
