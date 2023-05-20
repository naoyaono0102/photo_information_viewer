import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:photo_information_viewer/view/setting/common/focal_length_setting.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../generated/l10n.dart';
import '../../utils/constants.dart';
import '../../utils/style.dart';
import '../../view_models/manager_view_model.dart';
import '../../view_models/setting_view_model.dart';
import '../ad/ad_widget.dart';
import '../ad/native_ad.dart';
import 'common/about.dart';
import 'common/ad_setting.dart';
import 'common/related_apps.dart';

class SettingScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        title: AutoSizeText(
          S.of(context).settings
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Selector<ManagerViewModel, bool>(
                        selector: (context, viewModel) => viewModel.isInAppPurchaseProcessing,
                        builder: (context, isProcessing, child) => Opacity(
                          opacity: (isProcessing) ? 0.25 : 1.0,
                          child: AbsorbPointer(
                            absorbing: isProcessing,
                            child: Column(
                              children: [
                                ListView(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  children: [
                                    //////////////////////////////
                                    // 表示する焦点距離のタイプ
                                    //////////////////////////////
                                    SizedBox(height:30.0),
                                    FocalLengthSettings(),
                                    //////////////////////
                                    // 広告
                                    //////////////////////
                                    SizedBox(height:30.0),
                                    AdSetting(),
                                    Selector2<ManagerViewModel,SettingViewModel,Tuple2<bool,bool>>(
                                        selector : (context,managerViewModel,settingData) => Tuple2(
                                            managerViewModel.isSubscribed,
                                            settingData.settings.doesHideAds
                                        ),
                                        builder: (context, data, child) {
                                          final isSubscribed = data.item1;
                                          final doesHideAds = data.item2;
                                          return (isSubscribed || doesHideAds)
                                              ? Container(width: 0, height: 0)
                                              : Container(
                                              margin: EdgeInsets.only(left: 16, right: 16, top: 20, bottom: 0),
                                              padding: EdgeInsets.only(left: 4, right: 4, top: 8),
                                              decoration: BoxDecoration(
                                                  // color: Colors.grey.withOpacity(0.2),
                                                  borderRadius: BorderRadius.all(Radius.circular(8))
                                              ),
                                              child: NativeAdWidget()
                                          );
                                        }
                                    ),
                                    //////////////////////////////
                                    // アプリについて
                                    //////////////////////////////
                                    SizedBox(height:30.0),
                                    About(),
                                    //////////////////////////////
                                    // 関連アプリ
                                    //////////////////////////////
                                    // SizedBox(height:30.0),
                                    // MoreApps(),
                                    SizedBox(height: 24.0),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                    ),
                  ),
                ),
              ],
            ),
            Selector<ManagerViewModel, bool>(
                selector: (context, managerViewModel) => managerViewModel.isInAppPurchaseProcessing,
                builder: (context, isProcessing, child) {
                  return Visibility(
                    visible: isProcessing,
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  );
                }
            ),
          ],
        ),
      ),
      bottomNavigationBar: Selector2<ManagerViewModel, SettingViewModel, Tuple2<bool, bool>>(
          selector: (context, managerViewModel, settingData) =>
              Tuple2(
                  managerViewModel.isSubscribed,
                  settingData.settings.doesHideAds
              ),
          builder: (context, data, child) {
            final isSubscribed = data.item1;
            final doesHideAds = data.item2;
            if(isSubscribed || doesHideAds){
              // 広告削除・非表示の場合
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 広告
                  Container(width: 0.0, height: 0.0),
                ],
              );
            }
            else {
              // 広告表示の場合
              return SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 広告
                    AdmobWidget(bannerAdType: BannerAdType.ADAPTIVE),
                  ],
                ),
              );
            }
          }
      ),
    );
  }
}