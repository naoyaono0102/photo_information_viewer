import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../models/managers/ad_manager.dart';
import '../../utils/constants.dart';
import '../../view_models/setting_view_model.dart';

// 広告エリア
class AdmobWidget extends StatefulWidget {
  AdmobWidget({required this.bannerAdType});
  final BannerAdType bannerAdType;


  @override
  _AdmobWidgetState createState() => _AdmobWidgetState();
}


class _AdmobWidgetState extends State<AdmobWidget> {

  /////////////////////////
  // admob関連の変数
  /////////////////////////
  static final AdRequest request = AdRequest();
  BannerAd? _ad;
  bool _isAdLoaded = false;

  ///////////////////////////
  // アダプティブバナー生成
  ///////////////////////////
  Future<void> _createAnchoredBanner(BuildContext context) async {
    if (widget.bannerAdType == BannerAdType.SMART) {
      // スマートバナー
      final SmartBannerAdSize? bannerSize =
      AdSize.getSmartBanner(Orientation.landscape);

      if (bannerSize == null) {
        print('Unable to get height of anchored banner.');
        return;
      }

      final BannerAd banner = BannerAd(
        adUnitId: AdManager.bannerAdUnitId, // 広告ID
        size: bannerSize, // サイズ
        request: request,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              _ad = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, error) {
            _ad!.dispose();
            print(
                'Ad load failed (code=${error.code} message=${error.message})');
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed'),
        ),
      );

      return banner.load();
    } else {
      // アダプティブバナー
      final AnchoredAdaptiveBannerAdSize? bannerSize =
      await AdSize.getAnchoredAdaptiveBannerAdSize(Orientation.landscape,
          MediaQuery.of(context).size.width.truncate());

      if (bannerSize == null) {
        print('Unable to get height of anchored banner.');
        return;
      }

      final BannerAd banner = BannerAd(
        adUnitId: AdManager.bannerAdUnitId, // 広告ID
        size: bannerSize, // サイズ
        request: request,
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            setState(() {
              _ad = ad as BannerAd;
            });
          },
          onAdFailedToLoad: (ad, error) {
            _ad!.dispose();
            print(
                'Ad load failed (code=${error.code} message=${error.message})');
          },
          onAdOpened: (Ad ad) => print('$BannerAd onAdOpened'),
          onAdClosed: (Ad ad) => print('$BannerAd onAdClosed'),
        ),
      );

      return banner.load();
    }
  }

  @override
  void dispose() async {
    super.dispose();
    _ad?.dispose();
  }

  @override
  Widget build(BuildContext context) {

    var screenSize = MediaQuery.of(context).size;

    // 広告読み込みがまだの場合、かつ広告非表示設定がONじゃない場合に読み込む
    if (!_isAdLoaded && !Provider.of<SettingViewModel>(context).settings.doesHideAds) {
      print('load banner ad');
      _isAdLoaded = true;
      _createAnchoredBanner(context);
    }

    return (kIsWeb)
        ? Container(width: 0, height: 0,) // WEBの場合はブランク
        : (_ad != null)  // 広告があれば表示なければブランク
        ? Container(
      alignment: Alignment.center,
      color: Colors.black,
      width: (widget.bannerAdType == BannerAdType.ADAPTIVE)
          ? _ad!.size.width.toDouble()
          : screenSize.width,
      height: (widget.bannerAdType == BannerAdType.ADAPTIVE)
          ? _ad!.size.height.toDouble()
          : 32,
      // width: screenSize.width, //ad.size.width.toDouble(),
      // height: (screenSize.width > 1000) ? 50 : 32, //_ad.size.height.toDouble(),
      child: AdWidget(ad: _ad!),
    ) : Container(width: 0, height: 0,);
  }
}