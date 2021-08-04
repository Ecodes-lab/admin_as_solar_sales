import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
class BrandService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'brands';

  void createBrand(String name){
    var id = Uuid();
    String brandId = id.v1();

    _firestore.collection(ref).doc(brandId).set({'brand': name.trim()});
  }

  Future<List<DocumentSnapshot>> getBrand(String brand) async =>
      _firestore
          .collection(ref)
          .where("brand", isEqualTo: brand)
          .get().then((snaps){

        // List<PartnerModel> partners = [];
        // for (DocumentSnapshot order in snaps.docs) {
        //   partners.add(PartnerModel.fromSnapshot(order));
        // }
        // return partners;
        // print(snaps.docs.length);
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getBrands() => _firestore.collection(ref).get().then((snaps){
      print(snaps.docs.length);
      return snaps.docs;
    });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('brand', isEqualTo: suggestion).get().then((snap){
        return snap.docs;
      });
}