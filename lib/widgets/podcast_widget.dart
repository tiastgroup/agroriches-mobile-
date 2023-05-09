import 'package:flutter/material.dart';
import 'package:news_app/blocs/podcast_bloc.dart';
import 'package:news_app/models/podcast.dart';
import 'package:provider/provider.dart';

class PodcastWidget extends StatelessWidget {
  final PodcastModel podcastDetails;
  PodcastWidget({Key? key, required this.podcastDetails}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cb = context.watch<PodcastBloc>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          backgroundImage: NetworkImage(podcastDetails.imageUrl),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(podcastDetails.title),
                    cb.currentPodcast != null
                        ? cb.currentPodcast!.title == podcastDetails.title
                            // If the titles match, check if the podcast is playing
                            ? cb.isPlaying
                                // If the podcast is playing, show a pause icon
                                ? Icon(Icons.pause)
                                // If the podcast is not playing, show a play icon
                                : Icon(Icons.play_arrow)
                            // If the titles do not match, show a play icon
                            : Icon(Icons.play_arrow)
                        : Icon(Icons.play_arrow),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Text(podcastDetails.author.toString())
              ],
            ),
          ),
        ),
      ],
    );
  }
}
