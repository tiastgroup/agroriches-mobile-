import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:news_app/blocs/ads_bloc.dart';
import 'package:news_app/blocs/bookmark_bloc.dart';
import 'package:news_app/blocs/sign_in_bloc.dart';
import 'package:news_app/blocs/theme_bloc.dart';
import 'package:news_app/models/ad.dart';
import 'package:news_app/models/article.dart';
import 'package:news_app/models/custom_color.dart';
import 'package:news_app/pages/comments.dart';
import 'package:news_app/services/app_service.dart';
import 'package:news_app/utils/cached_image.dart';
import 'package:news_app/utils/sign_in_dialog.dart';
import 'package:news_app/utils/urls.dart';
import 'package:news_app/widgets/bookmark_icon.dart';
import 'package:news_app/widgets/html_body.dart';
import 'package:news_app/widgets/love_count.dart';
import 'package:news_app/widgets/love_icon.dart';
import 'package:news_app/widgets/related_articles.dart';
import 'package:news_app/widgets/views_count.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../utils/next_screen.dart';

class VideoArticleDetails extends StatefulWidget {
  final Article? data;
  const VideoArticleDetails({Key? key, required this.data}) : super(key: key);

  @override
  _VideoArticleDetailsState createState() => _VideoArticleDetailsState();
}

class _VideoArticleDetailsState extends State<VideoArticleDetails> {
  double rightPaddingValue = 130;
  late YoutubePlayerController _controller;

  initYoutube() async {
    _controller = YoutubePlayerController(
        initialVideoId: widget.data!.videoID!,
        flags: YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          forceHD: false,
          loop: true,
          controlsVisibleAtStart: false,
          enableCaption: false,
        ));
  }

  void _handleShare() {
    final sb = context.read<SignInBloc>();
    final String _shareTextAndroid =
        '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';
    final String _shareTextiOS =
        '${widget.data!.title}, Check out this app to explore more. App link: https://play.google.com/store/apps/details?id=${sb.packageName}';

    if (Platform.isAndroid) {
      Share.share(_shareTextAndroid);
    } else {
      Share.share(_shareTextiOS);
    }
  }

  handleLoveClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onLoveIconClick(widget.data!.timestamp);
    }
  }

  handleBookmarkClick() {
    bool _guestUser = context.read<SignInBloc>().guestUser;

    if (_guestUser == true) {
      openSignInDialog(context);
    } else {
      context.read<BookmarkBloc>().onBookmarkIconClick(widget.data!.timestamp);
    }
  }

  _initInterstitialAds() {
    final adb = context.read<AdBloc>();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      if (adb.interstitialAdEnabled == true) {
        context.read<AdBloc>().loadAds();
      }
    });
  }

  String imageUrl = 'https://source.unsplash.com/random';

  @override
  void initState() {
    super.initState();
    initialize();
    initYoutube();
    _initInterstitialAds();
    Future.delayed(Duration(milliseconds: 100)).then((value) {
      setState(() {
        rightPaddingValue = 10;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    final sb = context.watch<SignInBloc>();
    final Article d = widget.data!;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        if (Platform.isAndroid) {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
        }
      },
      player: YoutubePlayer(
        controller: _controller,
        aspectRatio: 16 / 9,
        showVideoProgressIndicator: true,
        thumbnail: CustomCacheImage(imageUrl: d.thumbnailImagelUrl, radius: 0),
        topActions: [
          IconButton(
            icon:
                Icon(Icons.keyboard_arrow_left, size: 22, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Spacer(),
          d.sourceUrl == null
              ? Container()
              : IconButton(
                  icon: Icon(Feather.external_link,
                      size: 22, color: Colors.white),
                  onPressed: () =>
                      AppService().openLinkWithCustomTab(context, d.sourceUrl!),
                ),
          IconButton(
            icon: Icon(Icons.share, size: 22, color: Colors.white),
            onPressed: () {
              _handleShare();
            },
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
            body: Column(
          children: [
            SafeArea(top: true, bottom: false, child: player),
            Expanded(
              child: SingleChildScrollView(
                physics: ClampingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 15, 20, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: <Widget>[
                              Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:
                                        context.watch<ThemeBloc>().darkTheme ==
                                                false
                                            ? CustomColor().loadingColorLight
                                            : CustomColor().loadingColorDark,
                                  ),
                                  child: AnimatedPadding(
                                    duration: Duration(milliseconds: 1000),
                                    padding: EdgeInsets.only(
                                        left: 10,
                                        right: rightPaddingValue,
                                        top: 5,
                                        bottom: 5),
                                    child: Text(
                                      d.category!,
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                              Spacer(),
                              IconButton(
                                  icon: BuildLoveIcon(
                                      collectionName: 'contents',
                                      uid: sb.uid,
                                      timestamp: d.timestamp),
                                  onPressed: () {
                                    handleLoveClick();
                                  }),
                              IconButton(
                                  icon: BuildBookmarkIcon(
                                      collectionName: 'contents',
                                      uid: sb.uid,
                                      timestamp: d.timestamp),
                                  onPressed: () {
                                    handleBookmarkClick();
                                  }),
                            ],
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.date_range,
                                  size: 20, color: Colors.grey),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                d.date!,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Icon(CupertinoIcons.timer,
                                  size: 18, color: Colors.grey),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                d.readingTime!,
                                style: TextStyle(
                                    color:
                                        Theme.of(context).secondaryHeaderColor,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            d.title!,
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.6,
                                wordSpacing: 1),
                          ),
                          Divider(
                            color: Theme.of(context).primaryColor,
                            endIndent: 200,
                            thickness: 2,
                            height: 20,
                          ),
                          TextButton.icon(
                            style: ButtonStyle(
                              padding: MaterialStateProperty.resolveWith(
                                  (states) =>
                                      EdgeInsets.only(left: 10, right: 10)),
                              backgroundColor:
                                  MaterialStateProperty.resolveWith((states) =>
                                      Theme.of(context).primaryColor),
                              shape: MaterialStateProperty.resolveWith(
                                  (states) => RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3))),
                            ),
                            icon: Icon(Feather.message_circle,
                                color: Colors.white, size: 20),
                            label: Text('comments',
                                    style: TextStyle(color: Colors.white))
                                .tr(),
                            onPressed: () {
                              nextScreen(context,
                                  CommentsPage(timestamp: d.timestamp));
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              //views feature
                              ViewsCount(
                                article: d,
                              ),
                              SizedBox(
                                width: 20,
                              ),

                              LoveCount(
                                  collectionName: 'contents',
                                  timestamp: d.timestamp),
                            ],
                          ),
                        ],
                      ),
                    ),
                    HtmlBodyWidget(
                      content: d.description!,
                      isIframeVideoEnabled: false,
                      isVideoEnabled: false,
                      isimageEnabled: true,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: GestureDetector(
                            onTap: () => openUrl("https://www.tiastgroup.com"),
                            child: Card(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.network(
                                imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: RelatedArticles(
                          category: d.category,
                          timestamp: d.timestamp,
                          replace: true,
                        )),
                  ],
                ),
              ),
            ),
          ],
        ));
      },
    );
  }

  initialize() async {
    final DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('tiast')
        .doc("liQW0ySs7aqF27PHigIW")
        .get();
    final String _imageUrl = AdModel.fromFirestore(doc).imageUrl;
    setState(() {
      imageUrl = _imageUrl;
    });
  }
}
