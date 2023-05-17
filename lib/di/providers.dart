import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../view_models/main_view_model.dart';


//① アプリで使うProvider全て
List<SingleChildWidget> globalProviders = [
  ...independentModels,
  ...dependentModels,
  ...viewModels
];

//② 他のどのクラスにも依存していないモデル
List<SingleChildWidget> independentModels =[
  // Provider<DatabaseManager>(
  //   create: (_) => DatabaseManager(),
  // ),
  // Provider<SharedPrefsRepository>(
  //   create: (context) => SharedPrefsRepository(),
  // ),
  // Provider<AdManager>(
  //   create: (context) => AdManager(),
  // ),
  // Provider<InAppPurchaseManager>(
  //   create: (context) => InAppPurchaseManager(),
  // ),
];

//③ ②で作成したクラスに依存しているモデル
List<SingleChildWidget> dependentModels = [
  // ProxyProvider<DatabaseManager, RecordRepository>(
  //   update: (_, dbManager, repo) => RecordRepository(dbManager: dbManager),
  // ),
];

//④ Viewodel一覧（②、③で登録したモデルは使える）
List<SingleChildWidget> viewModels =[
  ChangeNotifierProvider<MainViewModel>(
      create: (context) => MainViewModel()
  ),
  // ChangeNotifierProvider<SettingViewModel>(
  //   create: (context) => SettingViewModel(
  //     sharedPrefsRepository: context.read<SharedPrefsRepository>(),
  //   ),
  // ),
  // ChangeNotifierProvider<RecordViewModel>(
  //   create: (context) => RecordViewModel(
  //     recordRepository: context.read<RecordRepository>(),
  //     sharedPrefsRepository: context.read<SharedPrefsRepository>(),
  //   ),
  // ),
  // ChangeNotifierProvider<MemberViewModel>(
  //   create: (context) => MemberViewModel(
  //     memberRepository: context.read<MemberRepository>(),
  //     sharedPrefsRepository: context.read<SharedPrefsRepository>(),
  //   ),
  // ),
  // ChangeNotifierProvider(create: (context) => ManagerViewModel(
  //   adManager: context.read<AdManager>(),
  //   inAppPurchaseManager: context.read<InAppPurchaseManager>(),
  // )
  // ),
  // ChangeNotifierProvider<BackupViewModel>(
  //     create: (context) => BackupViewModel(
  //         userRepository: Provider.of<UserRepository>(context, listen:false)
  //     )
  // ),
];