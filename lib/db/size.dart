import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
class SizeService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'sizes';

  void createSize(String name){
    var id = Uuid();
    String sizeId = id.v1();

    _firestore.collection(ref).doc(sizeId).set({'size': name.trim()});
  }

  Future<List<DocumentSnapshot>> getSize(String size) async =>
      _firestore
          .collection(ref)
          .where("size", isEqualTo: size)
          .get().then((snaps){

        // List<PartnerModel> partners = [];
        // for (DocumentSnapshot order in snaps.docs) {
        //   partners.add(PartnerModel.fromSnapshot(order));
        // }
        // return partners;
        // print(snaps.docs.length);
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getSizes() => _firestore.collection(ref).get().then((snaps){
    print(snaps.docs.length);
    return snaps.docs;
  });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('size', isEqualTo: suggestion).get().then((snap){
        return snap.docs;
      });
}