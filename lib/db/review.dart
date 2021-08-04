// import 'package:as_solar_sales/models/cart_item.dart';
import 'package:admin_as_solar_sales/models/product.dart';
import 'package:admin_as_solar_sales/models/review.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewServices{
  String collection = "reviews";
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void createReview({String userId, String id, String productId, int rating, String comment, String status}) {
    // List<Map> convertedCart = [];

    // for(CartItemModel item in cart){
    //   convertedCart.add(item.toMap());
    // }

    _firestore.collection(collection).doc(id).set({
      "userId": userId,
      "id": id,
      "createdAt": DateTime.now().millisecondsSinceEpoch,
      "rating": rating,
      "comment": comment,
      "status": status,
      "productId": productId
    });
  }

  List<ProductModel> products = [];

  Future<List<ProductModel>> getProducts(productId) async =>
      _firestore.collection("products").where("id", isEqualTo: productId).get().then((result) {
        List<ProductModel> products = [];
        for (DocumentSnapshot product in result.docs) {
          products.add(ProductModel.fromSnapshot(product));
        }
        // result.docs.map((DocumentSnapshot snapshot) => products.add(ProductModel.fromSnapshot(snapshot)));
        return products;
      });

  Future<List<ReviewModel>> getUserReviews() async =>
      _firestore
          .collection(collection)
          // .where("productId", isEqualTo: productId)
          .where("status", isEqualTo: "pending")
          .get()
          .then((result) {
        List<ReviewModel> reviews = [];
        for (DocumentSnapshot review in result.docs) {
          reviews.add(ReviewModel.fromSnapshot(review));
          // getProducts(ReviewModel.fromSnapshot(review).productId);
        }
        return reviews;
      });

  void updateReview(Map<String, dynamic> values){
    _firestore.collection(collection).doc(values["id"]).update(values);
  }

  void removeReview({String reviewId}){
    _firestore.collection(collection).doc(reviewId).delete();
  }

}