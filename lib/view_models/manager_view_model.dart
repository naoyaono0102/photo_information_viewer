import 'package:flutter/foundation.dart';
import 'package:tuple/tuple.dart';
import '../models/managers/ad_manager.dart';
import '../models/managers/in_app_purchase_manager.dart';
import '../utils/constants.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ManagerViewModel extends ChangeNotifier {

  ManagerViewModel({
    required this.inAppPurchaseManager,
    required this.adManager,
  }){
    // 広告初期化
    if(!kIsWeb){
      adManager
        ..initAdmob()
        ..initInterstitialAd()
        ..initNativeAd();
    }
  }

  final InAppPurchaseManager inAppPurchaseManager;
  final AdManager adManager;
  bool canVibrate = false;

  bool get isDeleteAd => inAppPurchaseManager.isDeleteAd;
  bool get isSubscribed => inAppPurchaseManager.isSubscribed;

  bool isInAppPurchaseProcessing = false;

  ////////////////////////////
  // 初期化
  ////////////////////////////
  Future<bool> initInAppPurchase() async {
    await inAppPurchaseManager.init();
    await getPurchaserInfo();
    notifyListeners();
    return true;
  }

  ////////////////////////////
  // 課金情報取得処理
  ////////////////////////////
  Future<void> getPurchaserInfo() async {
    await inAppPurchaseManager.getPurchaserInfo();
  }

  ////////////////////////////
  // 購入処理
  ////////////////////////////
  Future<void> makePurchase(PurchaseMode purchaseMode) async{
    isInAppPurchaseProcessing = true;
    notifyListeners();

    await inAppPurchaseManager.makePurchase(purchaseMode);

    isInAppPurchaseProcessing = false;
    notifyListeners();
  }

  ////////////////////////////
  // 復元
  ////////////////////////////
  Future<void> recoverPurchase() async {
    isInAppPurchaseProcessing = true;
    notifyListeners();

    await inAppPurchaseManager.recoverPurchase();

    isInAppPurchaseProcessing = false;
    notifyListeners();
  }

  /////////////////////////////
  // インタースティシャル広告表示
  /////////////////////////////
  void loadInterstitialAd() {
    adManager.loadInterstitialAd();
  }

  /////////////////////////////
  // ネイティブ広告表示
  /////////////////////////////
  void loadNativeAd() {
    adManager.loadNativeAd();
  }

  //TODO Appleリジェクト対応（StoreProductはModel層（RevenueCat）の情報なので、VMでは使えないので
  Tuple3<String, String, String>? subscriptionInfo;
  void getSubscriptionInfo() {
    subscriptionInfo = inAppPurchaseManager.getSubscriptionInfo();
    notifyListeners();
  }



  // @override
  // void dispose(){
  //   super.dispose();
  //   adManager.dispose();
  // }
}