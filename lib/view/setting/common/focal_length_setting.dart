import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../utils/style.dart';
import '../../../view_models/setting_view_model.dart';

class FocalLengthSettings extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Consumer<SettingViewModel>(
        builder: (context, settingViewModel, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /////////////////////
              // タイトル
              /////////////////////
              Container(
                padding:EdgeInsets.only(left: 24.0, bottom: 12),
                child: Text(
                    S.of(context).focalLengthType,
                    style: TextStyle(
                      fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 20 : 16,
                      fontWeight: FontWeight.bold,
                      color: kBase1TextColor,
                    )
                ),
              ),
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(left: 16, right: 16),
                child: CupertinoSlidingSegmentedControl(
                  thumbColor: Colors.orange[400]!,
                  backgroundColor: kListTileDarkColor,
                  padding: EdgeInsets.only(top: 8, bottom: 8, right: 8, left: 8),
                  children: {
                    0: buildSegment(S.of(context).actualFocalLength, settingViewModel.settings.focalLengthType == 0, screenSize),
                    1: buildSegment(S.of(context).focalLengthIn35mm, settingViewModel.settings.focalLengthType == 1, screenSize)
                  },
                  onValueChanged: (int? value) {
                    settingViewModel.setFocalLengthType(value);
                  },
                  groupValue: settingViewModel.settings.focalLengthType,
                ),
              ),
            ],
          );
        }
    );

  }

  Widget buildSegment(String text, bool isActive, Size screenSize) => Container(
    padding: EdgeInsets.all(8),
    child: Text(
      text,
      style: TextStyle(
          fontSize : (screenSize.width > 700 && screenSize.height > 1000) ? 20 : 16,
          color: Colors.white,
      ),
    ),
  );
}
