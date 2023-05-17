import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class PhotoDetailScreen extends StatelessWidget {
  const PhotoDetailScreen({required this.photo});
  final Uint8List photo;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Image.memory(
                photo,
                fit: BoxFit.contain,
              ),
            ],
          ),
        ),
      )
    );
  }
}
