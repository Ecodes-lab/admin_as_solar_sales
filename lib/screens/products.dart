import 'package:admin_as_solar_sales/models/product.dart';
import 'package:admin_as_solar_sales/providers/app_states.dart';
import 'package:admin_as_solar_sales/providers/products_provider.dart';
import 'package:admin_as_solar_sales/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'add_product.dart';

class ProductsScreen extends StatefulWidget {
  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final appProvider = Provider.of<AppState>(context);

    return Scaffold(
        appBar: AppBar(
          // centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          // title: Text(
          //   "Purchase History",
          //   style: TextStyle(color: Colors.black),
          //
          title: Text("Products", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal)),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        // backgroundColor: white,
        body: Container(
          // decoration: BoxDecoration(
          //   shape: BoxShape.circle,
          //   color: Colors.black,
          // ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('products').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount: snapshot.data.docs.length,
                    // itemCount: productProvider.products.length,
                    physics: ClampingScrollPhysics(),
                    // shrinkWrap: true,
                    itemBuilder: (_, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.red.withOpacity(0.2),
                                    offset: Offset(3, 2),
                                    blurRadius: 30)
                              ]
                          ),
                          child: Row(
                            children: <Widget>[
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                                child: Image.network(
                                  snapshot.data.docs[index]["picture"],
                                  height: 120,
                                  width: 140,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Flexible(
                                      child: RichText(
                                        text: TextSpan(children: [
                                          TextSpan(
                                              text: "${snapshot.data.docs[index]["name"]}".toUpperCase() +"\n",
                                              style: GoogleFonts.lato(textStyle: TextStyle(
                                                  color: Colors.black,
                                                  // fontSize: 18,
                                                  fontWeight: FontWeight.bold))),
                                          TextSpan(
                                              text:
                                              "NGN ${snapshot.data.docs[index]["price"] / 100} \n\n",
                                              style: GoogleFonts.lato(textStyle: TextStyle(
                                                color: Colors.grey[700],
                                                fontWeight: FontWeight.w400,
                                                // fontSize: 18
                                              ),
                                              )),
                                        ]),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.red,
                                            ),
                                            onPressed: () async {
                                              print("Edit");
                                              Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct(productModel: productProvider.products[index], isEdit: true)));
                                              // appProvider.changeIsLoading();
                                              // bool success =
                                              // await productProvider.removeFromProduct(
                                              //     productId: productProvider.products[index].id,
                                              //     productItem: productProvider.products[index]);
                                              // if (success) {
                                              //   // userProvider.reloadUserModel();
                                              //   productProvider.loadProducts();
                                              //   // print("Item added to product");
                                              //   _key.currentState.showSnackBar(SnackBar(
                                              //       content: Text("Removed from Product!"), duration: Duration(milliseconds: 5000)));
                                              //   // appProvider.changeIsLoading();
                                              //   return;
                                              // } else {
                                              //   appProvider.changeIsLoading();
                                              // }
                                            }),
                                        userProvider.userModel.isSuperAdmin ?
                                          IconButton(
                                              icon: Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () async {
                                                appProvider.changeIsLoading();
                                                bool success =
                                                await productProvider.removeFromProduct(
                                                  productId: productProvider.products[index].id,
                                                  // productItem: productProvider.products[index]
                                                );
                                                if (success) {
                                                  // userProvider.reloadUserModel();

                                                  // print("Item added to product");
                                                  _key.currentState.showSnackBar(SnackBar(
                                                      content: Text("Removed from Product!"), duration: Duration(milliseconds: 5000)));
                                                  // appProvider.changeIsLoading();

                                                  productProvider.loadProducts();

                                                  return;
                                                } else {
                                                  appProvider.changeIsLoading();
                                                }
                                              })
                                            :
                                              Container()
                                      ],
                                    ),

                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      );

                    },
                  );
                } else if(snapshot.hasError){ const Text('No data avaible right now'); }
                return Center(child: CircularProgressIndicator());
              }
            )
        )
    );
  }
}
