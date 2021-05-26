import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerWidget extends StatefulWidget {
  final AdSize size;
  final String UserID;

  BannerWidget(this.size, this.UserID);
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  late BannerAd _bannerAd;
  final Completer<BannerAd> bannerCompleter = Completer<BannerAd>();
  // TBD how much to pay users per impression
  final double impressionAmount = 0.05;

  void startAddingBalance() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(widget.UserID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      double currentBalance = documentSnapshot.data()!['balance'];

      addBalance(currentBalance);
    });
  }

  void addBalance(double bal) {
    double newBalance = bal + impressionAmount;

    var collectionRef = FirebaseFirestore.instance.collection('users');
    collectionRef.doc(widget.UserID).update({
      'balance': double.parse(newBalance.toStringAsFixed(2)),
    }).then((value) {
      // balance has been updated
    });
  }

  @override
  void initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: BannerAd.testAdUnitId,
      request: AdRequest(),
      size: widget.size,
      listener: AdListener(
        onAdLoaded: (Ad ad) {
          startAddingBalance();
          bannerCompleter.complete(ad as BannerAd);
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          ad.dispose();
          print('$BannerAd failedToLoad: $error');
          bannerCompleter.completeError(error);
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onApplicationExit: (Ad ad) => print('$BannerAd onApplicationExit.'),
      ),
    );
    Future<void>.delayed(Duration(seconds: 1), () => _bannerAd.load());
  }

  @override
  void dispose() {
    super.dispose();
    _bannerAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BannerAd>(
      future: bannerCompleter.future,
      builder: (BuildContext context, AsyncSnapshot<BannerAd> snapshot) {
        Widget child;

        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            child = Container();
            break;
          case ConnectionState.done:
            if (snapshot.hasData) {
              child = AdWidget(ad: _bannerAd);
            } else {
              child = Text('Error loading $BannerAd');
            }
        }

        return Container(
          width: _bannerAd.size.width.toDouble(),
          height: _bannerAd.size.height.toDouble(),
          color: Colors.blueGrey,
          child: child,
        );
      },
    );
  }
}
