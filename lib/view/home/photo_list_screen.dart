import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
// import 'package:path/path.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:exif/exif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_information_viewer/view/home/photo_detail_screen.dart';
import 'package:photo_information_viewer/view_models/main_view_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class PhotoListScreen extends StatefulWidget {
  const PhotoListScreen({required this.folder});
  final AssetPathEntity folder;

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {

  Future<bool>? isLoadedPhotos;


  @override
  void initState() {
    super.initState();
    isLoadedPhotos = getPhotos();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: FutureBuilder<bool>(
          future: isLoadedPhotos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<MainViewModel>(
                builder: (context, mainViewModel, child) {
                  print("写真の数：");
                  print(mainViewModel.photoList.length);
                  final photoList = mainViewModel.photoList;

                  return SafeArea(
                    child: GridView.builder(
                        itemCount: photoList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemBuilder: (BuildContext context, int index) {

                          return FutureBuilder(
                            future: Future.wait([
                              photoList[index].thumbnailDataWithOption(
                                ThumbnailOption(
                                    size: ThumbnailSize(250, 250),
                                    quality: 100,
                                    format: ThumbnailFormat.png
                                ),
                              ),
                              getExifData(photoList[index], photoList[index].originBytes),
                            ]),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                final Uint8List? photoImage = snapshot.data![0] as Uint8List?;
                                final Map<String, dynamic>? exifData = snapshot.data![1] as Map<String, dynamic>?;

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
                                  onTap: () => _goToPhotoDetailScreen(context, photoImage),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned.fill(
                                        child: Image.memory(
                                          photoImage!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: double.infinity,
                                        color: Colors.white.withOpacity(0.3),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ///  ファイル名
                                            (fileName == null)
                                                ? AutoSizeText('')
                                                : Flexible(child: AutoSizeText(fileName)),
                                            /// フレームサイズ
                                            if(frameWidth != null && frameLength != null) AutoSizeText("${frameLength?.values.firstAsInt()} x ${frameWidth?.values.firstAsInt()}"),
                                            /// F値
                                            (fNumber == null)
                                                ? AutoSizeText("F値: -")
                                                : AutoSizeText("F値: ${fNumber.values.toList()[0].toDouble()}"),
                                            /// ISO
                                            (iso == null)
                                                ? AutoSizeText("ISO: -")
                                                : AutoSizeText("ISO: ${iso.values.firstAsInt()}"),
                                            /// シャッタースピード
                                            (shutterSpeed == null)
                                                ? AutoSizeText("SS: -")
                                                : AutoSizeText("SS: ${shutterSpeed}"),
                                            /// 露出補正（ev）
                                            (ev == null)
                                                ? AutoSizeText("ev: -")
                                                : AutoSizeText("ev: ${ev}"),
                                            /// 焦点距離
                                            (focalLength == null)
                                                ? AutoSizeText("-mm")
                                                : AutoSizeText("${focalLength}mm"),
                                            /// 容量
                                            (imageLength == null)
                                                ? AutoSizeText("-")
                                                : AutoSizeText(imageLength),
                                            ///  撮影日時
                                            (takenTime == null)
                                                ? AutoSizeText('')
                                                : Flexible(child: AutoSizeText(takenTime.toString())),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                );
                              }
                              else {
                               return CupertinoActivityIndicator(
                                   animating: false,radius: 10
                               );
                              }
                            }
                          );
                        }
                    ),
                  );
                }
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

  //////////////////////////////
  // 写真のロード
  //////////////////////////////
  Future<bool>? getPhotos() async {
    final mainViewModel = context.read<MainViewModel>();
    await mainViewModel.getPhotos(widget.folder);
    return true;
  }


  _goToPhotoDetailScreen(BuildContext context, Uint8List photo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoDetailScreen(photo: photo)),
    );
  }

  String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }

  void getPhotoInformation(int index) {


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
    exifDataList["Image Length"] = formatBytes(imageLengthByte, 0);

    /// 撮影場所
    exifDataList["takenPlace"] = await photoFile.latlngAsync();


    /// Exifデータ取得
    Map<String, IfdTag> exifData = await readExifFromBytes(
      imageData!,
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
