import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:photo_information_viewer/utils/functions.dart';
import 'package:photo_information_viewer/view/photo_list/photo_list_screen.dart';
import 'package:photo_information_viewer/view/setting/setting_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager_image_provider/photo_manager_image_provider.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import '../../generated/l10n.dart';
import '../../utils/constants.dart';
import '../../view_models/main_view_model.dart';
import '../../view_models/manager_view_model.dart';
import '../../view_models/setting_view_model.dart';
import '../ad/ad_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<bool>? isFolderLoaded;

  @override
  void initState() {
    checkConsentStatus();
    isFolderLoaded = loadFolders();
    super.initState();
  }

  ////////////////////////////////
  // GDPRメッセージ
  ///////////////////////////////
  Future<void> checkConsentStatus() async {
    print("=======  GDPR対応処理開始 =======");

    // デバッグ用
    // ConsentDebugSettings debugSettings = await ConsentDebugSettings(
    //   debugGeography: DebugGeography.debugGeographyEea,
    //   // testIdentifiers: ["F5994844C7AF2BA96B56B32D47728DBD"]
    //   testIdentifiers: ["1057C8F78B6687AA1FDB4607D03C7BAC"]
    // );
    // final ConsentRequestParameters params = ConsentRequestParameters(consentDebugSettings: debugSettings);

    final ConsentRequestParameters params = ConsentRequestParameters();

    var status = await ConsentInformation.instance.getConsentStatus();
    print("ステータス：${status.name}");
    print(params.consentDebugSettings);

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
          () async {
        // The consent information state was updated.
        // You are now ready to check if a form is available.
        print("isConsentFormAvailable：${await ConsentInformation.instance.isConsentFormAvailable()}");
        if(await ConsentInformation.instance.isConsentFormAvailable()){
          loadConsentForm();
        }
      },
          (FormError error) {
        // Handle the error
        print("Error：$error");
      },
    );
  }

  Future<void> loadConsentForm() async {
    print("====　ヨーロッパのユーザーに同意を求める画面を表示 ====");
    ConsentForm.loadConsentForm(
          (ConsentForm consentForm) async {
        // Present the form
        var status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required || status == ConsentStatus.unknown) {
          consentForm.show((formError) {
            print(formError);
            if(formError == null){
              loadConsentForm();
            }
          });
        }
      },
          (FormError formError) {
        // Handle the error
        print("エラー：$formError");
      },
    );
  }


  // ////////////////////////////////
  // // IDFAメッセージ
  // ///////////////////////////////
  // Future<void> initPlugin() async {
  //   final status = await AppTrackingTransparency.trackingAuthorizationStatus;
  //   if (status == TrackingStatus.notDetermined) {
  //     await Future.delayed(const Duration(milliseconds: 5500));
  //     await AppTrackingTransparency.requestTrackingAuthorization();
  //   }
  // }


  @override
  Widget build(BuildContext context) {

    final settingViewModel = context.read<SettingViewModel>();
    final Size screenSize = MediaQuery.of(context).size;
    bool isTablet = screenSize.width > 700 && screenSize.height > 700;

    Future((){
      // 広告非表示チェック
      // 有効期限が設定されている場合
      if (settingViewModel.settings.expiryDay != null && settingViewModel.settings.expiryDay != '') {
        // 有効期限をDateTime型で取得
        DateTime expiryDay = DateTime.parse(settingViewModel.settings.expiryDay!).toLocal();

        // 有効期限が過ぎてないかチェック
        if (DateTime.now().isBefore(expiryDay)) { // 今の時刻は有効期限よりも前か？
          // print('有効期限よりも前です');
        } else {
          // print('有効期限切れです');
          // DBの有効日付データを削除
          settingViewModel.deleteExpiryDay('expiryDay');

          // 2. 非表示フラグをOFFに
          settingViewModel.setHideAdsSetting('doesHideAds', false);
        }
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(S.of(context).folder),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => _openSettingScreen(context),
          icon:  Icon(Icons.settings)
        ),
        elevation: 0,
      ),
      body: FutureBuilder(
          future: isFolderLoaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<MainViewModel>(
                  builder: (context, mainViewModel, child) {
                    return SafeArea(
                      child: ListView.separated(
                        itemCount: mainViewModel.folderList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AssetPathEntity folder = mainViewModel.folderList[index];

                          return FutureBuilder(
                            future: mainViewModel.getFolderInfo(folder),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.done) {
                                final List<dynamic>? data = snapshot.data;
                                final int numberOfPhotos = data![0];
                                final AssetEntity? topPicture = data[1];
                                return ListTile(
                                  title: AutoSizeText(
                                    folder.name,
                                    style: TextStyle(
                                        fontSize: getBaseFontSize(context, screenSize)
                                    ),
                                  ),
                                  subtitle: AutoSizeText(
                                    numberOfPhotos.toString(),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: isTablet ? getBaseFontSize(context, screenSize) - 4 : getBaseFontSize(context, screenSize) - 2
                                    ),
                                  ),
                                  leading: (topPicture != null)
                                      ? Container(
                                      width: isTablet ? 75 : 60,
                                      height: isTablet ? 75 : 60,
                                      child:  AssetEntityImage(
                                        topPicture,
                                        isOriginal: false,
                                        thumbnailSize:  const ThumbnailSize.square(150),
                                        thumbnailFormat: ThumbnailFormat.jpeg,
                                        fit: BoxFit.cover,
                                      ))
                                      // child: Image.memory(
                                      //     topPicture,
                                      //     fit: BoxFit.cover,
                                      // ))
                                      : Container(
                                      width: isTablet ? 75 : 60,
                                      height: isTablet ? 75 : 60,
                                    padding: EdgeInsets.symmetric(horizontal: 2),
                                    color: Colors.grey[300],
                                    child: Center(
                                      child: AutoSizeText(
                                        "No Image",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ),
                                  trailing: Icon(Icons.chevron_right),
                                  onTap: () => _goToPhotoList(context, folder),
                                );
                              }
                              else {
                                return ListTile(
                                  title: CupertinoActivityIndicator(),
                                );
                              }
                            }
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(height: 0, thickness: 0.5, color: Colors.blueGrey);
                        },
                      ),
                    );
                  }
              );
            }
            else {
              return Container(
                  child: Center(child: CircularProgressIndicator())
              );
            }
          }
      ),
      bottomNavigationBar: Selector2<ManagerViewModel, SettingViewModel, Tuple2<bool, bool>>(
          selector: (context, managerViewModel, settingData) =>
              Tuple2(
                  managerViewModel.isDeleteAd,
                  settingData.settings.doesHideAds
              ),
          builder: (context, data, child) {
            final isDeleteAd = data.item1;
            final doesHideAds = data.item2;
            if(isDeleteAd || doesHideAds){
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
                    SizedBox(height: 1),
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

  Future<bool>? loadFolders() async {
    final mainViewModel = context.read<MainViewModel>();
    final settingViewModel = context.read<SettingViewModel>();

    await settingViewModel.initSetting();
    await mainViewModel.getFolders();

    // 広告削除済みかどうか
    final managerViewModel = context.read<ManagerViewModel>();
    await managerViewModel.initInAppPurchase();

    return true;
  }

  _goToPhotoList(BuildContext context, AssetPathEntity folder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoListScreen(folder: folder)),
    );
  }

  _openSettingScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingScreen()),
    );
  }
}
