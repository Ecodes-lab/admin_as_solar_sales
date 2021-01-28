import 'package:cloud_firestore/cloud_firestore.dart';

// import 'cart_item.dart';

class UserModel {
  static const ID = "uid";
  static const NAME = "name";
  static const EMAIL = "email";
  static const STRIPE_ID = "stripeId";
  static const PAYSTACK_ID = "paystackId";
  static const CART = "cart";
  static const ACTIVE_CARD = "activeCard";
  static const IS_ADMIN = "isAdmin";
  static const IS_SUPER_ADMIN = "isSuperAdmin";


  String _name;
  String _email;
  String _id;
  String _stripeId;
  String _paystackId;
  String _activeCard;
  int _priceSum = 0;
  bool _isAdmin;
  bool _isSuperAdmin;


//  getters
  String get name => _name;

  String get email => _email;

  String get id => _id;

  String get stripeId => _stripeId;

  String get paystackId => _paystackId;

  String get activeCard => _activeCard;

  // public variables
  // List<CartItemModel> cart;
  int totalCartPrice;

  bool get isAdmin => _isAdmin;

  bool get isSuperAdmin => _isSuperAdmin;



  UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    _name = snapshot.data()[NAME];
    _email = snapshot.data()[EMAIL];
    _id = snapshot.data()[ID];
    _stripeId = snapshot.data()[STRIPE_ID] ?? null;
    _paystackId = snapshot.data()[PAYSTACK_ID] ?? null;
    // cart = _convertCartItems(snapshot.data()[CART]?? []);
    totalCartPrice = snapshot.data()[CART] == null ? 0 :getTotalPrice(cart: snapshot.data()[CART]);
    _activeCard = snapshot.data()[ACTIVE_CARD] ?? null;
    _isAdmin = snapshot.data()[IS_ADMIN] ?? false;
    _isSuperAdmin = snapshot.data()[IS_SUPER_ADMIN] ?? false;

  }

  // List<CartItemModel> _convertCartItems(List cart){
  //   List<CartItemModel> convertedCart = [];
  //   for(Map cartItem in cart){
  //     convertedCart.add(CartItemModel.fromMap(cartItem));
  //   }
  //   return convertedCart;
  // }

  int getTotalPrice({List cart}){
    if(cart == null){
      return 0;
    }
    for(Map cartItem in cart){
      _priceSum += cartItem["price"];
    }

    int total = _priceSum;
    return total;
  }
}
