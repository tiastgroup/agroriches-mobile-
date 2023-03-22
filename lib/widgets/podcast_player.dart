import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class PodcastPlayer extends StatefulWidget {
  const PodcastPlayer({Key? key}) : super(key: key);

  @override
  State<PodcastPlayer> createState() => _PodcastPlayer();
}

class _PodcastPlayer extends State<PodcastPlayer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network('https://picsum.photos/250?image=9'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Podcast Title",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                Text(
                  "Podcast Author",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 30),
                LinearPercentIndicator(
                  lineHeight: 5,
                  percent: 0.4,
                  progressColor: Colors.black,
                  backgroundColor: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('0:00'), Text('4:22')],
                ),
                SizedBox(
                  height: 80,
                  child: Row(
                    children: const [
                      Expanded(
                          child: Icon(
                        Icons.shuffle,
                        size: 20,
                      )),
                      Expanded(
                          child: Icon(
                        Icons.skip_previous,
                        size: 20,
                      )),
                      Expanded(
                        flex: 2,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Icon(
                              Icons.play_arrow,
                              size: 20,
                            )),
                      ),
                      Expanded(
                          child: Icon(
                        Icons.skip_next,
                        size: 20,
                      )),
                      Expanded(
                          child: Icon(
                        Icons.repeat,
                        size: 20,
                      )),
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
