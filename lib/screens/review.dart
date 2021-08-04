import 'package:admin_as_solar_sales/helpers/style.dart';
// import 'package:admin_as_solar_sales/models/order.dart';
import 'package:admin_as_solar_sales/models/product.dart';
import 'package:admin_as_solar_sales/providers/app_states.dart';
// import 'package:admin_as_solar_sales/provider/app.dart';
import 'package:admin_as_solar_sales/providers/products_provider.dart';
import 'package:admin_as_solar_sales/providers/user.dart';
import 'package:admin_as_solar_sales/db/review.dart';
// import 'package:admin_as_solar_sales/widgets/custom_text.dart';
import 'package:admin_as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:uuid/uuid.dart';

class ReviewScreen extends StatefulWidget {
  final ProductModel product;

  const ReviewScreen({Key key, this.product}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    //
    final productProvider = Provider.of<ProductProvider>(context);
    //
    ReviewServices _reviewServices = ReviewServices();

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
          title: Text("Pending Reviews", style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal)),
          leading: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        // backgroundColor: white,
        body: MyReview(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => _showRatingAppDialog(userProvider, productProvider, _reviewServices),
      //   child: Icon(Icons.add_comment),
      //   backgroundColor: Colors.green[700],
      // ),

    );
  }

  // void _showRatingAppDialog(userProvider, productProvider, _reviewServices) {
  //
  //
  //   // ReviewServices _reviewServices = ReviewServices();
  //
  //   final _ratingDialog = RatingDialog(
  //     ratingColor: Colors.amber,
  //     title: widget.product.name,
  //     message: 'Rate this product and tell others what you think.'
  //         ' Add more description here if you want.',
  //     image: Image.network(widget.product.picture,
  //       height: 100,),
  //     submitButton: 'Submit',
  //     onCancelled: () => print('cancelled'),
  //     onSubmitted: (response) async {
  //       var uuid = Uuid();
  //       String id = uuid.v4();
  //       _reviewServices.createReview(
  //           userId: userProvider.user.uid,
  //           id: id,
  //           productId: widget.product.id,
  //           rating: response.rating,
  //           comment: response.comment,
  //           status: "pending",);
  //       print('rating: ${response.rating}, '
  //           'comment: ${response.comment}');
  //
  //       if (response.rating < 3.0) {
  //         print('response.rating: ${response.rating}');
  //       } else {
  //         Container();
  //       }
  //       // userProvider.reloadUserModel();
  //       await productProvider.loadReviews(widget.product.id);
  //     },
  //   );
  //
  //   showDialog(
  //     context: context,
  //     barrierDismissible: true,
  //     builder: (context) => _ratingDialog,
  //   );
  // }
}

class MyReview extends StatelessWidget {
  final _key = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appProvider = Provider.of<AppState>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    ReviewServices _reviewServices = ReviewServices();
    return Container(
      // decoration: BoxDecoration(
      //   shape: BoxShape.circle,
      //   color: Colors.black,
      // ),
        alignment: Alignment.center,
        // padding: EdgeInsets.all(10),
        child: appProvider.isLoading
            ? Loading()
            : ListView.builder(
          itemCount: productProvider.reviews.length,
          // shrinkWrap: true,
          // physics: ClampingScrollPhysics(),
          // shrinkWrap: true,
          itemBuilder: (_, index){
            // print(productProvider.reviews.length);

            // productProvider.loadReviewedProducts(productProvider.reviews[index].productId);
            double rating = productProvider.reviews[index].rating.toDouble();
            return productProvider.reviews[index].status == "pending" ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Image.network(productProvider.reviews[index].productImage),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${productProvider.reviews[index].productName}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15
                    )),
                    ),
                    Text("${productProvider.reviews[index].comment}", style: GoogleFonts.lato(textStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15
                    )),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RatingBarIndicator(
                        rating: rating,
                        // minRating: 1,
                        direction: Axis.horizontal,
                        // allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        // itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        // onRatingUpdate: (rating) {
                        //   print(rating);
                        // },
                    ),
                    Text("${DateTime.fromMillisecondsSinceEpoch(productProvider.reviews[index].createdAt).toString()}",
                      style: GoogleFonts.lato(textStyle: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 12
                      )),
                    ),
                  ],
                ),

                onTap: (){
                  // productProvider.reviews[index].id
                  userProvider.userModel.isSuperAdmin ?
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          //this right here
                          child: Container(
                            height: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  // Text(
                                  //   'You will be charged \$${userProvider.userModel.totalCartPrice / 100} now or later!',
                                  //   textAlign: TextAlign.center,
                                  // ),

                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                      onPressed: () async {
                                        _reviewServices.updateReview({
                                          "id": productProvider.reviews[index].id,
                                          "status": "approved"
                                        });

                                        // _key.currentState.showSnackBar(
                                        //     SnackBar(
                                        //         content: Text(
                                        //             "Review approved!")));
                                        Navigator.pop(context);

                                        await productProvider.loadReviews();
                                      },
                                      child: Text(
                                        "Approve",
                                        style:
                                        TextStyle(color: Colors.white),
                                      ),
                                      color: Colors.green[800],
                                    ),
                                  ),

                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                        onPressed: () async {
                                          // appProvider.changeIsLoading();
                                          // bool success =
                                          await productProvider.removeReview(
                                            reviewId: productProvider.reviews[index].id,
                                          );
                                          // if (success) {
                                          //
                                          //   // print("Item added to product");
                                          //   // _key.currentState.showSnackBar(SnackBar(
                                          //   //     content: Text("Review removed!"), duration: Duration(milliseconds: 5000)));
                                          //
                                          //   return;
                                          // } else {
                                          //   appProvider.changeIsLoading();
                                          // }

                                          Navigator.pop(context);

                                          await productProvider.loadReviews();
                                        },
                                        child: Text(
                                          "Delete",
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                        color: red),
                                  ),

                                  SizedBox(
                                    width: 320.0,
                                    child: RaisedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          "Reject",
                                          style: TextStyle(
                                              color: Colors.white),
                                        ),
                                        color: Colors.orange[800]),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                  : Container();
                },
              ),
            ) : Container();
            // OrderModel _order = userProvider.orders[index];
            // return ChangeNotifierProvider.value(value: null);
            // return Column(
            //   children: <Widget>[
            //     ListView.builder(
            //         itemCount: userProvider.orders[index].cart.length,
            //         physics: ClampingScrollPhysics(),
            //         shrinkWrap: true,
            //         itemBuilder: (_, i) {
            //           return ListTile(
            //             // leading: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}"),
            //             title: Text("${userProvider.orders[index].cart[i]["name"]}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
            //                 fontWeight: FontWeight.w400,
            //                 fontSize: 15
            //             )),
            //             ),
            //             subtitle: Text("${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}",
            //               style: GoogleFonts.lato(textStyle: TextStyle(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 12
            //               )),
            //             ),
            //             // subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
            //             trailing: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}",
            //               style: GoogleFonts.lato(textStyle: TextStyle(
            //                   fontWeight: FontWeight.w400,
            //                   fontSize: 13
            //               )),
            //             ),
            //             onTap: (){
            //
            //             },
            //           );
            //         }
            //     )
            //   ],
            // );
          },
        )
    );
  }
}
