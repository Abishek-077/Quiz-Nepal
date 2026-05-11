import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../ads/ad_config.dart';
import '../ads/ad_placements.dart';
import '../ads/ad_service.dart';

/// Banner widget for the approved home and category ad placements.
class AdMobBanner extends StatefulWidget {
  const AdMobBanner({
    required this.placement,
    super.key,
  });

  final BannerAdPlacement placement;

  const AdMobBanner.home({super.key}) : placement = BannerAdPlacement.home;

  const AdMobBanner.category({super.key})
      : placement = BannerAdPlacement.category;

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBanner();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadBanner() async {
    if (!AdConfig.isEnabled) {
      return;
    }

    await AdService.instance.initialize();
    if (!mounted) {
      return;
    }

    final banner = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
            _isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          if (!mounted) {
            return;
          }
          setState(() {
            _isLoaded = false;
          });
          debugPrint('Banner failed to load for ${widget.placement}: $error');
        },
      ),
    );

    banner.load();
  }

  @override
  Widget build(BuildContext context) {
    if (!AdConfig.isEnabled || !_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    return SafeArea(
      top: false,
      child: SizedBox(
        width: _bannerAd!.size.width.toDouble(),
        height: _bannerAd!.size.height.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
