import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:exif/exif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_information_viewer/view/home/photo_detail_screen.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoListScreen extends StatefulWidget {
  const PhotoListScreen({required this.folder});
  final AssetPathEntity folder;

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {

  List<AssetEntity> photoList = [];
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
              return SafeArea(
                child: GridView.builder(
                    itemCount: photoList.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return FutureBuilder(
                        // future: photoList[index].thumbnailDataWithOption(
                        //     ThumbnailOption(
                        //         size: ThumbnailSize(250, 250),
                        //         quality: 100,
                        //         format: ThumbnailFormat.png
                        //     ),
                        // ),
                        future: Future.wait([
                          photoList[index].thumbnailDataWithOption(
                            ThumbnailOption(
                                size: ThumbnailSize(250, 250),
                                quality: 100,
                                format: ThumbnailFormat.png
                            ),
                          ),
                          photoList[index].originFile /// EXIF情報ファイル（ISOとか）
                        ]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.done) {
                            final photoFile = photoList[index];
                            final Uint8List photoImage = snapshot.data![0]! as Uint8List;
                            final File exifData = snapshot.data![1]! as File;



                            return GestureDetector(
                              onTap: () => _goToPhotoDetailScreen(context, photoImage),
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: Image.memory(
                                      photoImage,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      Row(
                                        children: [
                                          /// サイズ
                                          // AutoSizeText("${photoFrameWidth} x ${photoFrameHeight}"),

                                        ],
                                      )
                                    ],
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
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
      ),
    );
  }

  Future<bool>? getPhotos() async {
    final int count = await PhotoManager.getAssetCount(
      filterOption: FilterOptionGroup(
          imageOption: FilterOption(
            needTitle: true,
          )
      )
    );

    photoList = await widget.folder.getAssetListRange(
        start: 0,
        end: count,
    );

    //////////////////////////////////
    //////////////////////////////////
    //////////////////////////////////
    final AssetEntity photoFile = photoList[0];
    Uint8List? imageData = await photoList[0].originBytes; /// EXIF情報ファイル（ISOとか）
    File? imageFile = await photoList[0].originFile;
    String? filePath = photoFile.relativePath;

    /// ファイル名
    print(photoFile.title);

    /// 容量
    // var imageLengthByte = (imageData!.length);
    // print("ファイル容量：${formatBytes(imageLengthByte, 0)}");

    // /// 撮影日時
    // final takenTime = photoFile.createDateTime;
    // print("撮影日時：$takenTime");
    //
    // /// 撮影場所
    // final takenPlace = await photoFile.latlngAsync();
    // print("撮影場所：(${takenPlace.latitude},${takenPlace.longitude})");
    //
    //
    Map<String, IfdTag> data = await readExifFromBytes(
        imageData!,
        details: true,
    );
    //
    // if (data.isEmpty) {
    //   print("No EXIF information found");
    // }
    //
    // if (data.containsKey('JPEGThumbnail')) {
    //   print('File has JPEG thumbnail');
    //   data.remove('JPEGThumbnail');
    // }
    // if (data.containsKey('TIFFThumbnail')) {
    //   print('File has TIFF thumbnail');
    //   data.remove('TIFFThumbnail');
    // }
    //
    //

    // for (final entry in data.entries) {
    //   print("${entry.key}: ${entry.value}");
    // }
    //
    //
    // // カメラ・レンズ
    // print(data["Image Make"]);
    // print(data["Image Model"]);
    //
    // // シャッタースピード（露出時間）
    // print(data["EXIF ExposureTime"]);
    //
    // // F値
    // print(data["EXIF FNumber"]);
    //
    // // ISO
    // print(data["EXIF ISOSpeedRatings"]);
    //
    // // 露出補正値（ev）
    // print(data["EXIF ExposureBiasValue"]);
    //
    // // フレームサイズ
    // print(data["EXIF ExifImageWidth"]);
    // print(data["EXIF ExifImageLength"]);
    //
    // // 焦点距離（Focal length）
    // print(data["EXIF FocalLength"]); // 実焦点距離
    // print(data["FocalLengthIn35mmFilm"]); // 35mm換算焦点距離
    //
    // // レンズモデル
    // print(data["EXIF LensMake"]);
    // print(data["EXIF LensModel"]);
    //
    //
    // print("=====");









    return true;
  }


  _goToPhotoDetailScreen(BuildContext context, Uint8List photo) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoDetailScreen(photo: photo)),
    );
  }

  static String formatBytes(int bytes, int decimals) {
    if (bytes <= 0) return "0 B";
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
    var i = (log(bytes) / log(1024)).floor();
    return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
        ' ' +
        suffixes[i];
  }
}
