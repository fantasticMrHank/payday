import 'package:payday/ads.dart';
import 'package:payday/pay.dart';
import 'package:payday/profile.dart';
import 'package:payday/shared/singleLink.dart';
import 'package:flutter/material.dart';

class PayDrawer extends StatelessWidget {
  final String currentScreen;
  PayDrawer(this.currentScreen);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.amber,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            SingleLink(
              'View Ads',
              'ads',
              currentScreen,
              AdsScreen.id,
            ),
            SingleLink(
              'User Account',
              'account',
              currentScreen,
              ProfileScreen.id,
            ),
            // SingleLink(
            //   'My Balance',
            //   'balance',
            //   currentScreen,
            //   BalanceScreen.id,
            // ),
            SingleLink(
              'Get Paid!',
              'pay',
              currentScreen,
              PayScreen.id,
            ),
          ],
        ),
      ),
    );
  }
}
