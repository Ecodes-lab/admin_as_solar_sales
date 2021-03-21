import 'package:admin_as_solar_sales/db/product.dart';
import 'package:admin_as_solar_sales/models/product.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier{
  User user = FirebaseAuth.instance.currentUser;
  ProductService _productServices = ProductService();
  List<ProductModel> products = [];
  List<ProductModel> productsSearched = [];

  List<String> selectedColors = [];

  ProductProvider.initialize(){
    loadProducts();
  }

  loadProducts()async{
    products = await _productServices.getProducts();
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

  Future<bool> removeFromProduct({productId, ProductModel productItem})async{
    print("THE PRODUC IS: ${productItem.toString()}");

    try{
      _productServices.removeFromProduct(productId: productId, productItem: productItem);
      return true;
    }catch(e){
      print("THE ERROR ${e.toString()}");
      return false;
    }

  }

}