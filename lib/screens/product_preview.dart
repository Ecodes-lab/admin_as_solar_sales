import 'package:admin_as_solar_sales/helpers/style.dart';
import 'package:admin_as_solar_sales/models/product.dart';
import 'package:admin_as_solar_sales/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class ProductPreview extends StatefulWidget {

  final product;
  final productPreview;

  const ProductPreview({Key key, this.product, this.productPreview}) : super(key: key);

  @override
  _ProductPreviewState createState() => _ProductPreviewState();
}

class _ProductPreviewState extends State<ProductPreview> {
  final _key = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> _partnerFormKey = GlobalKey();
  TextEditingController partnerController = TextEditingController();
  TextEditingController partnerCodeController = TextEditingController();
  // Partners _partner = Partners.franchise;
  // PartnerService _partnerService = PartnerService();
  String _partner = "None";

  String _color = "";
  String _size = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _color = widget.product.colors[0];
    // _size = widget.product.size;
  }

  @override
  Widget build(BuildContext context) {
    // final userProvider = Provider.of<UserProvider>(context);
    // final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      key: _key,
      body: SafeArea(
          child: Container(
            color: Colors.white.withOpacity(0.9),
            child: Column(
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,
                          child: Loading(),
                        )),
                    // Center(
                    //   child: FadeInImage.memoryNetwork(
                    //     placeholder: kTransparentImage,
                    //     image: widget.product.picture,
                    //     fit: BoxFit.fill,
                    //     height: 400,
                    //     width: double.infinity,
                    //   ),
                    // ),
                    SizedBox(
                        height: 400.0,
                        width: double.infinity,
                        child: Carousel(
                          // autoplay: false,
                          autoplayDuration: Duration(milliseconds: 5000),
                          defaultImage: Center(
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: widget.product["picture"],
                              fit: BoxFit.fill,
                              height: 400,
                              width: double.infinity,
                            ),
                          ),
                          images: widget.product["images"] != [] ?
                          widget.product.images.map((image) {
                            return Center(
                              child: FadeInImage.memoryNetwork(
                                placeholder: kTransparentImage,
                                image: image,
                                fit: BoxFit.fill,
                                height: 400,
                                width: double.infinity,
                              ),
                            );
                          }).toList() : null,
                          dotSize: 5.0,
                          dotSpacing: 17.0,
                          dotPosition: DotPosition.bottomCenter,

                          // showIndicator: false,
                          // dotColor: Colors.lightGreenAccent,
                          // dotVerticalPadding: 20.0,
                          indicatorBgPadding: 25.0,
                          dotBgColor: Colors.black.withOpacity(0.6),
                          borderRadius: true,
                          moveIndicatorFromBottom: 180.0,
                          noRadiusForIndicator: true,
                        )
                    ),

                    // Align(
                    //   alignment: Alignment.topCenter,
                    //   child: Container(
                    //       height: 100,
                    //       decoration: BoxDecoration(
                    //         // Box decoration takes a gradient
                    //         gradient: LinearGradient(
                    //           // Where the linear gradient begins and ends
                    //           begin: Alignment.topCenter,
                    //           end: Alignment.bottomCenter,
                    //           // Add one stop for each color. Stops should increase from 0 to 1
                    //           colors: [
                    //             // Colors are easy thanks to Flutter's Colors class.
                    //             Colors.black.withOpacity(0.7),
                    //             Colors.black.withOpacity(0.5),
                    //             Colors.black.withOpacity(0.07),
                    //             Colors.black.withOpacity(0.05),
                    //             Colors.black.withOpacity(0.025),
                    //           ],
                    //         ),
                    //       ),
                    //       child: Padding(
                    //           padding: const EdgeInsets.only(top: 8.0),
                    //           child: Container())),
                    // ),
                    // Align(
                    //   alignment: Alignment.bottomCenter,
                    //   child: Container(
                    //       height: 400,
                    //       decoration: BoxDecoration(
                    //         // Box decoration takes a gradient
                    //         gradient: LinearGradient(
                    //           // Where the linear gradient begins and ends
                    //           begin: Alignment.bottomCenter,
                    //           end: Alignment.topCenter,
                    //           // Add one stop for each color. Stops should increase from 0 to 1
                    //           colors: [
                    //             // Colors are easy thanks to Flutter's Colors class.
                    //             Colors.black.withOpacity(0.8),
                    //             Colors.black.withOpacity(0.6),
                    //             Colors.black.withOpacity(0.6),
                    //             Colors.black.withOpacity(0.4),
                    //             Colors.black.withOpacity(0.07),
                    //             Colors.black.withOpacity(0.05),
                    //             Colors.black.withOpacity(0.025),
                    //           ],
                    //         ),
                    //       ),
                    //       child: Padding(
                    //           padding: const EdgeInsets.only(top: 8.0),
                    //           child: Container())),
                    // ),
                    Positioned(
                        bottom: -5,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    '${widget.product["name"]}'.toUpperCase(),
                                    style: GoogleFonts.lato(textStyle: TextStyle(
                                      color: Colors.orange[100],
                                      fontWeight: FontWeight.w600,
                                      // fontSize: 17
                                    ),
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                    'NGN ${widget.product["price"] / 100}',
                                    textAlign: TextAlign.end,
                                    style: GoogleFonts.lato(textStyle: TextStyle(
                                      color: Colors.orange[100],
                                      fontWeight: FontWeight.w700,
                                      // fontSize: 18
                                    ),
                                    )

                                  // TextStyle(
                                  //     color: Colors.white,
                                  //     fontSize: 26,
                                  //     fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Positioned(
                      right: 0,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            // changeScreen(context, CartScreen());
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Card(
                                elevation: 10,
                                color: Colors.orange[700],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(Icons.shopping_cart, color: Colors.white,),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 120,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                          onTap: () {
                            // print("CLICKED");
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.green[700],
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(35))),
                            child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  ),
                                )),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey[50],
                              offset: Offset(2, 5),
                              blurRadius: 10)
                        ]),
                    child: Column(
                      children: <Widget>[
                        // Padding(
                        //   padding: const EdgeInsets.all(0),
                        //   child: Row(
                        //     children: <Widget>[
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 8),
                        //         child: CustomText(
                        //           text: "Select a Color",
                        //           color: white,
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 8),
                        //         child: DropdownButton<String>(
                        //             value: _color,
                        //             style: TextStyle(color: white),
                        //             items: widget.product.colors
                        //                 .map<DropdownMenuItem<String>>(
                        //                     (value) => DropdownMenuItem(
                        //                         value: value,
                        //                         child: CustomText(
                        //                           text: value,
                        //                           color: red,
                        //                         )))
                        //                 .toList(),
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 _color = value;
                        //               });
                        //             }),
                        //       )
                        //     ],
                        //   ),
                        // ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                    "Size:",
                                    style: GoogleFonts.lato(textStyle: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18
                                    ),
                                    )
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(widget.product["size"], style: GoogleFonts.lato(textStyle: TextStyle(
                                    color: Colors.orange[900],
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18
                                ),
                                )),
                                // child: DropdownButton<String>(
                                //     value: _size,
                                //     style: TextStyle(color: white),
                                //     items: widget.product.size
                                //         .map<DropdownMenuItem<String>>(
                                //             (value) => DropdownMenuItem(
                                //                 value: value,
                                //                 child: CustomText(
                                //                   text: value,
                                //                   color: red,
                                //                 )))
                                //         .toList(),
                                //     onChanged: (value) {
                                //       setState(() {
                                //         _size = value;
                                //       });
                                //     }),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                        "Description:",
                                        style: GoogleFonts.lato(textStyle: TextStyle(
                                            color: black,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18
                                        ),
                                        )
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: Text("${widget.product["description"]}"[0].toUpperCase() + "${widget.product["description"]}".substring(1), style: GoogleFonts.lato(textStyle: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 17
                                      ),
                                      )),
                                      //   child: Text(
                                      //       widget.product.description,
                                      //         // textAlign: TextAlign.left,
                                      //       style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(9),
                        //   child: Material(
                        //       borderRadius: BorderRadius.circular(15.0),
                        //       color: Colors.green[700],
                        //       elevation: 0.0,
                        //       child: MaterialButton(
                        //           onPressed: () async {
                        //             // print(widget.product.franchise);
                        //             // if (widget.product.franchise == 0 && widget.product.ibo == 0 && widget.product.agent == 0) {
                        //             //
                        //             //   appProvider.changeIsLoading();
                        //             //   bool success = await userProvider.addToCart(
                        //             //       product: widget.product,
                        //             //       size: _size);
                        //             //   if (success) {
                        //             //     _key.currentState.showSnackBar(
                        //             //         SnackBar(content: Text("Added to Cart!",)));
                        //             //     userProvider.reloadUserModel();
                        //             //     appProvider.changeIsLoading();
                        //             //     return;
                        //             //   } else {
                        //             //     _key.currentState.showSnackBar(SnackBar(
                        //             //         content: Text("Not added to Cart!")));
                        //             //     appProvider.changeIsLoading();
                        //             //     return;
                        //             //   }
                        //             // } else {
                        //             //   _partnerAlert(context, userProvider, appProvider);
                        //             // }
                        //           },
                        //           minWidth: MediaQuery.of(context).size.width,
                        //           child: appProvider.isLoading
                        //               ? Loading()
                        //               : Text(
                        //               "Add to Cart".toUpperCase(),
                        //               textAlign: TextAlign.center,
                        //               style: GoogleFonts.lato(textStyle: TextStyle(
                        //                   color: white,
                        //                   fontWeight: FontWeight.bold,
                        //                   fontSize: 18
                        //               ),
                        //               ))
                        //
                        //       )),
                        // ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
}
