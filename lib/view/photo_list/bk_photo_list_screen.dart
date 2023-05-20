// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
// // import 'package:path/path.dart';
// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:exif/exif.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:photo_information_viewer/view/photo_detail/photo_detail_screen.dart';
// import 'package:photo_information_viewer/view_models/main_view_model.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:provider/provider.dart';
// import 'package:tuple/tuple.dart';
//
// import '../../utils/constants.dart';
// import '../../view_models/manager_view_model.dart';
// import '../../view_models/setting_view_model.dart';
// import '../ad/ad_widget.dart';
// import '../photo_detail/component/exif_value.dart';
//
// class PhotoListScreen extends StatefulWidget {
//   const PhotoListScreen({required this.folder});
//   final AssetPathEntity folder;
//
//   @override
//   State<PhotoListScreen> createState() => _PhotoListScreenState();
// }
//
// class _PhotoListScreenState extends State<PhotoListScreen> {
//
//   Future<bool>? isLoadedPhotos;
//   int crossAxisCount = 3;
//
//   @override
//   void initState() {
//     super.initState();
//     isLoadedPhotos = getPhotos();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final Size screenSize = MediaQuery.of(context).size;
//
//
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         elevation: 0,
//         title: AutoSizeText(widget.folder.name),
//       ),
//       body: FutureBuilder<bool>(
//           future: isLoadedPhotos,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.done) {
//               return Consumer<MainViewModel>(
//                 builder: (context, mainViewModel, child) {
//                   print("写真の数：");
//                   print(mainViewModel.photoList.length);
//                   final photoList = mainViewModel.photoList;
//
//                   return SafeArea(
//                     child: GridView.builder(
//                         shrinkWrap: false,
//                         itemCount: photoList.length,
//                         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                         ),
//                         itemBuilder: (BuildContext context, int index) {
//                           return FutureBuilder(
//                             future: Future.wait([
//                               photoList[index].thumbnailDataWithOption(
//                                 ThumbnailOption(
//                                   // size: ThumbnailSize(250,250),
//                                     size: ThumbnailSize((screenSize.width / crossAxisCount).floor(),(screenSize.width / crossAxisCount).floor()),
//                                     quality: 100,
//                                     format: ThumbnailFormat.jpeg
//                                 ),
//                               ),
//                               getExifData(photoList[index], photoList[index].originBytes),
//                             ]),
//                             builder: (context, snapshot) {
//                               if (snapshot.connectionState == ConnectionState.done) {
//                                 final Uint8List? photoImage = snapshot.data![0] as Uint8List?;
//                                 final Map<String, dynamic>? exifData = snapshot.data![1] as Map<String, dynamic>?;
//
//                                 // フレームサイズ
//                                 IfdTag? imageMake = exifData?["Image Make"];
//                                 IfdTag? imageModel = exifData?["Image Model"];
//                                 String? fileName = exifData?["Image Title"];
//                                 DateTime? takenTime = exifData?["Image CreateDateTime"];
//                                 String? imageLength = exifData?["Image Length"];
//                                 IfdTag? frameWidth = exifData?["EXIF ExifImageWidth"];
//                                 IfdTag? frameLength = exifData?["EXIF ExifImageLength"];
//                                 IfdTag? shutterSpeed = exifData?["EXIF ExposureTime"];
//                                 IfdTag? fNumber = exifData?["EXIF FNumber"];
//                                 IfdTag? iso = exifData?["EXIF ISOSpeedRatings"];
//                                 IfdTag? ev = exifData?["EXIF ExposureBiasValue"];
//                                 IfdTag? focalLength = exifData?["EXIF FocalLength"];
//                                 IfdTag? focalLengthIn35mm = exifData?["EXIF FocalLengthIn35mmFilm"];
//                                 IfdTag? lensMake = exifData?["EXIF LensMake"];
//                                 IfdTag? lensModel = exifData?["EXIF LensModel"];
//
//
//                                 return GestureDetector(
//                                   onTap: () => _goToPhotoDetailScreen(
//                                       context,
//                                       photoImage,
//                                       imageMake,
//                                       imageModel,
//                                       fileName,
//                                       takenTime,
//                                       imageLength,
//                                       frameWidth,
//                                       frameLength,
//                                       shutterSpeed,
//                                       fNumber,
//                                       iso,
//                                       ev,
//                                       focalLength,
//                                       focalLengthIn35mm,
//                                       lensMake,
//                                       lensModel,
//                                       index
//                                   ),
//                                   child: Container(
//                                     margin: EdgeInsets.all(1),
//                                     child: Stack(
//                                       children: <Widget>[
//                                         Positioned.fill(
//                                           child: Image.memory(
//                                             photoImage!,
//                                             fit: BoxFit.cover,
//                                           ),
//                                         ),
//                                         Align(
//                                           alignment: Alignment.bottomCenter,
//                                           child: Container(
//                                             height: 55,
//                                             width: double.infinity,
//                                             color: Colors.white.withOpacity(0.6),
//                                             // padding: EdgeInsets.symmetric(horizontal: 12),
//                                             child: Column(
//                                               children: [
//                                                 Divider(height: 0, thickness: 1.0, color: Colors.black),
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       /// F値
//                                                       Expanded(
//                                                           child: Center(
//                                                               child: (fNumber != null) ? ExifValue(value: 'f ${fNumber.values.toList()[0].toDouble()}', textColor: Colors.black) : ExifValue(value: 'f -', textColor: Colors.black)
//                                                           )
//                                                       ),
//                                                       VerticalDivider(thickness: 1.0, color: Colors.black),
//                                                       /// シャッタースピード（s）
//                                                       Expanded(
//                                                           child: Center(
//                                                               child: (shutterSpeed != null) ? ExifValue(value: '$shutterSpeed s',textColor: Colors.black) : ExifValue(value: '- s', textColor: Colors.black)
//                                                           )
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 Divider(height: 0, thickness: 1.0, color: Colors.black),
//                                                 Expanded(
//                                                   child: Row(
//                                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                                     children: [
//                                                       /// ISO
//                                                       Expanded(
//                                                           child: Center(
//                                                               child: (iso != null) ? ExifValue(value: 'ISO $iso', textColor: Colors.black) : ExifValue(value: 'ISO -', textColor: Colors.black)
//                                                           )
//                                                       ),
//                                                       VerticalDivider(thickness: 1.0, color: Colors.black),
//                                                       /// 露出補正値（ev）
//                                                       Expanded(
//                                                           child: Center(
//                                                               child: (ev != null) ? ExifValue(value: "$ev ev", textColor: Colors.black) :  ExifValue(value: "- ev", textColor: Colors.black)
//                                                           )
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               }
//                               else {
//                                return CupertinoActivityIndicator(
//                                    animating: false,radius: 10
//                                );
//                               }
//                             }
//                           );
//                         }
//                     ),
//                   );
//                 }
//               );
//             }
//             else {
//               return Center(
//                 child: CircularProgressIndicator(),
//               );
//             }
//           }
//       ),
//       bottomNavigationBar: Selector2<ManagerViewModel, SettingViewModel, Tuple2<bool, bool>>(
//           selector: (context, managerViewModel, settingData) =>
//               Tuple2(
//                   managerViewModel.isSubscribed,
//                   settingData.settings.doesHideAds
//               ),
//           builder: (context, data, child) {
//             final isSubscribed = data.item1;
//             final doesHideAds = data.item2;
//             if(isSubscribed || doesHideAds){
//               // 広告削除・非表示の場合
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   // 広告
//                   Container(width: 0.0, height: 0.0),
//                 ],
//               );
//             }
//             else {
//               // 広告表示の場合
//               return SafeArea(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // 広告
//                     // AdmobWidget(bannerAdType: BannerAdType.ADAPTIVE),
//                   ],
//                 ),
//               );
//             }
//           }
//       ),
//     );
//   }
//
//   //////////////////////////////
//   // 写真のロード
//   //////////////////////////////
//   Future<bool>? getPhotos() async {
//     final mainViewModel = context.read<MainViewModel>();
//     await mainViewModel.getPhotos(widget.folder);
//     return true;
//   }
//
//   _goToPhotoDetailScreen(
//       BuildContext context,
//       Uint8List photo,
//       IfdTag? imageMake,
//       IfdTag? imageModel,
//       String? fileName,
//       DateTime? takenTime,
//       String? imageLength,
//       IfdTag? frameWidth,
//       IfdTag? frameLength,
//       IfdTag? shutterSpeed,
//       IfdTag? fNumber,
//       IfdTag? iso,
//       IfdTag? ev,
//       IfdTag? focalLength,
//       IfdTag? focalLengthIn35mm,
//       IfdTag? lensMake,
//       IfdTag? lensModel,
//       int index,
//       ) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => PhotoDetailScreen(
//           photo: photo,
//           imageMake: imageMake,
//           imageModel: imageModel,
//           fileName: fileName,
//           takenTime: takenTime,
//           imageLength: imageLength,
//           frameWidth: frameWidth,
//           frameLength: frameLength,
//           shutterSpeed: shutterSpeed,
//           fNumber: fNumber,
//           iso: iso,
//           ev: ev,
//           focalLength: focalLength,
//           focalLengthIn35mm: focalLengthIn35mm,
//           lensMake: lensMake,
//           lensModel: lensModel,
//         index: index,
//       )),
//     );
//   }
//
//   String formatBytes(int bytes, int decimals) {
//     if (bytes <= 0) return "0 B";
//     const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
//     var i = (log(bytes) / log(1024)).floor();
//
//     if(i == 0 || i == 1){
//       return ((bytes / pow(1024, i)).toStringAsFixed(0)) +
//           ' ' +
//           suffixes[i];
//     }
//     else {
//       return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
//           ' ' +
//           suffixes[i];
//     }
//   }
//
//   Future<Map<String, dynamic>> getExifData(AssetEntity photoFile, Future<Uint8List?> originBytes) async {
//
//     Map<String, dynamic> exifDataList = {};
//     final Uint8List? imageData = await originBytes;
//
//     /// ファイル名
//     exifDataList["Image Title"] = photoFile.title;
//
//     /// 撮影日時
//     exifDataList["Image CreateDateTime"] = photoFile.createDateTime;
//
//     /// 容量
//     final int imageLengthByte = await (imageData!.length);
//     exifDataList["Image Length"] = formatBytes(imageLengthByte, 1);
//
//     /// 撮影場所
//     exifDataList["takenPlace"] = await photoFile.latlngAsync();
//
//     /// Exifデータ取得
//     Map<String, IfdTag> exifData = await readExifFromBytes(
//       imageData!,
//       details: true,
//     );
//
//     if (exifData.isEmpty) {
//       print("No EXIF information found");
//     }
//
//     if (exifData.containsKey('JPEGThumbnail')) {
//       print('File has JPEG thumbnail');
//       exifData.remove('JPEGThumbnail');
//     }
//     if (exifData.containsKey('TIFFThumbnail')) {
//       print('File has TIFF thumbnail');
//       exifData.remove('TIFFThumbnail');
//     }
//
//     // for (final entry in exifData.entries) {
//     //   print("${entry.key}: ${entry.value}");
//     // }
//
//
//     // イメージメーカー・モデル
//     exifDataList["Image Make"] = exifData["Image Make"];
//     exifDataList["Image Model"] = exifData["Image Model"];
//
//     /// シャッタースピード（露出時間）
//     exifDataList["EXIF ExposureTime"] = exifData["EXIF ExposureTime"];
//
//     /// F値
//     exifDataList["EXIF FNumber"] = exifData["EXIF FNumber"];
//
//     /// ISO
//     exifDataList["EXIF ISOSpeedRatings"] = exifData["EXIF ISOSpeedRatings"];
//
//     /// 露出補正値（ev）
//     exifDataList["EXIF ExposureBiasValue"] = exifData["EXIF ExposureBiasValue"];
//
//     /// フレームサイズ
//     exifDataList["EXIF ExifImageWidth"] = exifData["EXIF ExifImageWidth"];
//     exifDataList["EXIF ExifImageLength"] = exifData["EXIF ExifImageLength"];
//
//     /// 焦点距離（Focal length）
//     exifDataList["EXIF FocalLength"] = exifData["EXIF FocalLength"]; // 実焦点距離
//     exifDataList["EXIF FocalLengthIn35mmFilm"] = exifData["EXIF FocalLengthIn35mmFilm"]; // 35mm換算焦点距離
//
//     /// レンズモデル
//     exifDataList["EXIF LensMake"] = exifData["EXIF LensMake"];
//     exifDataList["EXIF LensModel"] = exifData["EXIF LensModel"];
//
//     return exifDataList;
//   }
// }
