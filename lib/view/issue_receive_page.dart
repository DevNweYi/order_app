import 'package:flutter/material.dart';

import '../value/app_color.dart';
import '../value/app_string.dart';
import '../widget/title_text.dart';

class IssueReceivePage extends StatefulWidget {
  const IssueReceivePage({super.key});

  @override
  State<IssueReceivePage> createState() => _IssueReceivePageState();
}

class _IssueReceivePageState extends State<IssueReceivePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: AppColor.primary_700,
            title: const TitleText(
              text: AppString.help,
              color: AppColor.white,
            )),
            body: Padding(
              padding: const EdgeInsets.only(top:50,left: 10,right: 10),
              child: Center(
                child: Column(
                  children: [
                    TitleText(
                      text: AppString.receive_your_issue,
                      color: AppColor.primary_700,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 20,),
                    Text(AppString.solve_issue,
                      style: Theme.of(context).textTheme.bodyText1),
                  ],
                ),
              ),
            ),
    );
  }
}