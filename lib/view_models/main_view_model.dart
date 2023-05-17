import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MainViewModel extends ChangeNotifier {

  // フォルダ一覧
  List<AssetPathEntity> folderList = [];

  // 写真一覧
  List<AssetEntity> photoList = [];

  // フィルターオプション
  final FilterOptionGroup filterOption = FilterOptionGroup(
      imageOption: FilterOption(
        needTitle: true,
      )
  );

  //////////////////////////
  // フォルダ一覧取得
  //////////////////////////
  Future<void> getFolders() async {
    final result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {

      // フォルダ一覧を取得
      folderList = await PhotoManager.getAssetPathList(filterOption: filterOption);
      folderList.forEach((folder) {
        print("フォルダ名：${folder.name}, タイプ：${folder.type}, アルバムタイプ：${folder.albumType}");

      });
    }

    notifyListeners();
  }

  //////////////////////////
  // フォルダ内の写真一覧取得
  //////////////////////////
  Future<void> getPhotos(AssetPathEntity folder) async {
    final int count = await PhotoManager.getAssetCount(
        filterOption: FilterOptionGroup(
            imageOption: FilterOption(
              needTitle: true, // ファイル名を入れる
            )
        )
    );

    // 写真一覧を取得
    photoList = await folder.getAssetListRange(
      start: 0,
      end: count,
    );
  }


}