import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:launch_app_store/launch_app_store.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../utils/constants.dart';
import '../../../utils/style.dart';
import '../../../view_models/manager_view_model.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding:EdgeInsets.only(left: 24.0, bottom: 12),
          child: Text(
              S.of(context).aboutTheApp,
              style: TextStyle(
                  fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 20 : 16,
                  fontWeight: FontWeight.bold,
                color: kBase1TextColor,
              )
          ),
        ),
        Container(
          margin: EdgeInsets.only(left:16, right: 16, bottom: 16),
          decoration: BoxDecoration(
              color: kListTileDarkColor,
              borderRadius: BorderRadius.all(Radius.circular(6))
          ),
          child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              // 問い合わせ
              ListTile(
                  title: AutoSizeText(
                    S.of(context).commentsOrSuggestions,
                    style: TextStyle(
                      fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                        color: kBase1TextColor
                    ),
                  ),
                  leading: FaIcon(FontAwesomeIcons.envelope),
                  contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                  onTap: () => sendEmail(context)
              ),
              Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(height: 0, color: Colors.grey)
              ),
              // レビュー
              ListTile(
                title: AutoSizeText(
                  S.of(context).writeReview,
                  style: TextStyle(
                    fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                      color: kBase1TextColor
                  ),
                ),
                leading: FaIcon(FontAwesomeIcons.star),
                contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                onTap: () {
                  LaunchReview.launch(
                    androidAppId: "com.naoyaono.urine_log",
                    iOSAppId: "6449355854",
                  );
                },
              ),
              Container(
                  margin: EdgeInsets.only(left: 12, right: 12),
                  child: Divider(height: 0, color: Colors.grey)
              ),
              // 支援
              ListTile(
                title: AutoSizeText(
                  S.of(context).supportDeveloper,
                  style: TextStyle(
                      fontSize: (screenSize.width > 700 && screenSize.height > 1000) ? 18 : 16,
                      color: kBase1TextColor
                  ),
                ),
                leading: Icon(Icons.favorite),
                contentPadding: EdgeInsets.only(left: 16, top: 4, bottom: 4, right: 16),
                onTap: () => _donate(context),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ////////////////////
  // メール送信
  ///////////////////
  void sendEmail(BuildContext context) async{
    final Email email = Email(
      body: S.of(context).messageEmail,
      subject: S.of(context).subject,
      recipients: ['naoya.ono.app@gmail.com'],
    );
    await FlutterEmailSender.send(email);
  }

  ////////////////////
  // 投げ銭
  ///////////////////
  _donate(BuildContext context) {
    final managerViewModel = Provider.of<ManagerViewModel>(context, listen:false);
    managerViewModel.makePurchase(PurchaseMode.DONATE);
  }
}
