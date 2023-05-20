import 'package:flutter/material.dart';

import '../data_models/setting.dart';
import '../models/repositories/shared_prefs_repository.dart';

// 音声
const PREF_KEY_SOUND_NUMBER = "soundNumber";
const PREF_KEY_SOUND_NUMBER_TIMEOUT = "soundNumberForTimeout";

// 全体
const PREF_KEY_IS_SLEEP_LOCK = "isSleepLock";
const PREF_KEY_IS_SOUND_EFFECT_ON = "isSoundEffectOn";

// 広告
const PREF_KEY_EXPIRY_DAY = "expiryDay";
const PREF_KEY_HIDE_ADS = "doesHideAds";

// ソート
const PREF_KEY_SORT_TYPE = "sortType";

const PREF_KEY_TEMPERATURE_UNIT = "temperatureUnit";
const PREF_KEY_FIRST_DAY_OF_THE_WEEK = "firstDayOfTheWeek";
const PREF_KEY_DATE_FORMAT_FOR_CHART = "dateFormatForChart";


const PREF_KEY_TARGET_PROTEIN = "targetProtein";
const PREF_KEY_DAY_SWITCH_TIME = "daySwitchTime";

const PREF_KEY_LIST_SORT_NUMBER = "listSortNumber";

// 表示設定
const PREF_KEY_IS_SHOW_AWAKE_BED_TIME = "isShowAwakeTimeAndBedTime";
const PREF_KEY_IS_SHOW_NOTE = "isShowNote";

class SettingViewModel extends ChangeNotifier {

  SettingViewModel({required this.sharedPrefsRepository});
  final SharedPrefsRepository sharedPrefsRepository;

  Setting _settings = Setting();
  Setting get settings => _settings;

  //////////////////////////
  // 初期化
  //////////////////////////
  Future<void> initSetting() async {

    // リストの並び順
    // settings.listSortType = await sharedPrefsRepository.getSortNumber(PREF_KEY_LIST_SORT_NUMBER);

    // 表示設定
    settings.focalLengthType = await sharedPrefsRepository.getFocalLengthType();

    // 広告非表期限
    settings.expiryDay = await sharedPrefsRepository.fetchExpiryDay(PREF_KEY_EXPIRY_DAY);

    // 広告を非表示にするか
    settings.doesHideAds = await sharedPrefsRepository.fetchHideAdsSetting(PREF_KEY_HIDE_ADS);


    // // 背景色
    // settings.backgroundColor = await sharedPrefsRepository.fetchColor(PREF_KEY_BACKGROUND_COLOR);

    // // 並び順
    // settings.sortType = await sharedPrefsRepository.fetchSortType(PREF_KEY_SORT_TYPE);

    notifyListeners();
  }

  //////////////////////////
  // 広告非表示日数を削除
  //////////////////////////
  void deleteExpiryDay(String key) {

    // データ削除
    sharedPrefsRepository.deleteExpiryDay(key);

    // ローカルデータ保存する
    settings.expiryDay = null;
    notifyListeners();
  }

  //////////////////////////
  // 広告非表示設定を保存
  //////////////////////////
  void setHideAdsSetting(String key, bool value) {

    // データ保存
    sharedPrefsRepository.setHideAdsSetting(key, value);

    // ローカルデータ
    settings.doesHideAds = value;
    notifyListeners();
  }

  //////////////////////////
  // 広告非表示日数を保存
  //////////////////////////
  void saveExpiryDay(String key, String value) {

    // データ保存
    sharedPrefsRepository.saveExpiryDay(key, value);

    // ローカルデータ保存する
    settings.expiryDay = value;
  }

  // ///////////////////////////////////
  // // トグル
  // ///////////////////////////////////
  // Future<void> updateSwitch(String key, bool value) async {
  //
  //   // ローカル編集の更新
  //   settings.updateToggle(key);
  //
  //   // DB保存
  //   sharedPrefsRepository.updateSwitch(key, value);
  //
  //
  //   notifyListeners();
  // }

  //////////////////////
  // ソート番号の登録
  //////////////////////
  void setSortNumber(int sortNumber) {
    settings.listSortType = sortNumber;

    // DB保存
    sharedPrefsRepository.setSortNumber(PREF_KEY_LIST_SORT_NUMBER, sortNumber);
    notifyListeners();
  }


  void setFocalLengthType(int? value) async {
    if(value != null){
      // ローカル
      settings.focalLengthType = value;
      await sharedPrefsRepository.setFocalLengthType(value);
    }

    notifyListeners();
  }


}