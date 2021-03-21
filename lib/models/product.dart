import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  static const ID = "id";
  static const NAME = "name";
  static const PICTURE = "picture";
  static const PRICE = "price";
  static const DESCRIPTION = "description";
  static const CATEGORY = "category";
  static const FEATURED = "featured";
  static const QUANTITY = "quantity";
  static const IMAGES = "images";
  static const BRAND = "brand";
  static const SALE = "sale";
  static const SIZE = "size";
  static const FRANCHISE = "franchise";
  static const IBO = "ibo";
  static const AGENT = "agent";
  // static const COLORS = "colors";

  String _id;
  String _name;
  String _picture;
  String _description;
  String _category;
  String _brand;
  String _size;
  int _quantity;
  int _price;
  int _franchise;
  int _ibo;
  int _agent;
  bool _sale;
  bool _featured;
  // List _colors;
  List _images;

  String get id => _id;

  String get name => _name;

  String get picture => _picture;

  String get brand => _brand;

  String get category => _category;

  String get description => _description;

  String get size => _size;

  int get quantity => _quantity;

  int get price => _price;

  int get franchise => _franchise;

  int get ibo => _ibo;

  int get agent => _agent;

  bool get featured => _featured;

  bool get sale => _sale;

  // List get colors => _colors;

  List get images => _images;


  ProductModel.fromSnapshot(DocumentSnapshot snapshot) {
    _id = snapshot.data()[ID] ?? " ";
    _brand = snapshot.data()[BRAND] ?? " ";
    _sale = snapshot.data()[SALE] ?? false;
    _description = snapshot.data()[DESCRIPTION] ?? " ";
    _featured = snapshot.data()[FEATURED] ?? true;
    _price = snapshot.data()[PRICE].floor() ?? 0;
    _franchise = snapshot.data()[FRANCHISE].floor() ?? 0;
    _ibo = snapshot.data()[IBO].floor() ?? 0;
    _agent = snapshot.data()[AGENT].floor() ?? 0;
    _category = snapshot.data()[CATEGORY] ?? " ";
    // _colors = snapshot.data()[COLORS] ?? [];
    _size = snapshot.data()[SIZE] ?? " ";
    _name = snapshot.data()[NAME] ?? " ";
    _picture = snapshot.data()[PICTURE] ?? " ";
    _images = snapshot.data()[IMAGES] ?? [];

  }
}
