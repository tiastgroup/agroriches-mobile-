import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/podcast_bloc.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/widgets/podcast_widget.dart';
import 'package:provider/provider.dart';

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();

  static fromFirestore(DocumentSnapshot<Object?> e) {}
}

class _PodcastState extends State<Podcast> with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      context.read<PodcastBloc>().getData(mounted);
    });
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
  }

  void _scrollListener() {
    final db = context.read<PodcastBloc>();

    if (!db.isLoading) {
      if (controller!.position.pixels == controller!.position.maxScrollExtent) {
        context.read<PodcastBloc>().setLoading(true);
        context.read<PodcastBloc>().getData(mounted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cb = context.watch<PodcastBloc>();

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text("podcast").tr(),
          elevation: 0,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Feather.rotate_cw,
                size: 22,
              ),
              onPressed: () {
                context.read<PodcastBloc>().onRefresh(mounted);
              },
            )
          ],
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            context.read<PodcastBloc>().onRefresh(mounted);
          },
          child: cb.hasData == false
              ? ListView(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                    EmptyPage(
                        icon: Feather.clipboard,
                        message: 'no podcast found'.tr(),
                        message1: ''),
                  ],
                )
              : ListView.separated(
                  controller: controller,
                  separatorBuilder: (context, index) => SizedBox(height: 10),
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 15, bottom: 10),
                  itemCount: cb.data.length != 0 ? cb.data.length + 1 : 10,
                  itemBuilder: (_, int index) {
                    if (index < cb.data.length) {
                      return PodcastWidget(podcastDetails: cb.data[index]);
                    }
                    ;
                    return Opacity(
                      opacity: cb.isLoading ? 1.0 : 0.0,
                      child: cb.lastVisible == null
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
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
