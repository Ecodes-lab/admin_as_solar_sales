import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  static const ID = "id";
  static const RATING = "rating";
  static const COMMENT = "comment";
  static const PRODUCT_ID = "productId";
  static const PRODUCT_NAME = "productName";
  static const PRODUCT_IMAGE = "productImage";
  static const USER_ID = "userId";
  static const STATUS = "status";
  static const CREATED_AT = "createdAt";


  String _id;
  String _comment;
  String _productId;
  String _productName;
  String _productImage;
  String _userId;
  String _status;
  int _rating;
  int _createdAt;

  String get id         => _id;
  String get comment    => _comment;
  String get productId  => _productId;
  String get productName => _productName;
  String get productImage => _productImage;
  String get userId     => _userId;
  String get status     => _status;
  int get rating          => _rating;
  int get createdAt     => _createdAt;


  ReviewModel.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data();
    _id = data[ID];
    _rating = data[RATING];
    _comment = data[COMMENT];
    _productId = data[PRODUCT_ID];
    _productName = data[PRODUCT_NAME];
    _productImage = data[PRODUCT_IMAGE];
    _userId = data[USER_ID];
    _status = data[STATUS];
    _createdAt = data[CREATED_AT];
  }

}