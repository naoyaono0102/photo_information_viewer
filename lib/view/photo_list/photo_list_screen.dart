import 'dart:io';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_information_viewer/view_models/main_view_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../utils/constants.dart';
import '../../view_models/manager_view_model.dart';
import '../../view_models/setting_view_model.dart';
import '../ad/ad_widget.dart';

class PhotoListScreen extends StatefulWidget {
  const PhotoListScreen({required this.folder});
  final AssetPathEntity folder;

  @override
  State<PhotoListScreen> createState() => _PhotoListScreenState();
}

class _PhotoListScreenState extends State<PhotoListScreen> {

  Future<bool>? isLoadedPhotos;
  int crossAxisCount = 3;
  // final ScrollController? scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    isLoadedPhotos = getPhotos();
  }

  @override
  void dispose() {
    // scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    bool isTablet = screenSize.width > 700 && screenSize.height > 700;

    Future((){
      if(isTablet) crossAxisCount = 4;
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: AutoSizeText(widget.folder.name),
        // title: AutoSizeText("最近の項目"),
        leading: IconButton(
            onPressed: (){
              final mainViewModel = context.read<MainViewModel>();
              mainViewModel.clearCash(context);
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)
        ),
      ),
      body: FutureBuilder<bool>(
          future: isLoadedPhotos,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<MainViewModel>(
                  builder: (context, mainViewModel, child) {
                    // print("写真の数：${mainViewModel.photoList.length}");
                    // final photoList = mainViewModel.photoList;
                    return SafeArea(
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollNotification) {
                          final scrollViewHeight = scrollNotification.metrics.maxScrollExtent;
                          final viewportOffset = scrollNotification.metrics.pixels;
                          final viewportHeight = scrollNotification.metrics.viewportDimension;
                          print("一番下までの高さ:$scrollViewHeight"); // スクロール一番したまでの高さ
                          print("現在位置:$viewportOffset"); // 現在の位置
                          print("1画面の高さ:$viewportHeight"); // 1画面の高さ

                          if (scrollNotification is UserScrollNotification) {
                            Future((){
                              _handleScrollEvent(scrollNotification);
                            });

                          }
                          return false;
                        },
                        child: GridView.builder(
                            shrinkWrap: false,
                            addAutomaticKeepAlives: true,
                            cacheExtent: (Platform.isAndroid) ? 0.0 : null,
                            // controller: scrollController,
                            itemCount: mainViewModel.mediaList.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                            ),
                            itemBuilder: (BuildContext context, int index) {


                              return mainViewModel.mediaList[index];
                            }
                        ),
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

  //////////////////////////////
  // 写真のロード
  //////////////////////////////
  Future<bool>? getPhotos() async {
    final mainViewModel = context.read<MainViewModel>();
    await mainViewModel.resetPageIndex();
    await mainViewModel.getPhotos(widget.folder);
    return true;
  }

  // スクロール時の処理
  // 画面下までスクロールされたら次のデータをロードする
  Future<void> _handleScrollEvent(UserScrollNotification scrollNotification) async {
    if (scrollNotification.metrics.pixels / scrollNotification.metrics.maxScrollExtent > 0.85) {
      print("==========スクロールが下のほうに来たので次のデータを読み込む==========");
      final mainViewModel = context.read<MainViewModel>();
      mainViewModel.getPhotos(widget.folder);
    }
  }
}
