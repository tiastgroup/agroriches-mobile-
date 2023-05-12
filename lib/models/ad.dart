import 'package:cloud_firestore/cloud_firestore.dart';

class AdModel {
  String name;
  String imageUrl;
  String siteUrl;

  AdModel({required this.name, required this.imageUrl, required this.siteUrl});

  factory AdModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return AdModel(
      name: d['name'],
      imageUrl: d['imageUrl'],
      siteUrl: d['siteUrl'],
    );
  }
}
