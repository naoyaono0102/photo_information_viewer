import 'dart:io';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_information_viewer/view/home/photo_list_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

import '../../view_models/main_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<bool>? isFolderLoaded;

  @override
  void initState() {
    isFolderLoaded = loadFolders();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: FutureBuilder(
          future: isFolderLoaded,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Consumer<MainViewModel>(
                  builder: (context, mainViewModel, child) {
                    return SafeArea(
                      child: ListView.builder(
                        itemCount: mainViewModel.folderList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final AssetPathEntity folder = mainViewModel.folderList[index];
                          // print(folder);

                          return ListTile(
                            title: AutoSizeText(folder.name),
                            trailing: Icon(Icons.chevron_right),
                            onTap: () => _goToPhotoList(context, folder),
                          );
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
    );
  }

  Future<bool>? loadFolders() async {
    final mainViewModel = context.read<MainViewModel>();
    await mainViewModel.getFolders();
    return true;
  }

  _goToPhotoList(BuildContext context, AssetPathEntity folder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PhotoListScreen(folder: folder)),
    );
  }
}
