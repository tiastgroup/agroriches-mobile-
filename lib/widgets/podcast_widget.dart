import 'package:flutter/material.dart';
import 'package:news_app/models/podcast.dart';

class PodcastWidget extends StatelessWidget {
  final PodcastModel podcastDetails;
  const PodcastWidget({Key? key, required this.podcastDetails})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CircleAvatar(
          child: Icon(Icons.account_box),
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
                    Text(podcastDetails.duration.toString())
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
