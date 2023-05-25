import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:exif/exif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';

import '../utils/functions.dart';
import '../view/photo_detail/component/exif_value.dart';
import '../view/photo_detail/photo_detail_screen.dart';

class MainViewModel extends ChangeNotifier {

  // フォルダ一覧
  List<AssetPathEntity> folderList = [];

  // 写真一覧
  List<AssetEntity> photoListInCurrentPage = []; // フォルダの該当ページの写真一覧
  List<AssetEntity> photoListInFolder = []; // フォルダ内の写真一覧

  // フィルターオプション
  final FilterOptionGroup filterOption = FilterOptionGroup(
      imageOption: FilterOption(
        needTitle: true,
      ),
    orders: [
      OrderOption(
        type: OrderOptionType.createDate,
        asc: false,
      ),
    ],
  );

  // 1ページあたりの写真数
  final int _sizePerPage = 36;

  List<Widget> mediaList = [];
  int currentPage = 0;
  int? lastPage;
  int crossAxisCount = 3;

  //////////////////////////
  // フォルダ一覧取得
  //////////////////////////
  Future<void> getFolders() async {
    print("============フォルダ取得処理開始============");
    //　キャッシュクリア
    PhotoManager.clearFileCache();

    final result = await PhotoManager.requestPermissionExtend();

    if(Platform.isAndroid){
      final permitted = await Permission.mediaLibrary.request().isGranted && await Permission.photos.request().isGranted;
      if (result.isAuth && permitted) {
        // フォルダ一覧を取得
        folderList = await PhotoManager.getAssetPathList(
          filterOption: filterOption,
          // type: RequestType.image,
        );
        folderList.forEach((folder) {
          print("フォルダ名：${folder.name}, タイプ：${folder.type}, アルバムタイプ：${folder.albumType}");
        });
      }
      else {
        PhotoManager.openSetting();
      }
    }
    else if(Platform.isIOS){
      if (result.isAuth) {
        // ATT対応
        initPlugin();

        // フォルダ一覧を取得
        folderList = await PhotoManager.getAssetPathList(
          filterOption: filterOption,
          // type: RequestType.image,
        );

        folderList.forEach((folder) {
          print("フォルダ名：${folder.name}, タイプ：${folder.type.containsVideo()}, アルバムタイプ：${folder.albumType},}");
        });
      }
      else {
        PhotoManager.openSetting();
      }
    }

    notifyListeners();
    print("============フォルダ取得処理終了============");
  }

  //////////////////////////
  // フォルダ内の写真一覧取得
  //////////////////////////
  Future<void> getPhotos(AssetPathEntity folder) async {
    print("========フォルダ内の写真のロード開始============");

    /// 現在のページが最後のページの場合ロードしない
    if(currentPage == lastPage) return;

    lastPage = currentPage;
    late int count;

    if(Platform.isAndroid) {
      count = await PhotoManager.getAssetCount();
    }
    else {
      count = await PhotoManager.getAssetCount(
        filterOption: FilterOptionGroup(
            imageOption: FilterOption(
              needTitle: true, // ファイル名を入れる
            )
        )
      );
    }

    // 写真一覧を取得
    photoListInCurrentPage = await folder.getAssetListPaged(
        page: currentPage,
        size: _sizePerPage,
    );

    // フォルダ内の写真をすべて取得
    photoListInFolder = await folder.getAssetListPaged(
        page: 0,
        size: count
    );

    final temp = <Widget>[];

    await Future.forEach(photoListInCurrentPage, (photo) async {
      temp.add(
          FutureBuilder(
              future: getExifData(photo, photo.originBytes),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  final Map<String, dynamic>? exifData = snapshot.data!;

                  // フレームサイズ
                  IfdTag? imageMake = exifData?["Image Make"];
                  IfdTag? imageModel = exifData?["Image Model"];
                  String? fileName = exifData?["Image Title"];
                  DateTime? takenTime = exifData?["Image CreateDateTime"];
                  String? imageLength = exifData?["Image Length"];
                  IfdTag? frameWidth = exifData?["EXIF ExifImageWidth"];
                  IfdTag? frameLength = exifData?["EXIF ExifImageLength"];
                  IfdTag? shutterSpeed = exifData?["EXIF ExposureTime"];
                  IfdTag? fNumber = exifData?["EXIF FNumber"];
                  IfdTag? iso = exifData?["EXIF ISOSpeedRatings"];
                  IfdTag? ev = exifData?["EXIF ExposureBiasValue"];
                  IfdTag? focalLength = exifData?["EXIF FocalLength"];
                  IfdTag? focalLengthIn35mm = exifData?["EXIF FocalLengthIn35mmFilm"];
                  IfdTag? lensMake = exifData?["EXIF LensMake"];
                  IfdTag? lensModel = exifData?["EXIF LensModel"];

                  return GestureDetector(
                    onTap: () => _goToPhotoDetailScreen(
                        context,
                        photo,
                        imageMake,
                        imageModel,
                        fileName,
                        takenTime,
                        imageLength,
                        frameWidth,
                        frameLength,
                        shutterSpeed,
                        fNumber,
                        iso,
                        ev,
                        focalLength,
                        focalLengthIn35mm,
                        lensMake,
                        lensModel,
                      photoListInFolder.indexOf(photo),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(1),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                          child: AssetEntityImage(
                            photo,
                            isOriginal: false,
                            thumbnailSize: const ThumbnailSize.square(250),
                            fit: BoxFit.cover,
                          ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              height: 57,
                              width: double.infinity,
                              color: Colors.white.withOpacity(0.6),
                              // padding: EdgeInsets.symmetric(horizontal: 12),
                              child: Column(
                                children: [
                                  Divider(height: 0, thickness: 1.0, color: Colors.black),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// F値
                                        Expanded(
                                            child: Center(
                                                child: (fNumber != null) ? ExifValue(value: 'f ${fNumber.values.toList()[0].toDouble()}', textColor: Colors.black) : ExifValue(value: 'f -', textColor: Colors.black)
                                            )
                                        ),
                                        VerticalDivider(thickness: 1.0, color: Colors.black),
                                        /// シャッタースピード（s）
                                        Expanded(
                                            child: Center(
                                                child: (shutterSpeed != null) ? ExifValue(value: '$shutterSpeed s',textColor: Colors.black) : ExifValue(value: '- s', textColor: Colors.black)
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                  Divider(height: 0, thickness: 1.0, color: Colors.black),
                                  Expanded(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        /// ISO
                                        Expanded(
                                            child: Center(
                                                child: (iso != null) ? ExifValue(value: 'ISO $iso', textColor: Colors.black) : ExifValue(value: 'ISO -', textColor: Colors.black)
                                            )
                                        ),
                                        VerticalDivider(thickness: 1.0, color: Colors.black),
                                        /// 露出補正値（ev）
                                        Expanded(
                                            child: Center(
                                                child: (ev != null)
                                                 ? ExifValue(value: '${ev.values.toList()[0].toDouble().toStringAsFixed(1).replaceAll(regex, '')} ev', textColor: Colors.black)
                                                    :  ExifValue(value: "- ev", textColor: Colors.black)
                                            )
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                else {
                  return CupertinoActivityIndicator(
                      animating: false,radius: 10
                  );
                }
              }
          )
      );
    });

    // リストに追加
    mediaList.addAll(temp);
    currentPage++;

    notifyListeners();
    print("========フォルダ内の写真のロード終了============");
  }

  /////////////////////////////////////////
  // フォルダ内の写真件数取得とトップ画像を取得
  /////////////////////////////////////////
  Future<List<dynamic>> getFolderInfo(AssetPathEntity folder) async {
    final int count = await PhotoManager.getAssetCount();

    // 写真一覧を取得
    final List<AssetEntity> photoList = await folder.getAssetListRange(
      start: 0,
      end: count,
    );

    // Uint8List? topPicture;
    AssetEntity? topPicture;
    if(photoList.isNotEmpty){
      topPicture = photoList[0];
      // topPicture = await photoList[0].thumbnailDataWithOption(
      //   ThumbnailOption(
      //       size: ThumbnailSize(250, 250),
      //       quality: 100,
      //       format: ThumbnailFormat.png
      //   ),
      // );
    }


    List<Object?> folderInfo = [photoList.length, topPicture];
    return folderInfo;
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


  /// 画面遷移
  _goToPhotoDetailScreen(
      BuildContext context,
      AssetEntity photoEntity,
      IfdTag? imageMake,
      IfdTag? imageModel,
      String? fileName,
      DateTime? takenTime,
      String? imageLength,
      IfdTag? frameWidth,
      IfdTag? frameLength,
      IfdTag? shutterSpeed,
      IfdTag? fNumber,
      IfdTag? iso,
      IfdTag? ev,
      IfdTag? focalLength,
      IfdTag? focalLengthIn35mm,
      IfdTag? lensMake,
      IfdTag? lensModel,
      int index,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoDetailScreen(
        photoEntity: photoEntity,
        imageMake: imageMake,
        imageModel: imageModel,
        fileName: fileName,
        takenTime: takenTime,
        imageLength: imageLength,
        frameWidth: frameWidth,
        frameLength: frameLength,
        shutterSpeed: shutterSpeed,
        fNumber: fNumber,
        iso: iso,
        ev: ev,
        focalLength: focalLength,
        focalLengthIn35mm: focalLengthIn35mm,
        lensMake: lensMake,
        lensModel: lensModel,
        index: index,
      )),
    );
  }


  /////////////////////////////
  // ページindexリセット
  // 最初にページを開いたときに実施
  /////////////////////////////
  Future<void> resetPageIndex() async {
    print("==========ページIndex初期化==========");
    if(Platform.isAndroid){
      PhotoManager.clearFileCache();
    }
    mediaList = [];
    photoListInCurrentPage = [];
    photoListInFolder = [];
    currentPage = 0;
    lastPage = null;
  }

  Future<void> clearCash(BuildContext context) async {
    print("==========キャッシュクリア==========");
    if(Platform.isAndroid){
      PhotoManager.clearFileCache();
    }

    mediaList = [];
    photoListInCurrentPage = []; // フォルダの該当ページの写真一覧
    photoListInFolder = [];
    currentPage = 0;
    lastPage = null;
    notifyListeners();
  }

  ////////////////////////////////
  // IDFAメッセージ
  ///////////////////////////////
  Future<void> initPlugin() async {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 1500));
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
  }


}

