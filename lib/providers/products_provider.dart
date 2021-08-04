import 'package:admin_as_solar_sales/db/product.dart';
import 'package:admin_as_solar_sales/db/review.dart';
import 'package:admin_as_solar_sales/models/product.dart';
import 'package:admin_as_solar_sales/models/review.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  User user = FirebaseAuth.instance.currentUser;
  ProductService _productServices = ProductService();
  ReviewServices _reviewServices = ReviewServices();
  // List<ProductModel> product = [];
  List<ProductModel> products = [];
  List<ProductModel> productReviewed = [];
  List<ProductModel> productsSearched = [];
  List<ReviewModel> reviews = [];

  List<String> selectedColors = [];

  ProductProvider.initialize(){
    loadProducts();
  }

  // loadProduct(productId) async {
  //   product = await _productServices.getProduct(productId);
  //   notifyListeners();
  // }

  loadProducts()async{
    products = await _productServices.getProducts();
    notifyListeners();
  }

  loadReviews() async {
    reviews = await _reviewServices.getUserReviews();
    notifyListeners();
  }

  loadReviewedProducts(productId) async {
    productReviewed = await _reviewServices.getProducts(productId);
    notifyListeners();
  }


  addColors(String color){
    selectedColors.add(color);
    print(selectedColors.length.toString());
    notifyListeners();
  }

  removeColor(String color){
    selectedColors.remove(color);
    print(selectedColors.length.toString());
    notifyListeners();
  }

  Future<bool> removeFromProduct({productId})async{
    // print("THE PRODUC IS: ${productItem.toString()}");

    try{
      _productServices.removeFromProduct(productId: productId);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

  Future<bool> removeReview({reviewId})async{

    try{
      _reviewServices.removeReview(reviewId: reviewId);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

}