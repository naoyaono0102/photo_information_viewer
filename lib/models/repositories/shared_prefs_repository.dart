import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 背景色
const PREF_KEY_BACKGROUND_COLOR = "backgroundColor";

// ソート
const PREF_KEY_SORT_TYPE = "sortType";

// 初期設定完了フラグ
const PREF_KEY_IS_DONE_INITIAL_SETTING = "isDoneInitialSetting";

// 表示設定
const PREF_KEY_IS_SHOW_AWAKE_BED_TIME = "isShowAwakeTimeAndBedTime";
const PREF_KEY_IS_SHOW_NOTE = "isShowNote";

const PREF_KEY_FOCAL_LENGTH_TYPE = "focalLengthType";


class SharedPrefsRepository {

  static bool isDarkMode = false;

  ////////////////////////
  // スイッチのON・OFFの切り替え
  ////////////////////////
  Future<void> updateSwitch(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  ////////////////////////
  // 広告非表示日付を削除
  ////////////////////////
  Future<void> deleteExpiryDay(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }

  ////////////////////////
  // 広告非表示設定を保存
  ////////////////////////
  Future<void> setHideAdsSetting(String key, bool value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  ////////////////////////
  // 広告非表示期限を取得
  ////////////////////////
  Future<String?> fetchExpiryDay(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? null;
  }

  ////////////////////////
  // 広告を非表示にするか否か
  ////////////////////////
  Future<bool> fetchHideAdsSetting(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  ////////////////////////
  // 広告を非表示日数を保存
  ////////////////////////
  Future<void> saveExpiryDay(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }
  //////////////////////////////////
  // 並び順の保存
  //////////////////////////////////
  Future<void> saveSortType(int sortNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PREF_KEY_SORT_TYPE, sortNumber);
  }

  //////////////////////////////////
  // 並び順の取得
  //////////////////////////////////
  Future<int> fetchSortType(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  //////////////////////////////////
  // テーマをセット
  //////////////////////////////////
  Future<void> setTheme(String key, bool isDark) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, isDark);
    isDarkMode = isDark;
  }

  Future<void> getTheme(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode = prefs.getBool(key) ?? false;
  }

  Future<void> setSortNumber(String key, int sortNumber) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, sortNumber);
  }

  Future<int> getSortNumber(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key) ?? 0;
  }

  /// 表示する焦点距離の設定保存
  Future<void> setFocalLengthType(int value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(PREF_KEY_FOCAL_LENGTH_TYPE, value);
  }

  /// 表示する焦点距離の設定取得
  Future<int> getFocalLengthType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(PREF_KEY_FOCAL_LENGTH_TYPE) ?? 1;
  }
}