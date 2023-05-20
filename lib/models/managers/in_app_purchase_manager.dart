import 'dart:io';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:tuple/tuple.dart';

import '../../utils/constants.dart';

const API_KEY_ANDROID = "";
const API_KEY_IOS = "";

class InAppPurchaseManager {

  late Offerings offerings;
  bool isDeleteAd = false;
  bool isSubscribed = false;

  ////////////////////////
  // 初期化
  ////////////////////////
  Future<void> init() async {
    if (Platform.isAndroid) {
      await Purchases.configure(PurchasesConfiguration(API_KEY_ANDROID));
    } else if (Platform.isIOS) {
      await Purchases.configure(PurchasesConfiguration(API_KEY_IOS));
    }

    offerings = await Purchases.getOfferings();
  }

  ////////////////////////
  // 課金情報取得処理
  ////////////////////////
  Future<void> getPurchaserInfo() async {
    try{
      final purchaseInfo = await Purchases.getCustomerInfo();
      updatePurchases(purchaseInfo);

    } on PlatformException catch(e){
      print(PurchasesErrorHelper.getErrorCode(e).toString());
    }
  }

  ////////////////////////
  // 課金ステータスの更新
  ////////////////////////
  void updatePurchases(CustomerInfo purchaseInfo) {
    final entitlements = purchaseInfo.entitlements.all;

    // キーがない場合
    if(entitlements.isEmpty) {
      isDeleteAd = false;
      isSubscribed = false;
      return;
    }


    // キーが「delete_ad」の場合
    if(!entitlements.containsKey('delete_ad')) {
      // delete_adキーが存在しない場合
      isDeleteAd = false;
    } else if(entitlements['delete_ad']!.isActive){
      //  Entitlementのキーがあって、Activeな場合 = 広告非表示プラン購入済み
      isDeleteAd = true;
    } else {
      isDeleteAd = false;
    }

    // キーが「プレミアプラン」の場合
    if (!entitlements.containsKey("monthly_premium_plan")) {
      isSubscribed = false;
      // [Null-safety]上記のif文で存在チェックしているので強制アクセス可
    } else if (entitlements["monthly_premium_plan"]!.isActive) {
      isSubscribed = true;
    } else {
      isSubscribed = false;
    }
  }

  ////////////////////////
  // プラン購入処理
  ////////////////////////
  Future<void> makePurchase(PurchaseMode purchaseMode) async{
    Package? package;

    switch(purchaseMode){
      case PurchaseMode.DONATE:
      // print('開発者支援プラン');
        package = offerings.all["donation"]?.getPackage("donation");
        break;
      case PurchaseMode.DELETE_AD:
      // print('広告削除プラン');
        package = offerings.all['delete_ad']?.lifetime;
        break;
      case PurchaseMode.SUBSCRIPTION:
        package = offerings.all["monthly_premium_plan"]?.monthly;
        break;
    }

    if(package == null) return;

    try{
      final purchaseInfo = await Purchases.purchasePackage(package);
      if(purchaseMode != PurchaseMode.DONATE){
        updatePurchases(purchaseInfo);
      }
    } on PlatformException catch(e){
      final errorCode = PurchasesErrorHelper.getErrorCode(e);

      if(errorCode == PurchasesErrorCode.purchaseCancelledError){
        print("User Canceled");
      }
      else if(errorCode == PurchasesErrorCode.purchaseNotAllowedError){
        print("Purchases not allowed on this device.");
      }
      else if(errorCode == PurchasesErrorCode.purchaseInvalidError){
        print("Purchases invalid. check payment source");
      }
      else {
        print('error');
      }
    }
  }

  ////////////////////////
  // 復元処理
  ////////////////////////
  Future<void> recoverPurchase() async {
    try {
      // リカバリ
      final purchaseInfo = await Purchases.restorePurchases();
      updatePurchases(purchaseInfo);

    } on PlatformException catch(e) {
      final errorCode = PurchasesErrorHelper.getErrorCode(e);
      print("restoreError: ${errorCode.toString()}");
    }
  }

  //TODO Appleリジェクト対応（StoreProductはModel層（RevenueCat）の情報なので、VMでは使えないので
  Tuple3<String, String, String>? getSubscriptionInfo() {
    final storeProduct =
        offerings.all["monthly_premium_plan"]?.monthly?.storeProduct;
    if (storeProduct == null) return null;
    return Tuple3(
        storeProduct.title, storeProduct.description, storeProduct.priceString);
  }

}