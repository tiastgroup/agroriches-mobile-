import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:just_audio/just_audio.dart';
import 'package:news_app/blocs/podcast_bloc.dart';
import 'package:news_app/utils/empty.dart';
import 'package:news_app/utils/loading_cards.dart';
import 'package:news_app/widgets/podcast_player.dart';
import 'package:news_app/widgets/podcast_widget.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Podcast extends StatefulWidget {
  const Podcast({Key? key}) : super(key: key);

  @override
  State<Podcast> createState() => _PodcastState();

  static fromFirestore(DocumentSnapshot<Object?> e) {}
}

class _PodcastState extends State<Podcast> with AutomaticKeepAliveClientMixin {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  static const double _playerMinHeight = 60.0;

  bool showMiniPlayer = false;

  final player = AudioPlayer();

  ScrollController? controller;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 0)).then((value) {
      controller = new ScrollController()..addListener(_scrollListener);
      // context.read<PodcastBloc>().getData(mounted);
      initAudios();
    });
  }

  void initAudios() async {
    await context.read<PodcastBloc>().getData(mounted);
    final cb = context.read<PodcastBloc>();

    List<AudioSource> podcastUrls = cb.data.map((podcast) {
      return AudioSource.uri(
        Uri.parse(podcast.podcastUrl),
      );
    }).toList();

    await player.setAudioSource(
        ConcatenatingAudioSource(
            // Start loading next item just before reaching it
            useLazyPreparation: true,

            // Specify the playlist items
            children: podcastUrls),
        initialPosition: Duration.zero);
    player.setLoopMode(LoopMode.one);
  }

  @override
  void dispose() {
    controller!.removeListener(_scrollListener);
    super.dispose();
    player.dispose();
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
                    GridView.builder(
                      controller: controller,
                      padding: EdgeInsets.only(
                          left: 10, right: 10, top: 15, bottom: 10),
                      itemCount: cb.data.length != 0 ? cb.data.length + 1 : 10,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            2, // Change this value to adjust the number of columns
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio:
                            1.0, // Change this value to adjust the aspect ratio
                      ),
                      itemBuilder: (_, int index) {
                        if (index < cb.data.length) {
                          return GestureDetector(
                            child: PodcastWidget(
                              podcastDetails: cb.data[index],
                            ),
                            onTap: () async {
                              if (player.playing) {
                                player.pause();
                                setState(() {
                                  cb.isPlaying = false;
                                });
                                return;
                              }
                              player.seek(Duration.zero, index: index);
                              player.play();

                              setState(() {
                                cb.isPlaying = true;
                                cb.setCurrentPodcast(cb.data[index]);
                                showMiniPlayer = true;
                              });
                            },
                          );
                        }
                        return Opacity(
                          opacity: cb.isLoading ? 1.0 : 0.0,
                          child: cb.lastVisible == null
                              ? LoadingCard(height: null)
                              : Center(
                                  child: SizedBox(
                                    width: 32.0,
                                    height: 32.0,
                                    child: new CupertinoActivityIndicator(),
                                  ),
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
                                      cb.currentPodcast!.imageUrl,
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
                                                cb.currentPodcast!.title,
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
                                                cb.currentPodcast!.author,
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
                                    cb.isPlaying
                                        ? IconButton(
                                            icon: const Icon(Icons.pause),
                                            onPressed: () async {
                                              player.pause();
                                              setState(() {
                                                cb.isPlaying = !cb.isPlaying;
                                              });
                                            },
                                          )
                                        : IconButton(
                                            icon: const Icon(Icons.play_arrow),
                                            onPressed: () {
                                              player.play();
                                              setState(() {
                                                cb.isPlaying = !cb.isPlaying;
                                              });
                                            },
                                          ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () {
                                        setState(() {
                                          player.stop();
                                          showMiniPlayer = false;
                                          cb.isPlaying = false;
                                          cb.setCurrentPodcast(null);
                                        });
                                      },
                                    ),
                                  ]),
                                ])),
                            panel: PodcastPlayer(
                              podcastDetails: cb.currentPodcast!,
                              audioPlayer: player,
                            ),
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
