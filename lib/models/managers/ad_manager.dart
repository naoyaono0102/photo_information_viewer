import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdManager {

  BannerAd? bannerAd;
  InterstitialAd? interstitialAd;
  NativeAd? nativeAd;

  AdRequest request = AdRequest();
  bool isBannerAdCreated = false;
  bool isNativeAdLoaded = false;

  int maxFailedLoadAttempts = 3;  // 広告ロード回数の上限
  int _numInterstitialLoadAttempts = 0; // インタースティシャル広告をロードした回数

  //////////////////////
  // Admob初期化
  //////////////////////
  Future<void> initAdmob(){
    return MobileAds.instance.initialize();
  }

  void dispose() {
    bannerAd?.dispose();
    interstitialAd?.dispose();
    nativeAd?.dispose();
  }

  ////////////////////////////////
  // ネイティブ広告初期化（広告読み込み）
  ////////////////////////////////
  Future<void> initNativeAd() async {
    nativeAd = NativeAd(
      adUnitId: AdManager.nativeAdUnitId,
      // factoryId: 'nativeAdFactory',
      request: AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
            print('ネイティブ広告_onAdLoaded');
            isNativeAdLoaded = true;
        },
        onAdFailedToLoad: (ad, error) {
          // Releases an ad resource when it fails to load
          ad.dispose();
          print('Ad load failed (code=${error.code} message=${error.message})');
        },
      ),
        nativeTemplateStyle: NativeTemplateStyle(
            templateType: TemplateType.medium,
            cornerRadius: 10.0,
        )
    ) ..load();
  }


  // アプリID
  static String get appId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544~3347511713"; // テスト用
      return "ca-app-pub-4166043434922569~9390307574"; // 本番用
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544~1458002511"; // テスト用
      return "ca-app-pub-4166043434922569~2797017053"; // 本番用
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // バナー広告サイズ
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/6300978111"; // テスト用
      return "ca-app-pub-4166043434922569/2053429957"; // 本番用
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544/2934735716"; // テスト用
      return "ca-app-pub-4166043434922569/5303722901"; // 本番用
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // リワード広告
  static String get rewardAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/5224354917"; // テスト用
      return "ca-app-pub-4166043434922569/6378003569"; // 本番用
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544/1712485313"; // テスト用
      return "ca-app-pub-4166043434922569/6427789235"; // 本番用
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // ネイティブ広告
  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-3940256099942544/2247696110"; // テスト用
      return "ca-app-pub-4166043434922569/4104878222"; // 本番用
    } else if (Platform.isIOS) {
      // return "ca-app-pub-3940256099942544/3986624511"; // テスト用
      return "ca-app-pub-4166043434922569/7616747820"; // 本番用
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  // インタースティシャル広告
  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712"; // テスト
      // return "ca-app-pub-4166043434922569/7079691274"; // 本番用
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910"; // テスト
      // return "ca-app-pub-4166043434922569/5091822189"; // 本番用
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }


  /////////////////////////////
  // インタースティシャル広告生成
  /////////////////////////////
  void initInterstitialAd(){
    InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              initInterstitialAd();
            }
          },
        ));
  }

  void loadInterstitialAd(){
    _showInterstitialAd();
  }

  // インタースティシャル広告表示
  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitial before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        initInterstitialAd();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        initInterstitialAd();
      },
    );
    interstitialAd!.show();
    interstitialAd = null;
  }

  ////////////////////////////
  // ネイティブ広告読み込み
  ////////////////////////////
  void loadNativeAd() {
    nativeAd?.load();
  }

}