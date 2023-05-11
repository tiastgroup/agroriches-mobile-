import 'package:cloud_firestore/cloud_firestore.dart';

class VolumeModel {
  String name;
  String thumbnailUrl;

  VolumeModel({
    required this.name,
    required this.thumbnailUrl,
  });

  factory VolumeModel.fromFirestore(DocumentSnapshot snapshot) {
    Map d = snapshot.data() as Map<dynamic, dynamic>;
    return VolumeModel(
      name: d['name'],
      thumbnailUrl: d['thumbnailUrl'],
    );
  }
}
