import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import '../../../utils/functions.dart';

class ExifValue extends StatelessWidget {
  const ExifValue({required this.value, this.textColor = Colors.white});
  final String value;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return AutoSizeText(
        value,
      style: TextStyle(
        fontSize: getBaseFontSize(context, screenSize),
        color: textColor,
      ),
      maxLines: 2,
    );
  }
}
