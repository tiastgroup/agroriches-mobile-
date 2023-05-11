import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:news_app/models/newsletter.dart';
import 'package:news_app/models/volume.dart';

class NewsletterBloc extends ChangeNotifier {
  DocumentSnapshot? _lastVolumeVisible;
  DocumentSnapshot? get lastVolumeVisible => _lastVolumeVisible;
  DocumentSnapshot? _lastNewsLetterVisible;
  DocumentSnapshot? get lastNewsLetterVisible => _lastNewsLetterVisible;

  bool _isVolumeLoading = true;
  bool get isVolumeLoading => _isVolumeLoading;
  bool _isNewsLetterLoading = true;
  bool get isNewsLetterLoading => _isNewsLetterLoading;

  List<VolumeModel> _volumeData = [];
  List<VolumeModel> get volumeData => _volumeData;
  List<NewsletterModel> _newsletterData = [];
  List<NewsletterModel> get newsletterData => _newsletterData;

  List<DocumentSnapshot> _volumeSnap = [];
  List<DocumentSnapshot> _newsletterSnap = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  bool? _hasVolumeData;
  bool? get hasVolumeData => _hasVolumeData;
  bool? _hasNewsletterData;
  bool? get hasNewsLetterData => _hasNewsletterData;

  Future<Null> getNewsLetterData(volume, mounted) async {
    _hasNewsletterData = true;
    QuerySnapshot rawData2;

    if (_lastNewsLetterVisible == null)
      rawData2 = await firestore
          .collection('newsletter')
          .doc("Volume $volume")
          .collection('Editions')
          .orderBy('name', descending: true)
          //  .orderBy('timestamp', descending: false)
          .limit(30)
          .get();
    else
      rawData2 = await firestore
          .collection('newsletter')
          .doc("Volume $volume")
          .collection('Editions')
          .orderBy('name', descending: true)
          // .orderBy('volume', descending: false)
          .startAfter([_lastNewsLetterVisible!['name']])
          .limit(30)
          .get();

    if (rawData2.docs.length > 0) {
      _lastNewsLetterVisible = rawData2.docs[rawData2.docs.length - 1];
      if (mounted) {
        _isNewsLetterLoading = false;
        _newsletterSnap.addAll(rawData2.docs);
        _newsletterData = _newsletterSnap
            .map((e) => NewsletterModel.fromFirestore(e))
            .toList();
      }
    } else {
      if (_lastNewsLetterVisible == null) {
        _isNewsLetterLoading = false;
        _hasNewsletterData = false;
        print('no items');
      } else {
        _isNewsLetterLoading = false;
        _hasNewsletterData = true;
        print('no more items');
      }
    }
    notifyListeners();
    return null;
  }

  Future<Null> getVolumeData(mounted) async {
    _hasVolumeData = true;
    QuerySnapshot rawData;

    if (_lastVolumeVisible == null)
      rawData = await firestore
          .collection('newsletter')
          .orderBy('name', descending: true)
          //  .orderBy('timestamp', descending: false)
          .limit(30)
          .get();
    else
      rawData = await firestore
          .collection('newsletter')
          .orderBy('name', descending: true)
          // .orderBy('volume', descending: false)
          // .startAfter([_lastVisible!['timestamp']])
          .limit(30)
          .get();

    if (rawData.docs.length > 0) {
      _lastVolumeVisible = rawData.docs[rawData.docs.length - 1];
      if (mounted) {
        _isVolumeLoading = false;
        _volumeSnap.addAll(rawData.docs);
        _volumeData =
            _volumeSnap.map((e) => VolumeModel.fromFirestore(e)).toList();
      }
    } else {
      if (_lastVolumeVisible == null) {
        _isVolumeLoading = false;
        _hasVolumeData = false;
        print('no items');
      } else {
        _isVolumeLoading = false;
        _hasVolumeData = true;
        print('no more items');
      }
    }

    notifyListeners();
    return null;
  }

  setVolumeLoading(bool isLoading) {
    _isVolumeLoading = isLoading;
    notifyListeners();
  }

  setNewsLetterLoading(bool isLoading) {
    _isNewsLetterLoading = isLoading;
    notifyListeners();
  }

  onVolumeRefresh(mounted) {
    _isVolumeLoading = true;
    _volumeSnap.clear();
    _volumeData.clear();

    _lastVolumeVisible = null;
    getVolumeData(mounted);

    notifyListeners();
  }

  clearNewsLetterData() {
    print("David");
    _isNewsLetterLoading = true;
    _lastNewsLetterVisible = null;

    _newsletterSnap.clear();
    _newsletterData.clear();
    print("Kwame");

    _lastNewsLetterVisible = null;

    notifyListeners();
  }

  onNewsLetterRefresh(volumeNum, mounted) {
    _isNewsLetterLoading = true;
    _newsletterSnap.clear();
    _newsletterData.clear();

    _lastNewsLetterVisible = null;
    getNewsLetterData(volumeNum, mounted);

    notifyListeners();
  }
}
