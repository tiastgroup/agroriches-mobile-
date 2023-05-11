import 'package:cloud_firestore/cloud_firestore.dart';

class NewsletterModel {
  String? name;
  String? thumbnailUrl;
  String? pdfUrl;
  String? timestamp;
  int? volume;

  NewsletterModel(
      {this.name, this.thumbnailUrl, this.pdfUrl, this.timestamp, this.volume});

  factory NewsletterModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return NewsletterModel(
      name: d['name'],
      thumbnailUrl: d['thumbnail'],
      pdfUrl: d['pdf'],
      timestamp: d['timestamp'],
      volume: d['volume'],
    );
  }
}
