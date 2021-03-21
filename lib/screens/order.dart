// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// class ProductsScreen extends StatefulWidget {
//   @override
//   _ProductsScreenState createState() => _ProductsScreenState();
// }
//
// class _ProductsScreenState extends State<ProductsScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           // centerTitle: true,
//           elevation: 0.0,
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black),
//           // title: Text(
//           //   "Purchase History",
//           //   style: TextStyle(color: Colors.black),
//           //
//           title: Text("Orders"),
//           leading: IconButton(
//               icon: Icon(Icons.close),
//               onPressed: () {
//                 Navigator.pop(context);
//               }),
//         ),
//         // backgroundColor: white,
//         body: Container(
//           // decoration: BoxDecoration(
//           //   shape: BoxShape.circle,
//           //   color: Colors.black,
//           // ),
//             alignment: Alignment.center,
//             padding: EdgeInsets.all(10),
//             child: ListView.builder(
//               itemCount: userProvider.orders.length,
//               // shrinkWrap: true,
//               itemBuilder: (_, index){
//
//                 // OrderModel _order = userProvider.orders[index];
//                 // return ChangeNotifierProvider.value(value: null);
//                 return Column(
//                   children: <Widget>[
//                     ListView.builder(
//                         itemCount: userProvider.orders[index].cart.length,
//                         physics: ClampingScrollPhysics(),
//                         shrinkWrap: true,
//                         itemBuilder: (_, i) {
//                           return ListTile(
//                             // leading: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}"),
//                             title: Text("${userProvider.orders[index].cart[i]["name"]}".toUpperCase(), style: GoogleFonts.lato(textStyle: TextStyle(
//                                 fontWeight: FontWeight.w400,
//                                 fontSize: 15
//                             )),
//                             ),
//                             subtitle: Text("${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}",
//                               style: GoogleFonts.lato(textStyle: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 12
//                               )),
//                             ),
//                             // subtitle: Text("Order id: asdasdasdasd \n Putchased on: ${DateTime.fromMillisecondsSinceEpoch(userProvider.orders[index].createdAt).toString()}"),
//                             trailing: Text("NGN ${userProvider.orders[index].cart[i]["price"] / 100}",
//                               style: GoogleFonts.lato(textStyle: TextStyle(
//                                   fontWeight: FontWeight.w400,
//                                   fontSize: 13
//                               )),
//                             ),
//                             onTap: (){
//
//                             },
//                           );
//                         }
//                     )
//                   ],
//                 );
//               },
//             )
//         );
//     );
//   }
// }
