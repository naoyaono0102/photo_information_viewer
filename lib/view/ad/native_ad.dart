import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../models/managers/ad_manager.dart';

class NativeAdWidget extends StatefulWidget {
  const NativeAdWidget({Key? key}) : super(key: key);

  @override
  State<NativeAdWidget> createState() => _NativeAdState();
}

class _NativeAdState extends State<NativeAdWidget> {

  NativeAd? _ad;
  final AdRequest request = AdRequest();
  bool isAdLoaded = false;

  @override
  void initState() {
    super.initState();

    // NativeAd instance生成
    _ad = NativeAd(
      adUnitId: AdManager.nativeAdUnitId,
      request: request,
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.medium,
      ),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            print('ネイティブ広告_onAdLoaded');
            // _ad = ad as NativeAd;
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
    )..load();

  }

  @override
  void dispose() {
    //Dispose a NativeAd object
    _ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    bool isTablet = (screenSize.width > 700 && screenSize.height > 700);

    if (_ad != null && isAdLoaded) {
      print('ネイティブ広告読み込み完了');
      return ConstrainedBox(
        constraints:  BoxConstraints(
          minWidth: 320, // minimum recommended width
          minHeight: 320, // minimum recommended height
          maxWidth: screenSize.width,
          maxHeight: isTablet ? 720 : 400,
        ),
        child: AdWidget(ad: _ad!),
      );
    }
    else {
      print('ネイティブ広告読み込み未完了');
      return Container(width: 0, height: 0);
    }
  }
}
