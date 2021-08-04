import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CategoryService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'categories';


  void createCategory(String name) async {
    var id = Uuid();
    String categoryId = id.v1();

    _firestore.collection(ref).doc(categoryId).set({'category': name.trim()});

  }

  Future<List<DocumentSnapshot>> getCategory(String category) async =>
      _firestore
          .collection(ref)
          .where("category", isEqualTo: category)
          .get().then((snaps){
            // snaps.docs.map((e) {
            //   if (e.data()["category"] == category) {
                return snaps.docs;
              // }
        // return snaps.docs.isEmpty;
        //     });
      });

  Future<List<DocumentSnapshot>> getCategories() =>
      _firestore.collection(ref).get().then((snaps) {
        return snaps.docs;
      });


  Future<List<DocumentSnapshot>> getSuggestions(String suggestion) =>
      _firestore.collection(ref).where('category', isEqualTo: suggestion).get().then((snap){
        return snap.docs;
      });

}