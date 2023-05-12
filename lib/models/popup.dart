import 'package:cloud_firestore/cloud_firestore.dart';

class PopupModel {
  String name;
  String imageUrl;
  String siteUrl;

  PopupModel(
      {required this.name, required this.imageUrl, required this.siteUrl});

  factory PopupModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return PopupModel(
      name: d['name'],
      imageUrl: d['imageUrl'],
      siteUrl: d['siteUrl'],
    );
  }
}
