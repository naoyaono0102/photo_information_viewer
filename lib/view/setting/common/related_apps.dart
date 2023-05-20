import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../generated/l10n.dart';
import '../../../utils/style.dart';
import '../../../view_models/setting_view_model.dart';

class MoreApps extends StatelessWidget {
  const MoreApps({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;

    // 排便記録
    Uri _iosPoopTrackerAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/simple-headache-log/id6446395359');
    Uri _iosPoopTrackerAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/simple-headache-log/id6446395359');
    Uri _androidPoopTrackerAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.poop_log');

    // フィットネスタイマー
    Uri _iosFitnessTimerAppUrlJP = Uri.parse('https://apps.apple.com/jp/app/fitness-timer-tabata-workout/id1606070677');
    Uri _iosFitnessTimerAppUrlUS = Uri.parse('https://apps.apple.com/us/app/fitness-timer-tabata-workout/id1606070677');
    Uri _androidFitnessTimerAppUrl = Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.workout_timer');

    // 喫煙記録
    Uri _iosSmokeLogAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/smoke-logs/id1665830198');
    Uri _iosSmokeLogAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/smoke-logs/id1665830198');
    Uri _androidSmokeLogAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.smoking_log');

    // 飲酒記録
    Uri _iosDrinkLogAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/simple-drink-log/id1668237986');
    Uri _iosDrinkLogAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/simple-drink-log/id1668237986');
    Uri _androidDrinkLogAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.drinking_log');


    // 体温メモ
    Uri _iosBodyTemperatureNotepadAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/body-temperature-notepad/id1634734110');
    Uri _iosBodyTemperatureNotepadAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/body-temperature-notepad/id1634734110');
    Uri _androidBodyTemperatureNotepadAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.track_body_temperature');

    // 体重メモ
    Uri _iosBodyWeightNotepadAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/body-weight-notepad/id1636260641');
    Uri _iosBodyWeightNotepadAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/body-weight-notepad/id1636260641');
    Uri _androidBodyWeightNotepadAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.track_body_weight');

    // 身長メモ
    Uri _iosHeightNotepadAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/height-record-notepad/id1639501052');
    Uri _iosHeightNotepadAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/height-record-notepad/id1639501052');
    Uri _androidHeightNotepadAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.track_height');

    // 血圧メモ
    Uri _iosBloodPressureNotepadAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/blood-pressure-notepad/id1640631172');
    Uri _iosBloodPressureNotepadAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/blood-pressure-notepad/id1640631172');
    Uri _androidBloodPressureNotepadAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.track_blood_pressure');

    // 血糖値メモ
    Uri _iosBloodSugarNotepadAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/blood-sugar-notepad/id1641031576');
    Uri _iosBloodSugarNotepadAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/blood-sugar-notepad/id1641031576');
    Uri _androidBloodSugarNotepadAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.track_blood_sugar');

    // タンパク質記録
    Uri _iosProteinLogAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/simple-protein-log/id1669670482');
    Uri _iosProteinLogAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/simple-protein-log/id1669670482');
    Uri _androidProteinLogAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.protein_log');

    // 頭痛ログ
    Uri _iosHeadacheLogAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/simple-headache-log/id6446395359');
    Uri _iosHeadacheLogAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/simple-headache-log/id6446395359');
    Uri _androidHeadacheLogAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.headache_tracker');

    // 水分摂取記録
    Uri _iosHydrationTrackerAppUrlJP =  Uri.parse('https://apps.apple.com/jp/app/simple-hydration-tracker/id6447656377');
    Uri _iosHydrationTrackerAppUrlUS =  Uri.parse('https://apps.apple.com/us/app/simple-hydration-tracker/id6447656377');
    Uri _androidHydrationTrackerAppUrl =  Uri.parse('https://play.google.com/store/apps/details?id=com.naoyaono.hydration_tracker');

    return Consumer<SettingViewModel>(
        builder: (context, settingViewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:EdgeInsets.only(left: 24.0, bottom: 12),
                child: Text(
                    S.of(context).moreApps,
                    style: TextStyle(
                      fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      color: kBase2TextColor,
                    )
                ),
              ),
              Container(
                margin: EdgeInsets.only(left:16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                    color: kListTileLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    /////////////////////
                    // 排便日誌
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).poopTracker,
                          style: TextStyle(
                              fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/poop_log_icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidPoopTrackerAppUrl, _iosPoopTrackerAppUrlJP, _iosPoopTrackerAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 水分補給記録
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).hydrationTracker,
                          style: TextStyle(
                              fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/hydration_tracker.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidHydrationTrackerAppUrl, _iosHydrationTrackerAppUrlJP, _iosHydrationTrackerAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 血圧メモ
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).bloodPressureNotepad,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/blood-pressure-icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidBloodPressureNotepadAppUrl, _iosBloodPressureNotepadAppUrlJP, _iosBloodPressureNotepadAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 血糖値メモ
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).bloodSugarNotepad,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/blood_sugar.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidBloodSugarNotepadAppUrl, _iosBloodSugarNotepadAppUrlJP, _iosBloodSugarNotepadAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 頭痛ログ
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).headacheLog,
                          style: TextStyle(
                              fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/headache_log_icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidHeadacheLogAppUrl, _iosHeadacheLogAppUrlJP, _iosHeadacheLogAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 喫煙記録
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).smokeLog,
                          style: TextStyle(
                              fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/smoke_log.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidSmokeLogAppUrl, _iosSmokeLogAppUrlJP, _iosSmokeLogAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 飲酒記録
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).drinkLog,
                          style: TextStyle(
                              fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/drink_log_icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidDrinkLogAppUrl, _iosDrinkLogAppUrlJP, _iosDrinkLogAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 体重メモ
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).bodyWeightNotepad,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                            color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/body-weight-icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidBodyWeightNotepadAppUrl, _iosBodyWeightNotepadAppUrlJP, _iosBodyWeightNotepadAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // 体温メモ帳
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).bodyTemperatureNotepad,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/body-temperature-icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidBodyTemperatureNotepadAppUrl, _iosBodyTemperatureNotepadAppUrlJP, _iosBodyTemperatureNotepadAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0,color: Colors.grey)
                    ),
                    /////////////////////
                    // 身長メモ帳
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).heightRecordNotepad,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/height-record-notepad.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidHeightNotepadAppUrl, _iosHeightNotepadAppUrlJP, _iosHeightNotepadAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0,color: Colors.grey)
                    ),
                    /////////////////////
                    // フィットネスタイマー
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).fitnessTimer,
                          style: TextStyle(
                            fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/fitness-timer-icon.webp',
                            width: 37,
                            height: 37,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidFitnessTimerAppUrl, _iosFitnessTimerAppUrlJP, _iosFitnessTimerAppUrlUS)
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 12, right: 12),
                        child: Divider(height: 0, color: Colors.grey)
                    ),
                    /////////////////////
                    // タンパク質摂取記録
                    /////////////////////
                    ListTile(
                        title: AutoSizeText(
                          S.of(context).proteinLog,
                          style: TextStyle(
                              fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                              color: kBase2TextColor
                          ),
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Image.asset(
                            'assets/icons/protein_log_icon.webp',
                            width: 36,
                            height: 36,
                            // fit: BoxFit.cover,
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                        onTap: () => _openAppPage(context, _androidProteinLogAppUrl, _iosProteinLogAppUrlJP, _iosProteinLogAppUrlUS)
                    ),
                  ],
                ),
              ),
            ],
          );
        }
    );
  }

  // アプリページを開く
  _openAppPage(BuildContext context, Uri androidURL, Uri iosURLJP, Uri iosURLUS) async {
    String languageSetting = Localizations.localeOf(context).languageCode;

    if(Platform.isAndroid){
      // Google Playのリンク
      if (!await launchUrl(androidURL)) throw 'Could not launch $androidURL';
    } else if(Platform.isIOS){
      // App Storeのリンク
      if(languageSetting == 'ja'){
        // 日本
        if (!await launchUrl(iosURLJP)) throw 'Could not launch $iosURLJP';
      } else {
        // 海外
        if (!await launchUrl(iosURLUS)) throw 'Could not launch $iosURLUS';
      }
    }
  }
}
