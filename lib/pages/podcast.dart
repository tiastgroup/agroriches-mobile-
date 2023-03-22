import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:news_app/blocs/podcast_bloc.dart';
import 'package:news_app/models/podcast.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/widgets/podcast_player.dart';
import 'package:news_app/widgets/podcast_widget.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

final miniPlayerControllerProvider = MiniplayerController();

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();

  static fromFirestore(DocumentSnapshot<Object?> e) {}
}

class _PodcastState extends State<Podcast> with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _playerMinHeight = 60.0;

  bool isPlaying = false;
  bool showMiniPlayer = true;

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
    // final miniPlayerController = miniPlayerControllerProvider;

    // miniPlayerController.animateToHeight(state: PanelState.MAX);
    PodcastModel selectedPodcast = cb.data.first;

    return Scaffold(
        appBar: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          title: Text("Podcast").tr(),
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
                : Stack(children: [
                    ListView.separated(
                      controller: controller,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 10),
                      itemCount: cb.data.length != 0 ? cb.data.length + 1 : 10,
                      itemBuilder: (_, int index) {
                        if (index < cb.data.length) {
                          return GestureDetector(
                              child:
                                  PodcastWidget(podcastDetails: cb.data[index]),
                              onTap: () {
                                setState(() {
                                  showMiniPlayer = true;
                                  // selectedPodcast = cb.data[index];
                                });
                              });
                        }
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
                    !showMiniPlayer
                        ? const SizedBox.shrink()
                        : SlidingUpPanel(
                            minHeight: _playerMinHeight,
                            maxHeight:
                                MediaQuery.of(context).size.height * 0.68,
                            collapsed: Container(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                child: Column(children: [
                                  Row(children: [
                                    Image.network(
                                      'https://picsum.photos/250?image=9',

                                      // selectedPodcast.imageUrl,
                                      height: _playerMinHeight - 4.0,
                                      width: 120.0,
                                      fit: BoxFit.cover,
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 1.0,
                                            left: 8.0,
                                            right: 8.0,
                                            bottom: 8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Flexible(
                                              child: Text(
                                                selectedPodcast.title,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                              ),
                                            ),
                                            Flexible(
                                              child: Text(
                                                selectedPodcast.author,
                                                overflow: TextOverflow.ellipsis,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall!
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    isPlaying
                                        ? IconButton(
                                            icon: const Icon(Icons.play_arrow),
                                            onPressed: () {
                                              setState(() {
                                                isPlaying = !isPlaying;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.pause),
                                            onPressed: () {
                                              setState(() {
                                                print(isPlaying);
                                                print("daquiver");
                                                isPlaying = !isPlaying;
                                                print(isPlaying);
                                              });
                                            },
                                          ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          showMiniPlayer = false;
                                          // selectedPodcast = null;
                                        });
                                      },
                                    ),
                                  ]),
                                ])),
                            panel: PodcastPlayer(),
                          ),

                    //   !showMiniPlayer
                    //       ? const SizedBox.shrink()
                    //       : Miniplayer(
                    //           controller: miniPlayerController,
                    //           minHeight: _playerMinHeight,
                    //           maxHeight:
                    //               MediaQuery.of(context).size.height * 0.68,
                    //           builder: (height, percentage) {
                    //             if (showMiniPlayer == false) {
                    //               return const SizedBox.shrink();
                    //             }

                    //             if (percentage == 1.0) {
                    //               return PodcastPlayer();
                    //             }

                    //             return Container(
                    //               color:
                    //                   Theme.of(context).scaffoldBackgroundColor,
                    //               child: Column(
                    //                 children: [
                    //                   Row(
                    //                     children: [
                    //                       Image.network(
                    //                         'https://picsum.photos/250?image=9',

                    //                         // selectedPodcast.imageUrl,
                    //                         height: _playerMinHeight - 4.0,
                    //                         width: 120.0,
                    //                         fit: BoxFit.cover,
                    //                       ),
                    //                       Expanded(
                    //                         child: Padding(
                    //                           padding: const EdgeInsets.only(
                    //                               top: 1.0,
                    //                               left: 8.0,
                    //                               right: 8.0,
                    //                               bottom: 8.0),
                    //                           child: Column(
                    //                             crossAxisAlignment:
                    //                                 CrossAxisAlignment.start,
                    //                             mainAxisSize: MainAxisSize.min,
                    //                             children: [
                    //                               Flexible(
                    //                                 child: Text(
                    //                                   selectedPodcast.title,
                    //                                   overflow:
                    //                                       TextOverflow.ellipsis,
                    //                                   style: Theme.of(context)
                    //                                       .textTheme
                    //                                       .bodySmall!
                    //                                       .copyWith(
                    //                                         color: Colors.black,
                    //                                         fontWeight:
                    //                                             FontWeight.w500,
                    //                                       ),
                    //                                 ),
                    //                               ),
                    //                               Flexible(
                    //                                 child: Text(
                    //                                   selectedPodcast.author,
                    //                                   overflow:
                    //                                       TextOverflow.ellipsis,
                    //                                   style: Theme.of(context)
                    //                                       .textTheme
                    //                                       .bodySmall!
                    //                                       .copyWith(
                    //                                           fontWeight:
                    //                                               FontWeight
                    //                                                   .w500),
                    //                                 ),
                    //                               ),
                    //                             ],
                    //                           ),
                    //                         ),
                    //                       ),
                    //                       isPlaying
                    //                           ? IconButton(
                    //                               icon: const Icon(
                    //                                   Icons.play_arrow),
                    //                               onPressed: () {
                    //                                 setState(() {
                    //                                   isPlaying = !isPlaying;
                    //                                 });
                    //                               },
                    //                             )
                    //                           : IconButton(
                    //                               icon: const Icon(Icons.pause),
                    //                               onPressed: () {
                    //                                 setState(() {
                    //                                   print(isPlaying);
                    //                                   print("daquiver");
                    //                                   isPlaying = !isPlaying;
                    //                                   print(isPlaying);
                    //                                 });
                    //                               },
                    //                             ),
                    //                       IconButton(
                    //                         icon: const Icon(Icons.close),
                    //                         onPressed: () {
                    //                           setState(() {
                    //                             showMiniPlayer = false;
                    //                             // selectedPodcast = null;
                    //                           });
                    //                         },
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   const LinearProgressIndicator(
                    //                     value: 0.4,
                    //                     valueColor:
                    //                         AlwaysStoppedAnimation<Color>(
                    //                       Colors.black,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             );
                    //           },
                    //         ),
                    // ],
                  ])));
  }

  @override
  bool get wantKeepAlive => true;
}
