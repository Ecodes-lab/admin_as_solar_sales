import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
class PowerCapacityService{
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'power_capacities';

  void createPowerCapacity(String name){
    var id = Uuid();
    String power_capacity_Id = id.v1();

    _firestore.collection(ref).doc(power_capacity_Id).set({'power_capacity': name.trim()});
  }

  Future<List<DocumentSnapshot>> getPowerCapacity(String power_capacity) async =>
      _firestore
          .collection(ref)
          .where("power_capacity", isEqualTo: power_capacity)
          .get().then((snaps){

        // List<PartnerModel> partners = [];
        // for (DocumentSnapshot order in snaps.docs) {
        //   partners.add(PartnerModel.fromSnapshot(order));
        // }
        // return partners;
        // print(snaps.docs.length);
        return snaps.docs;
      });

  Future<List<DocumentSnapshot>> getPowerCapacities() => _firestore.collection(ref).get().then((snaps){
    print(snaps.docs.length);
    return snaps.docs;
  });

  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('power_capacity', isEqualTo: suggestion).get().then((snap){
        return snap.docs;
      });
}