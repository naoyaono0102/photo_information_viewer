import 'package:flutter/material.dart';

// ヘッダー
const kHeaderBackground = Color(0xFFEBEBEB); //Color(0xFFFDF5E3); // DD0200
const kHeaderTitleColor = Color(0xFF333333);
const kAppBarTitleTextStyle = TextStyle(
  color: Color(0xFF333333),
  // fontWeight: FontWeight.bold
);

// 全体の背景
// const kScaffoldBackgroundColor = Color(0xFFEBEBEB);0xFFFBB03B
const kScaffoldBackgroundColor = Color(0xFF1C1C1E); //0xFF373C4D
const kScaffoldSubBackgroundColor = Color(0xFFEBEBEB); //Color(0xFFEBEBEB);
const kNoteBackgroundColor = Colors.white;
const kMainBackgroundColor = Color(0xFFF7F7F7);

// F6942B

// ボタン
const kButtonTextStyle = TextStyle(
  fontSize: 16,
  color: Colors.white,
);

const kSaveButtonColor = Color(0xFFff6347); //Color(0xFFFF6055); //Color(0xFF66BB6A); //Color(0xFFFFC042);
const kSegmentedControlActiveColor = Color(0xFF64B5F6);
const kBottomNaviIconActiveColor = Color(0xFFF89173);
const kSwitchFavoriteButtonColor = Color(0xFF5ba8d2);

// アイコン
const kIconButtonColor = Colors.blue;
const kIconButtonInactiveColor = Colors.grey;

// ○×のテキストスタイル
const kSeatValueTextStyle = TextStyle(
  fontSize: 24,
);

// リストスライダー
const kDeleteSliderColor = Color(0xFFE15656);
const kEditSliderColor = Color(0xFF79BD9A); // スワイプ編集ボタン
const kTransferSliderColor = Color(0xFF6cadf0); // スワイプ編集ボタン

// ダイアログ設定
const kDialogHeaderColor = Colors.transparent;//Colors.grey;
const kDialogCloseButtonColor = Colors.black;
const kDialogHeaderTextStyle = TextStyle(
  color:Colors.black,
  fontWeight: FontWeight.normal,
  fontSize:20.0,
);

const kDialogButtonTextStyle = TextStyle(
  fontSize:18.0,
);

// チェックボックス
const kCheckboxActiveColor = Color(0xFF6699ff);
const kCheckboxOutlineColor = Color(0xFFC7CDD2);


// リスト
const kCategorySumIconColor = Color(0xFFEBEEF2); // カテゴリー数アイコンカラー
const kListTileColor = Colors.white; //Color(0xFFFFFFFF); // タイルカラー
const kListTitleTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.black
);

// カード
const kCardBackground = Colors.white;

// フラッシュメッセージカラー
const kFlashMessageBackgroundColor = Color(0xFF3d3d3d);


// ライトテーマ
final lightTheme = ThemeData(
  primarySwatch: Colors.blue,
  brightness: Brightness.light,
  useMaterial3: false,
  scaffoldBackgroundColor: kScaffoldBackgroundColor,// 背景色
  appBarTheme: AppBarTheme(
      backgroundColor: kScaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: kBase1TextColor,
      ),
      titleTextStyle: TextStyle(
          color: kBase1TextColor,
          fontSize: 20
      )
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryIconTheme: IconThemeData(
      color: kBase1TextColor,
  ),
  iconTheme: IconThemeData(
      color: kBase1TextColor,
  ),
    // 585E71
);


final darkTheme = ThemeData(
  primarySwatch: Colors.yellow,
  brightness: Brightness.dark,
  useMaterial3: false,
  scaffoldBackgroundColor: kScaffoldBackgroundColor,// 背景色
  appBarTheme: AppBarTheme(
      backgroundColor: kScaffoldBackgroundColor,
      iconTheme: IconThemeData(
        color: Color(0xFFFFFFFF),
      ),
      titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0
      )
  ),
  listTileTheme: ListTileThemeData(
      textColor: Colors.white,
      tileColor: Color(0xFF1C1C1E)
  ),
  primaryIconTheme: IconThemeData(
      color: Colors.white
  ),
  iconTheme: IconThemeData(
      color: Colors.white
  ),
  visualDensity: VisualDensity.adaptivePlatformDensity,
);

const kListTileLightColor = Colors.white;
const kListTileDarkColor = Color(0xFF39383D);

// カレンダー
const kSelectedDayColor =  Colors.yellow; //Color(0xFFFF6055);
const kTodayColor = Colors.yellow;
const kCalendarFormatButtonColor = Color(0xFFFF6055);
const kCalendarCountCircleColor = Colors.yellow;

// チャート
const kMaxAndMinValueHeaderColor = Color(0xFFFF6055); // Color(0xFFFF6055); //Color(0xFFFF6055);

const kMaxAndMinValueHeaderTextStyle = TextStyle(
  color: Colors.white,
  fontSize: 20,
);


// テキストフィールド
const kTextFormFieldTextStyle = TextStyle(
  fontSize: 16,
  // height: 1.4,
);

//////////////////////////
// テキストフィールド
//////////////////////////
const kTextFieldBackgroundColor = Colors.white;
const kTextFieldHindTextColor = Color(0xFFa0a1a5);

const kTextFieldTitleTextStyle = TextStyle(
  fontSize: 16,
);

const kTextFieldInputDecoration =  InputDecoration(
  filled: true,
  fillColor: kTextFieldBackgroundColor,
  isDense: true,
  border: const OutlineInputBorder( // 枠線
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  disabledBorder: const OutlineInputBorder( // 枠線
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  focusedBorder: OutlineInputBorder( // テキストフィールド選択時
    // borderSide: BorderSide.none,
    borderSide: BorderSide(color: Colors.white, width: 0.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  errorBorder: OutlineInputBorder( // エラー時
    borderSide: BorderSide(color: Colors.red, width:1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
);



const kTextFieldInputDecoration2 =  InputDecoration(
  filled: true,
  fillColor: kTextFieldBackgroundColor,
  // isDense: true,
  border: const OutlineInputBorder( // 枠線
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  disabledBorder: const OutlineInputBorder( // 枠線
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.blueGrey, width: 1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  focusedBorder: OutlineInputBorder( // テキストフィールド選択時
    // borderSide: BorderSide.none,
    borderSide: BorderSide(color: Colors.blueGrey, width: 3.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
  errorBorder: OutlineInputBorder( // エラー時
    borderSide: BorderSide(color: Colors.red, width:1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
);

// ダイアログ用
const kTextFieldInputDecorationForDialog =  InputDecoration(
  filled: true,
  fillColor: kTextFieldBackgroundColor,
  isDense: true,
  border: const OutlineInputBorder( // 枠線
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(12.0),
    ),
  ),
  disabledBorder: const OutlineInputBorder( // 枠線
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(12.0),
    ),
  ),
  enabledBorder: const OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 0.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(12.0),
    ),
  ),
  focusedBorder: OutlineInputBorder( // テキストフィールド選択時
    // borderSide: BorderSide.none,
    borderSide: BorderSide(color: Colors.white, width: 1.5),
    borderRadius: const BorderRadius.all(
      const Radius.circular(12.0),
    ),
  ),
  errorBorder: OutlineInputBorder( // エラー時
    borderSide: BorderSide(color: Colors.red, width:1.0),
    borderRadius: const BorderRadius.all(
      const Radius.circular(8.0),
    ),
  ),
);

const kListTileTitleTextColor = Color(0xFF333333);

const kChartTextColor = Colors.black;
const kChartBorderColor = Colors.blueGrey;
const kBase1TextColor = Colors.white;
const kBase2TextColor = Color(0xFF585E71);