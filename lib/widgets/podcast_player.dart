import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:news_app/blocs/podcast_bloc.dart';
import 'package:news_app/models/podcast.dart';
import 'package:news_app/widgets/podcast_player_manager.dart';
import 'package:news_app/widgets/position_data.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PodcastPlayer extends StatefulWidget {
  const PodcastPlayer(
      {Key? key, required this.podcastDetails, required this.audioPlayer})
      : super(key: key);
  final PodcastModel podcastDetails;
  final AudioPlayer audioPlayer;

  @override
  State<PodcastPlayer> createState() => _PodcastPlayer();
}

class _PodcastPlayer extends State<PodcastPlayer> {
  final _pageManager = PageManager();
  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          widget.audioPlayer.positionStream,
          widget.audioPlayer.bufferedPositionStream,
          widget.audioPlayer.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position: position,
              bufferedPosition: bufferedPosition,
              duration: duration ?? Duration.zero));

  @override
  Widget build(BuildContext context) {
    final cb = context.watch<PodcastBloc>();

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                widget.podcastDetails.imageUrl,
                fit: BoxFit.cover,
                width: 250,
              )),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    widget.podcastDetails.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    widget.podcastDetails.author,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                StreamBuilder<PositionData>(
                    stream: _positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;

                      return ProgressBar(
                        onSeek: (value) {
                          widget.audioPlayer.seek(value);
                        },
                        total: positionData?.duration ?? Duration.zero,
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                      );
                    }),
                SizedBox(
                  height: 80,
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            widget.audioPlayer.setShuffleModeEnabled(
                                !widget.audioPlayer.shuffleModeEnabled);
                          });
                        },
                        child: widget.audioPlayer.shuffleModeEnabled
                            ? Icon(
                                Icons.shuffle,
                                size: 20,
                              )
                            : Icon(Icons.shuffle, size: 20, color: Colors.grey),
                      )),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (widget.audioPlayer.hasPrevious) {
                                    cb.setCurrentPodcast(cb.data[
                                        widget.audioPlayer.previousIndex!]);
                                    widget.audioPlayer.seekToPrevious();
                                  }
                                });
                              },
                              child: widget.audioPlayer.hasPrevious
                                  ? Icon(
                                      Icons.skip_previous,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.skip_previous,
                                      size: 20,
                                      color: Colors.grey,
                                    ))),
                      cb.isPlaying
                          ? Expanded(
                              flex: 2,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cb.isPlaying = !cb.isPlaying;
                                      });
                                      widget.audioPlayer.pause();
                                    },
                                    child: Icon(
                                      Icons.pause,
                                      size: 20,
                                    ),
                                  )),
                            )
                          : Expanded(
                              flex: 2,
                              child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        cb.isPlaying = !cb.isPlaying;
                                      });
                                      widget.audioPlayer.play();
                                    },
                                    child: Icon(
                                      Icons.play_arrow,
                                      size: 20,
                                    ),
                                  )),
                            ),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.audioPlayer.hasNext) {
                              cb.setCurrentPodcast(
                                  cb.data[widget.audioPlayer.nextIndex!]);
                              widget.audioPlayer.seekToNext();
                            }
                          });
                        },
                        child: widget.audioPlayer.hasNext
                            ? Icon(
                                Icons.skip_next,
                                size: 20,
                              )
                            : Icon(
                                Icons.skip_next,
                                size: 20,
                                color: Colors.grey,
                              ),
                      )),
                      Expanded(
                          child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.audioPlayer.loopMode == LoopMode.one
                                      ? widget.audioPlayer
                                          .setLoopMode(LoopMode.off)
                                      : widget.audioPlayer
                                          .setLoopMode(LoopMode.one);
                                });
                              },
                              child: widget.audioPlayer.loopMode == LoopMode.one
                                  ? Icon(
                                      Icons.repeat_one,
                                      size: 20,
                                    )
                                  : Icon(
                                      Icons.repeat,
                                      size: 20,
                                    ))),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
