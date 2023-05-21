import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:exif/exif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:photo_information_viewer/utils/functions.dart';
import 'package:photo_information_viewer/view_models/main_view_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tuple/tuple.dart';

import '../../utils/constants.dart';
import '../../utils/style.dart';
import '../../view_models/manager_view_model.dart';
import '../../view_models/setting_view_model.dart';
import '../ad/ad_widget.dart';
import 'component/exif_value.dart';

class PhotoDetailScreen extends StatefulWidget {
  const PhotoDetailScreen({
    required this.photoEntity,
    this.imageMake,
    this.imageModel,
    this.fileName,
    this.takenTime,
    this.imageLength,
    this.frameWidth,
    this.frameLength,
    this.shutterSpeed,
    this.fNumber,
    this.iso,
    this.ev,
    this.focalLength,
    this.focalLengthIn35mm,
    this.lensMake,
    this.lensModel,
    required this.index,
  });

  final AssetEntity photoEntity;
  final IfdTag? imageMake;
  final IfdTag? imageModel;
  final String? fileName;
  final DateTime? takenTime;
  final String? imageLength;
  final IfdTag? frameWidth;
  final IfdTag? frameLength;
  final IfdTag? shutterSpeed;
  final IfdTag? fNumber;
  final IfdTag? iso;
  final IfdTag? ev;
  final IfdTag? focalLength;
  final IfdTag? focalLengthIn35mm;
  final IfdTag? lensMake;
  final IfdTag? lensModel;
  final int index;

  @override
  State<PhotoDetailScreen> createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {

  // Uint8List? photoImage;
  AssetEntity? photoImage;
  late int currentIndex;
  late int maxIndex;
  String? imageName;
  late List<AssetEntity> photoList;
  int? width;
  int? height;
  int? isoValue;
  double? fNumberValue;
  String? shutterSpeedValue;
  double? evValue;
  double? focalLengthValue;
  double? focalLengthIn35mmValue;
  String? imageLengthValue;
  DateTime? takenTimeValue;
  late String cameraMaker;
  late String cameraModel;


  @override
  void initState() {
    final mainViewModel = context.read<MainViewModel>();
    // 画像データ
    // photoImage = widget.photo;
    photoImage = widget.photoEntity;

    // 画像一覧
    // photoList = mainViewModel.photoList;
    photoList = mainViewModel.photoListInFolder;
    maxIndex = (photoList.isNotEmpty) ? (photoList.length - 1) : 0;

    // 撮影日時
    takenTimeValue = widget.takenTime;

    // 容量
    imageLengthValue = widget.imageLength;

    // ファイル名
    imageName = widget.fileName;
    currentIndex = widget.index;
    width = widget.frameLength?.values.firstAsInt();
    height = widget.frameWidth?.values.firstAsInt();
    shutterSpeedValue = (widget.shutterSpeed != null) ? "${widget.shutterSpeed}" : '-';
    evValue = widget.ev?.values.toList()[0].toDouble();
    // focalLengthValue = (widget.focalLength != null) ? "${widget.focalLength}" : '-';
    // focalLengthIn35mmValue = (widget.focalLengthIn35mm != null) ? "${widget.focalLengthIn35mm}" : '-';
    isoValue = widget.iso?.values.firstAsInt();
    focalLengthValue = widget.focalLength?.values.toList()[0].toDouble();
    focalLengthIn35mmValue = widget.focalLengthIn35mm?.values.toList()[0].toDouble();
    fNumberValue = widget.fNumber?.values.toList()[0].toDouble();
    cameraMaker = widget.imageMake != null ? "${widget.imageMake}" : '';
    cameraModel = widget.imageModel != null ? widget.imageModel.toString() : '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final Locale locale = Localizations.localeOf(context);
    final isTablet = (screenSize.width > 700 && screenSize.height > 700);

    ///　画像セット
    Future(() async {
      photoImage = photoList[currentIndex];
    });


    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
            (imageName != null)
                ? imageName!
                : '',
        ),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios),
        ),
        actions: [
          IconButton(
              onPressed: ()=> _shareImage(context, photoList[currentIndex], imageName),
              icon: Icon(Icons.share)
          )
        ],
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 画像
                  if(photoImage != null)
                    Container(
                      width: double.infinity,
                      height: screenSize.height / 2.5,
                      child: AssetEntityImage(
                        photoImage!,
                        isOriginal: false,
                        thumbnailSize:  const ThumbnailSize.square(800),
                        thumbnailFormat: ThumbnailFormat.jpeg,
                        fit: BoxFit.contain,
                      ),
                    )
                  else  Container(
                    width: double.infinity,
                    height: screenSize.height / 2.5,
                    child: Center(
                      child: AutoSizeText("No Image"),
                    )
                  ),
                  SizedBox(height: isTablet ? 25 : 20),

                  /// 画像情報
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 撮影日時
                        if(takenTimeValue != null)
                        Container(
                          margin: EdgeInsets.only(left: 5, bottom: 6),
                          child: AutoSizeText(
                            formatDate(locale.languageCode, takenTimeValue!),
                            style: TextStyle(
                              fontSize: getBaseFontSize(context, screenSize),
                              color: Colors.white,
                            ),
                          ),
                        ),

                        /// 画像情報
                        Container(
                          height: isTablet ? 240 : 160,
                          decoration: BoxDecoration(
                              color: kListTileDarkColor,
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Column(
                            children: [
                              /// ヘッダー（カメラメーカーなど）
                              Container(
                                width: double.infinity,
                                // height: 40,
                                padding: EdgeInsets.only(
                                    left: 12,
                                    right: 12,
                                    top: isTablet ? 12 : 7,
                                    bottom: isTablet ? 12 : 7
                                ),
                                decoration: BoxDecoration(
                                  // color: Colors.blueGrey,
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5,
                                            color: Colors.white
                                        )
                                    )
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: AutoSizeText(
                                    // "${widget.imageMake}, ${widget.imageModel}, ${widget.lensMake}, ${widget.lensModel}",
                                    (cameraMaker == "" && cameraModel == "") ? "-" : "$cameraMaker $cameraModel",
                                    style: TextStyle(
                                        fontSize: getBaseFontSize(context, screenSize),
                                      color: Colors.white,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                              ),

                              /// ファイル名・サイズ
                              Expanded(
                                child: Container(
                                  // height: 52,
                                  // color: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: [
                                      /// ファイル名
                                      (imageName != null)
                                          ?  ExifValue(value: imageName!)
                                          :  ExifValue(value: "ファイル名が表示できません"),

                                SizedBox(height: 8),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          /// フレームサイズ
                                          if(width != null && height != null) ExifValue(value: '$width x $height'),
                                          if(width != null && height != null) SizedBox(width: 15),
                                          /// 容量
                                         if(imageLengthValue != null) ExifValue(value: imageLengthValue!)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              /// Exif情報
                              Divider(height:0, thickness: 0.5,color: Colors.white),
                              Container(
                                height: isTablet ? 50 : 35,
                                margin: EdgeInsets.symmetric(vertical: 6),
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    /// F値
                                    Flexible(
                                        child: Center(
                                            child: (fNumberValue != null) ? ExifValue(value: 'f $fNumberValue') : ExifValue(value: 'f -')
                                        )
                                    ),
                                    VerticalDivider(thickness: 0.5, color: Colors.white),
                                    /// シャッタースピード（s）
                                    Flexible(
                                        child: Center(
                                            child: ExifValue(value: '${shutterSpeedValue} s')
                                        )
                                    ),
                                    VerticalDivider(thickness: 0.5, color: Colors.white),
                                    /// ISO
                                    Flexible(
                                        child: Center(
                                            child: (isoValue != null) ? ExifValue(value: 'ISO $isoValue') : ExifValue(value: 'ISO -')
                                        )
                                    ),
                                    VerticalDivider(thickness: 0.5, color: Colors.white),

                                    Selector<SettingViewModel, int>(
                                     selector: (context, settingViewModel) => settingViewModel.settings.focalLengthType,
                                      builder: (context, focalLengthType, child) {
                                        if(focalLengthType == 0){
                                          /// 実焦点距離（mm）
                                          return Flexible(
                                              child: Center(
                                                child: (focalLengthValue != null) ? ExifValue(value: '${focalLengthValue.toString().replaceAll(regex, '')} mm') : ExifValue(value: '- mm'),
                                              )
                                          );
                                        }
                                        else {
                                          /// 35mm換算焦点距離
                                          return Flexible(
                                              child: Center(
                                                child: (focalLengthIn35mmValue != null) ? ExifValue(value: '${focalLengthIn35mmValue.toString().replaceAll(regex, '')} mm') : ExifValue(value: '- mm'),
                                              )
                                          );
                                        }
                                      }
                                    ),


                                    VerticalDivider(thickness: 0.5, color: Colors.white),

                                    /// 露出補正値（ev）
                                    Flexible(
                                        child: Center(
                                          child: (evValue != null)
                                              // ? ExifValue(value: '${evValue.toString().replaceAll(regex, '')} ev')
                                              ? ExifValue(value: '${(evValue!.toStringAsFixed(1)).replaceAll(regex, '')} ev')
                                              : ExifValue(value: '- ev'),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  /// 次へ・前へボタン
                  SizedBox(height: 20),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      // color: Colors.orange[400],
                      borderRadius: BorderRadius.all(Radius.circular(50))
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(currentIndex != 0)
                        GestureDetector(
                          onTap: () => showPreviousPhoto(context, screenSize),
                          child: Container(
                            width: isTablet ? 75 : 60,
                            height: isTablet ? 75 : 60,
                            padding: EdgeInsets.only(right: 4),
                            decoration: BoxDecoration(
                              color: Colors.orange[400],
                              shape: BoxShape.circle
                            ),
                            child: Transform.rotate(
                                angle: 45 * pi,
                                child: Center(child: FaIcon(FontAwesomeIcons.play, color: Colors.white))
                            ),
                          ),
                        ),
                        Spacer(),
                        if(currentIndex < maxIndex)
                          GestureDetector(
                          onTap: () => showNextPhoto(context, screenSize),
                          child: Container(
                              width: isTablet ? 75 : 60,
                              height: isTablet ? 75 : 60,
                              padding: EdgeInsets.only(left: 4),
                              decoration: BoxDecoration(
                                  color: Colors.orange[400],
                                  shape: BoxShape.circle
                              ),
                              child: Center(child: FaIcon(FontAwesomeIcons.play, color: Colors.white))
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
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

  /////////////////////////
  // 画像の共有
  /////////////////////////
  Future<void> _shareImage(BuildContext context, AssetEntity image, String? imageName) async {
    final managerViewModel = context.read<ManagerViewModel>();
    final settingViewModel = context.read<SettingViewModel>();

    File? file = await image.originFile;
    if(file != null){
      XFile xFile = await XFile(file.path);
      await Share.shareXFiles(
        [xFile],
        subject: imageName ?? 'image',
        sharePositionOrigin: shareButtonRect(),
      ).then((value) {
        if(!managerViewModel.isDeleteAd && !settingViewModel.settings.doesHideAds){
          // インタースティシャル表示
          print('広告を表示');
          managerViewModel.loadInterstitialAd();
        }
      });
    }
  }

  Rect shareButtonRect() {
    final RenderBox box = context.findRenderObject() as RenderBox;
    print(box.localToGlobal(Offset.zero) & box.size);

    Size size = box.size;
    Offset position = box.localToGlobal(Offset.zero);

    return Rect.fromCenter(
      center: position + Offset(size.width/3, size.height/3),
      width: size.width/2,
      height: size.height/2,
    );
  }

  showPreviousPhoto(BuildContext context, Size screenSize) async {

    currentIndex--;

    // 前の画像をセット
    photoImage = photoList[currentIndex];

    final Map<String, dynamic> exifData = await getExifData(photoList[currentIndex], photoList[currentIndex].originBytes);

    // 写真情報一覧
    IfdTag? imageMake = exifData["Image Make"];
    IfdTag? imageModel = exifData["Image Model"];
    String? fileName = exifData["Image Title"];
    DateTime? takenTime = exifData["Image CreateDateTime"];
    String? imageLength = exifData["Image Length"];
    IfdTag? frameWidth = exifData["EXIF ExifImageWidth"];
    IfdTag? frameLength = exifData["EXIF ExifImageLength"];
    IfdTag? shutterSpeed = exifData["EXIF ExposureTime"];
    IfdTag? fNumber = exifData["EXIF FNumber"];
    IfdTag? iso = exifData["EXIF ISOSpeedRatings"];
    IfdTag? ev = exifData["EXIF ExposureBiasValue"];
    IfdTag? focalLength = exifData["EXIF FocalLength"];
    IfdTag? focalLengthIn35mm = exifData["EXIF FocalLengthIn35mmFilm"];
    IfdTag? lensMake = exifData["EXIF LensMake"];
    IfdTag? lensModel = exifData["EXIF LensModel"];

    imageName = fileName; // ファイル名
    takenTimeValue = takenTime; // 撮影日時
    imageLengthValue = imageLength; // 容量
    width = frameLength?.values.firstAsInt();
    height = frameWidth?.values.firstAsInt();
    isoValue = iso?.values.firstAsInt(); // ISO
    shutterSpeedValue = (shutterSpeed != null) ? "${shutterSpeed}" : "-"; // シャッタースピード
    evValue = widget.ev?.values.toList()[0].toDouble(); // 露出補正値
    fNumberValue = fNumber?.values.toList()[0].toDouble(); // F値
    focalLengthValue = focalLength?.values.toList()[0].toDouble(); // 実焦点距離
    focalLengthIn35mmValue = focalLengthIn35mm?.values.toList()[0].toDouble(); // 35mm換算焦点距離
    cameraMaker = imageMake != null ? imageMake.toString() : '';
    cameraModel = imageModel != null ? imageModel.toString() : '';

    setState(() {});
  }

  showNextPhoto(BuildContext context, Size screenSize) async {
    currentIndex++;

    // 次の画像をセット
    photoImage = photoList[currentIndex];

    final exifData = await getExifData(photoList[currentIndex], photoList[currentIndex].originBytes);

    // 写真情報一覧
    IfdTag? imageMake = exifData["Image Make"];
    IfdTag? imageModel = exifData["Image Model"];
    String? fileName = exifData["Image Title"];
    DateTime? takenTime = exifData["Image CreateDateTime"];
    String? imageLength = exifData["Image Length"];
    IfdTag? frameWidth = exifData["EXIF ExifImageWidth"];
    IfdTag? frameLength = exifData["EXIF ExifImageLength"];
    IfdTag? shutterSpeed = exifData["EXIF ExposureTime"];
    IfdTag? fNumber = exifData["EXIF FNumber"];
    IfdTag? iso = exifData["EXIF ISOSpeedRatings"];
    IfdTag? ev = exifData["EXIF ExposureBiasValue"];
    IfdTag? focalLength = exifData["EXIF FocalLength"];
    IfdTag? focalLengthIn35mm = exifData["EXIF FocalLengthIn35mmFilm"];
    IfdTag? lensMake = exifData["EXIF LensMake"];
    IfdTag? lensModel = exifData["EXIF LensModel"];

    imageName = fileName; // ファイル名
    takenTimeValue = takenTime; // 撮影日時
    imageLengthValue = imageLength; // 容量
    width = frameLength?.values.firstAsInt();
    height = frameWidth?.values.firstAsInt();
    isoValue = iso?.values.firstAsInt(); // ISO
    shutterSpeedValue = (shutterSpeed != null) ? "${shutterSpeed}" : "-"; // シャッタースピード
    evValue = widget.ev?.values.toList()[0].toDouble(); // 露出補正値
    fNumberValue = fNumber?.values.toList()[0].toDouble(); // F値
    focalLengthValue = focalLength?.values.toList()[0].toDouble(); // 実焦点距離
    focalLengthIn35mmValue = focalLengthIn35mm?.values.toList()[0].toDouble(); // 35mm換算焦点距離
    cameraMaker = imageMake != null ? imageMake.toString() : '';
    cameraModel = imageModel != null ? imageModel.toString() : '';

    setState(() {});
  }

  Future<Map<String, dynamic>> getExifData(AssetEntity photoFile, Future<Uint8List?> originBytes) async {

    Map<String, dynamic> exifDataList = {};
    final Uint8List? imageData = await originBytes;

    /// ファイル名
    exifDataList["Image Title"] = photoFile.title;

    /// 撮影日時
    exifDataList["Image CreateDateTime"] = photoFile.createDateTime;


    /// 容量
    final int imageLengthByte = await (imageData!.length);
    exifDataList["Image Length"] = formatBytes(imageLengthByte, 1);

    /// 撮影場所
    exifDataList["takenPlace"] = await photoFile.latlngAsync();


    /// Exifデータ取得
    Map<String, IfdTag> exifData = await readExifFromBytes(
      imageData,
      details: true,
    );

    if (exifData.isEmpty) {
      print("No EXIF information found");
    }

    if (exifData.containsKey('JPEGThumbnail')) {
      print('File has JPEG thumbnail');
      exifData.remove('JPEGThumbnail');
    }
    if (exifData.containsKey('TIFFThumbnail')) {
      print('File has TIFF thumbnail');
      exifData.remove('TIFFThumbnail');
    }

    // for (final entry in exifData.entries) {
    //   print("${entry.key}: ${entry.value}");
    // }


    // イメージメーカー・モデル
    exifDataList["Image Make"] = exifData["Image Make"];
    exifDataList["Image Model"] = exifData["Image Model"];

    /// シャッタースピード（露出時間）
    exifDataList["EXIF ExposureTime"] = exifData["EXIF ExposureTime"];

    /// F値
    exifDataList["EXIF FNumber"] = exifData["EXIF FNumber"];

    /// ISO
    exifDataList["EXIF ISOSpeedRatings"] = exifData["EXIF ISOSpeedRatings"];

    /// 露出補正値（ev）
    exifDataList["EXIF ExposureBiasValue"] = exifData["EXIF ExposureBiasValue"];

    /// フレームサイズ
    exifDataList["EXIF ExifImageWidth"] = exifData["EXIF ExifImageWidth"];
    exifDataList["EXIF ExifImageLength"] = exifData["EXIF ExifImageLength"];

    /// 焦点距離（Focal length）
    exifDataList["EXIF FocalLength"] = exifData["EXIF FocalLength"]; // 実焦点距離
    exifDataList["EXIF FocalLengthIn35mmFilm"] = exifData["EXIF FocalLengthIn35mmFilm"]; // 35mm換算焦点距離

    /// レンズモデル
    exifDataList["EXIF LensMake"] = exifData["EXIF LensMake"];
    exifDataList["EXIF LensModel"] = exifData["EXIF LensModel"];

    return exifDataList;
  }
}
