import 'package:cloud_firestore/cloud_firestore.dart';

class PodcastModel {
  late String podcastID;
  late String author;
  late String title;
  late String imageUrl;
  late int duration;
  late String podcastUrl;
  late Timestamp createdAt;
  late Timestamp updatedAt;

  PodcastModel(
      {required this.podcastID,
      required this.author,
      required this.title,
      required this.imageUrl,
      required this.podcastUrl,
      required this.duration,
      required this.createdAt,
      required this.updatedAt});

  factory PodcastModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return PodcastModel(
      podcastID: snapshot.id,
      author: d["author"],
      title: d["title"],
      imageUrl: d["imageUrl"],
      duration: d["duration"],
      podcastUrl: d["podcastUrl"],
      createdAt: d["createdAt"],
      updatedAt: d["updatedAt"],
    );
  }

  // PodcastModel.fromPodcastDocumentSnapshot(
  //     {required DocumentSnapshot documentSnapshot}) {
  //   podcastID = documentSnapshot.id;
  //   author = documentSnapshot["author"];
  //   title = documentSnapshot["title"];
  //   length = documentSnapshot["length"];
  //   imageUrl = documentSnapshot["imageUrl"];
  //   duration = documentSnapshot["duration"];
  //   podcastUrl = documentSnapshot["podcastUrl"];
  //   createdAt = documentSnapshot["createdAt"];
  //   updatedAt = documentSnapshot["updatedAt"];
  // }
}
