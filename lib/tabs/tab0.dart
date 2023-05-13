import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_app/blocs/ads_bloc.dart';
import 'package:news_app/blocs/featured_bloc.dart';
import 'package:news_app/blocs/popular_articles_bloc.dart';
import 'package:news_app/blocs/recent_articles_bloc.dart';
import 'package:news_app/models/ad.dart';
import 'package:news_app/models/popup.dart';
import 'package:news_app/utils/urls.dart';
import 'package:news_app/widgets/featured.dart';
import 'package:news_app/widgets/pop_up_banner.dart';
import 'package:news_app/widgets/popular_articles.dart';
import 'package:news_app/widgets/recent_articles.dart';
import 'package:news_app/widgets/search_bar.dart';
import 'package:provider/provider.dart';

class Tab0 extends StatefulWidget {
  Tab0({Key? key}) : super(key: key);

  @override
  _Tab0State createState() => _Tab0State();
}

class _Tab0State extends State<Tab0> {
  Timer? _timer;
  int _alertDialogCount = 0;
  AdModel adBanner = AdModel(
      name: "Test Ad",
      imageUrl: "https://picsum.photos/200",
      siteUrl: "https://example.com");
  PopupModel popupBanner = PopupModel(
    name: "Test Popup",
    imageUrl: "https://picsum.photos/200",
    siteUrl: "https://example.com",
  );
  @override
  void initState() {
    super.initState();

    initialize();
    scheduleAlertDialog(Duration(seconds: 10));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final adBloc = context.watch<AdBloc>();

    return RefreshIndicator(
      onRefresh: () async {
        context.read<FeaturedBloc>().onRefresh();
        context.read<PopularBloc>().onRefresh();
        context.read<RecentBloc>().onRefresh(mounted);
      },
      child: SingleChildScrollView(
        key: PageStorageKey('key0'),
        padding: EdgeInsets.all(0),
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            SearchBar(),
            Featured(),
            RecentArticles(),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: GestureDetector(
                    onTap: () => openUrl(adBanner.siteUrl),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.network(
                        adBanner.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PopularArticles(),
          ],
        ),
      ),
    );
  }

  initialize() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('tiast')
        .doc("liQW0ySs7aqF27PHigIW")
        .get();
    final DocumentSnapshot popupDoc = await FirebaseFirestore.instance
        .collection('popup')
        .doc("Hm93OEsE9OBcNBAAnRup")
        .get();
    final AdModel _adBanner = AdModel.fromFirestore(doc);
    final PopupModel _popupBanner = PopupModel.fromFirestore(popupDoc);

    setState(() {
      adBanner = _adBanner;
      popupBanner = _popupBanner;
    });
  }

  void scheduleAlertDialog(Duration duration) {
    if (popupBanner.imageUrl == "" || popupBanner.siteUrl == "") return;

    if (_alertDialogCount < 2) {
      _timer = Timer(duration, () {
        showCustomAlertDialog(
            context, popupBanner.siteUrl, popupBanner.imageUrl);
        _alertDialogCount++;

        if (_alertDialogCount == 1) {
          scheduleAlertDialog(Duration(minutes: 5));
        }
      });
    } else {
      _timer?.cancel();
    }
  }
}
