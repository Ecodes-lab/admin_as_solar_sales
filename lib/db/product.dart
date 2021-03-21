import 'package:admin_as_solar_sales/models/product.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ProductService {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String ref = 'products';

  void uploadProduct(Map<String, dynamic> data) {
    var id = Uuid();
    String productId = id.v1();
    data["id"] = productId;
    _firestore.collection(ref).doc(productId).set(data);
  }

  Future<List<ProductModel>> getProducts() async =>
      _firestore.collection(ref).get().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        // result.docs.map((DocumentSnapshot snapshot) => products.add(ProductModel.fromSnapshot(snapshot)));
        return products;
      });

  void updateDetails(Map<String, dynamic> values){
    _firestore.collection(ref).doc(values["id"]).update(values);
  }


  void removeFromProduct({String productId, ProductModel productItem}){
    _firestore.collection(ref).doc(productId).delete();
  }
}