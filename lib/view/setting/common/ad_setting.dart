import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:photo_information_viewer/generated/l10n.dart';
import 'package:photo_information_viewer/models/managers/ad_manager.dart';
import 'package:photo_information_viewer/view_models/setting_view_model.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../utils/style.dart';


class AdSetting extends StatefulWidget {

  @override
  State<AdSetting> createState() => _AdSettingState();
}

class _AdSettingState extends State<AdSetting> {

  // リワード広告
  RewardedAd? _rewardedAd;
  static final AdRequest request = AdRequest();
  int _numRewardedLoadAttempts = 0;
  int maxFailedLoadAttempts = 5;


  @override
  void initState() {
    super.initState();

    // リワード広告
    if(!kIsWeb){
      _createRewardedAd();
    }
  }

  //////////////////////
  // リワード広告生成
  //////////////////////
  void _createRewardedAd() {
    RewardedAd.load(
        adUnitId: AdManager.rewardAdUnitId, // 広告ID
        request: request,
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: (RewardedAd ad) {
            print('$ad loaded.');
            _rewardedAd = ad;
            _numRewardedLoadAttempts = 0;
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('RewardedAd failed to load: $error');
            _rewardedAd = null;
            _numRewardedLoadAttempts += 1;
            if (_numRewardedLoadAttempts <= maxFailedLoadAttempts) {
              _createRewardedAd();
            }
          },
        ));
  }

  //////////////////////
  // リワード広告表示
  //////////////////////
  void _showRewardedAd() {

    final settingViewModel = context.read<SettingViewModel>();

    // 広告がない場合はreturn
    if (_rewardedAd == null) {
      print('Warning: attempt to show rewarded before loaded.');
      return;
    }

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) => print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        // 広告破棄して再作成
        ad.dispose();
        _createRewardedAd();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        _createRewardedAd();
      },
    );

    _rewardedAd!.setImmersiveMode(true);
    _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('広告を最後まで見終わった');
          print('$ad with reward $RewardItem(${reward.amount}, ${reward.type}');
          // 広告を最後まで見終わったら実行
          // ２４時間バナー広告非表示設定
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return WillPopScope(
                child: AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(S.of(context).hideAdsMessage),
                    ],
                  ),
                ),
                onWillPop: () async {// ポップアップを閉じるときに実行
                  // 1. DBに有効期限を登録 現在の日付+1
                  // 1-1. 翌日の日付を取得
                  DateTime expiredDay = DateTime.now().add(Duration(days: reward.amount.toInt()));

                  // 1-2.ミリ秒を取り除く（String型になる）
                  String formattedExpiredDay = DateFormat('yyyy-MM-dd hh:mm:ss').format(expiredDay);

                  // 1-3. DBに保存
                  settingViewModel.saveExpiryDay('expiryDay', formattedExpiredDay);

                  // 2. 非表示フラグをONに
                  settingViewModel.setHideAdsSetting('doesHideAds', true);

                  // print('有効期限を設定しました');
                  // print('広告非表示フラグをONにしました');
                  return true;
                },
              );
            },
          );
        });

    _rewardedAd = null;
  }


  @override
  void dispose() {
    if(!kIsWeb){
      _rewardedAd?.dispose();
    }
    super.dispose();
  }

  String fetchExpiryDay(String language){

    final settingViewModel = context.read<SettingViewModel>();

    if(language == 'ja'){
      return settingViewModel.settings.expiryDay!;
    } else {
      // 海外仕様
      DateTime expiryDay = DateTime.parse(settingViewModel.settings.expiryDay!).toLocal();
      return (DateFormat('MMM dd, yyyy HH:mm')).format(expiryDay);
      // yyyy-MM-dd hh:mm
    }
  }

  @override
  Widget build(BuildContext context) {
    String languageSetting = Localizations.localeOf(context).languageCode;
    final Size screenSize = MediaQuery.of(context).size;

    return  Consumer<SettingViewModel>(
        builder: (context, settingViewModel, child) {
          return Consumer<SettingViewModel>(
              builder: (context, settingViewModel, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /////////////////////
                    // タイトル
                    /////////////////////
                    Container(
                      padding:EdgeInsets.only(left: 24.0, bottom: 12),
                      child: Text(
                          S.of(context).ads,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 20 : 16,
                            fontWeight: FontWeight.bold,
                            color: kBase1TextColor,
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left:16, right: 16, bottom: 16),
                      decoration: BoxDecoration(
                          color: kListTileDarkColor,
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          /////////////////////
                          // 広告非表示
                          /////////////////////
                          ListTile(
                            title: AutoSizeText(
                              S.of(context).hideAds,
                              style: TextStyle(
                                  fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                                  color: kBase1TextColor
                              ),
                            ),
                            subtitle: (settingViewModel.settings.expiryDay != null)
                                ? Text(
                                S.of(context).expirationDate + '：' + fetchExpiryDay(languageSetting),
                            )
                                : null,
                            leading: Icon(Icons.do_not_disturb),
                            contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                            onTap: () => _showHideAdsConfirm(context),
                          ),
                          // Container(
                          //     margin: EdgeInsets.only(left: 12, right: 12),
                          //     child: Divider(height: 0, color: Colors.grey)
                          // ),
                          // /////////////////////
                          // // 広告削除
                          // /////////////////////
                          // ListTile(
                          //   title: AutoSizeText(
                          //     S.of(context).removeAds,
                          //     style: TextStyle(
                          //         fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                          //         color: kBase2TextColor
                          //     ),
                          //   ),
                          //   leading: Icon(Icons.do_not_disturb),
                          //   trailing: Icon(Icons.chevron_right),
                          //   contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                          //   onTap: () => _openSubscriptionConfirmationScreen(context),
                          // ),
                        ],
                      ),
                    ),
                  ],
                );
              }
          );
        }
    );
  }

  // 広告非表示の確認ダイアログを表示
  _showHideAdsConfirm(BuildContext context) async {
    // ダイアログ
    await showDialog (
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(S.of(context).hideAdsDialogTitle),
            content: Text(S.of(context).hideAdsNotes),
            actions: <Widget>[
              TextButton(
                child: Text(S.of(context).cancel),
                onPressed:() => Navigator.of(context).pop(false),
              ),
              TextButton(
                  child: Text(S.of(context).watchAds),
                  onPressed:() async{

                    // ダイアログを閉じる
                    Navigator.of(context).pop(true);

                    // 動画広告を表示
                    _showRewardedAd();
                  }
              ),
            ],
          );
        }
    );
  }


  // _openSubscriptionConfirmationScreen(BuildContext context) {
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(builder: (context) => SubscriptionConfirmationScreen()),
  //   );
  // }
}
