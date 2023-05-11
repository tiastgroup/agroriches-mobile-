// import 'dart:html';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:get/get.dart';
import 'package:news_app/blocs/newsletter_bloc.dart';
import 'package:news_app/models/newsletter.dart';
import 'package:news_app/pages/newsletter2.dart';
import 'package:news_app/utils/cached_image_with_dark.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:provider/provider.dart';

import 'pdf_view.dart';

class Newsletter extends StatefulWidget {
  Newsletter({Key? key}) : super(key: key);

  @override
  _NewsletterState createState() => _NewsletterState();

  static fromFirestore(DocumentSnapshot<Object?> e) {}
}

class _NewsletterState extends State<Newsletter>
    with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<NewsletterBloc>().getVolumeData(mounted);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<NewsletterBloc>();

    if (!db.isVolumeLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<NewsletterBloc>().setVolumeLoading(true);
        context.read<NewsletterBloc>().getVolumeData(mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final cb = context.watch<NewsletterBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: const Text('Agroriches Newsletters').tr(),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Feather.rotate_cw,
              size: 22,
            ),
            onPressed: () {
              context.read<NewsletterBloc>().onVolumeRefresh(mounted);
            },
          )
        ],
      ),
      body: RefreshIndicator(
        child: cb.hasVolumeData == false
            ? ListView(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.35,
                  ),
                  EmptyPage(
                      icon: Feather.clipboard,
                      message: 'no Volume found',
                      message1: ''),
                ],
              )
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 30,
                  thickness: 1,
                ),
                controller: controller,
                padding:
                    EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 15),
                itemCount:
                    cb.volumeData.length != 0 ? cb.volumeData.length + 1 : 10,
                itemBuilder: (_, int index) {
                  if (index < cb.volumeData.length) {
                    return GestureDetector(
                      onTap: () {
                        final String volumeNum =
                            cb.volumeData[index].name.split(' ')[1];
                        nextScreen(
                            context, Newsletter2(volumeNumber: volumeNum));
                      },
                      child: ListTile(
                        leading: SizedBox(
                          width: 60,
                          child: CachedNetworkImage(
                            imageUrl: cb.volumeData[index].thumbnailUrl,
                            height: MediaQuery.of(context).size.height,
                            placeholder: (context, url) =>
                                Container(color: Colors.grey[300]),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[300],
                              child: Icon(Icons.error),
                            ),
                          ),
                        ),
                        title: Text(cb.volumeData[index].name.toString()),
                        trailing: Icon(Icons.arrow_forward_ios, size: 20),
                      ),
                    );
                  }
                  return Opacity(
                    opacity: cb.isVolumeLoading ? 1.0 : 0.0,
                    child: cb.lastVolumeVisible == null
                        ? LoadingCard(height: null)
                        : Center(
                            child: SizedBox(
                                width: 32.0,
                                height: 32.0,
                                child: new CupertinoActivityIndicator()),
                          ),
                  );
                },
              ),
        onRefresh: () async {
          context.read<NewsletterBloc>().onVolumeRefresh(mounted);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class ItemList extends StatelessWidget {
  final NewsletterModel d;
  const ItemList({Key? key, required this.d}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    blurRadius: 10,
                    offset: Offset(0, 3),
                    color: Theme.of(context).shadowColor)
              ]),
          child: Card(
            child: Stack(
              children: [
                Hero(
                  tag: 'newsletter${d.timestamp}',
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: CustomCacheImageWithDarkFilterBottom(
                        imageUrl: d.thumbnailUrl, radius: 5.0),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    margin: EdgeInsets.only(left: 15, bottom: 15, right: 10),
                    child: Text(
                      d.name!,
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        onTap: () {
          Get.to(() => PdfView(d: d));
        });
  }
}
