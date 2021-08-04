import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;

import 'package:admin_as_solar_sales/models/product.dart';
import 'package:admin_as_solar_sales/screens/product_preview.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin_as_solar_sales/db/product.dart';
import 'package:provider/provider.dart';
import 'package:admin_as_solar_sales/providers/products_provider.dart';
import '../db/category.dart';
import '../db/brand.dart';
import '../db/size.dart';
import '../db/power_capacity.dart';

class AddProduct extends StatefulWidget {
  final ProductModel productModel;
  final isEdit;

  AddProduct({Key key, @required this.productModel, this.isEdit}) : super(key: key);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {

  CategoryService _categoryService = CategoryService();
  BrandService _brandService = BrandService();
  ProductService productService = ProductService();
  PowerCapacityService _powerCapacityService = PowerCapacityService();
  SizeService _sizeService = SizeService();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  final priceController = TextEditingController()..text = "0.00";
  TextEditingController descriptionController = TextEditingController();
  TextEditingController partnerFranchiseController = TextEditingController()..text = "0.00";
  TextEditingController partnerIBOController = TextEditingController()..text = "0.00";
  TextEditingController partnerAgentController = TextEditingController()..text = "0.00";
  List<DocumentSnapshot> brands = <DocumentSnapshot>[];
  List<DocumentSnapshot> categories = <DocumentSnapshot>[];
  List<DocumentSnapshot> power_capacities = <DocumentSnapshot>[];
  List<DocumentSnapshot> sizes = <DocumentSnapshot>[];
  List<DropdownMenuItem<String>> categoriesDropDown =
  <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> brandsDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> sizeDropDown = <DropdownMenuItem<String>>[];
  List<DropdownMenuItem<String>> powerCapacityDropDown = <DropdownMenuItem<String>>[];
  String _currentCategory;
  String _currentBrand;
  String _currentSize;
  String _currentPowerCapacity;
  Color white = Colors.white;
  Color black = Colors.black;
  Color grey = Colors.grey;
  Color red = Colors.red;
  // List<String> selectedSizes = <String>[];
  List<String> colors = <String>[];
  bool onSale = false;
  bool featured = false;

  PickedFile _image1;
  PickedFile _image2;
  PickedFile _image3;
  bool isLoading = false;



  @override
  initState(){
    super.initState();
    if(widget.productModel != null) {

      productNameController.text = widget.productModel.name;
      quantityController.text = widget.productModel.quantity.toString();
      priceController.text = widget.productModel.price != 0 ? "${(widget.productModel.price / 100).toStringAsFixed(2)}" : "0.00";
      partnerFranchiseController.text = widget.productModel.franchise != 0 ? "${(widget.productModel.franchise / 100).toStringAsFixed(2)}" : "0.00";
      partnerIBOController.text = widget.productModel.ibo != 0 ? "${(widget.productModel.ibo / 100).toStringAsFixed(2)}" : "0.00";
      partnerAgentController.text = widget.productModel.agent != 0 ? "${(widget.productModel.agent / 100).toStringAsFixed(2)}" : "0.00";
      descriptionController.text = widget.productModel.description;
      onSale = widget.productModel.sale;
      featured = widget.productModel.featured;
      // _currentCategory = widget.productModel.category;
      // final byte = Io.File(widget.productModel.images[0]).readAsBytes();
      // File img64 = widget.productModel.images[0];
      // _selectImage(img64, 1);


    }
    _getCategories();
    _getBrands();
    _getPowerCapacities();
    _getSizes();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      Map<String, dynamic> data = categories[i].data();
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(data['category']),
                value: data['category']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandosDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      Map<String, dynamic> data = brands[i].data();
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(data['brand']),
                value: data['brand']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getPowerCapacityDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < power_capacities.length; i++) {
      Map<String, dynamic> data = power_capacities[i].data();
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(data['power_capacity']),
                value: data['power_capacity']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getSizeDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < sizes.length; i++) {
      Map<String, dynamic> data = sizes[i].data();
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(data['size']),
                value: data['size']));
      });
    }
    return items;
  }

  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: white,
        leading: IconButton(
          onPressed: () {
            print("CLICKED");
            Navigator.pop(context);
          },
          icon: Icon(

            Icons.close,
            color: black,
          ),
        ),

        title: Text(
          widget.isEdit == true ? "Update Product" : "Add Product",
          style: TextStyle(color: black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: isLoading
              ? CircularProgressIndicator()
              : Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // Container(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(8.0),
                  //     child: Container(
                  //       width: 120,
                  //       child: OutlineButton(
                  //           borderSide: BorderSide(
                  //               color: grey.withOpacity(0.5), width: 2.5),
                  //           onPressed: () {
                  //             _selectImage(
                  //                 ImagePicker.pickImage(
                  //                     source: ImageSource.gallery),
                  //                 1);
                  //           },
                  //           child: _displayChild1()),
                  //     ),
                  //   ),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          borderSide: BorderSide(
                              color: grey.withOpacity(0.5), width: 2.5),
                          onPressed: () async {
                            _selectImage(
                                picker.getImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 400,
                                    maxWidth: 400
                                ),
                                1);
                          },
                          child: _displayChild1()),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                          borderSide: BorderSide(
                              color: grey.withOpacity(0.5), width: 2.5),
                          onPressed: () {
                            _selectImage(
                                picker.getImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 400,
                                    maxWidth: 400
                                ),
                                2);
                          },
                          child: _displayChild2()),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlineButton(
                        borderSide: BorderSide(
                            color: grey.withOpacity(0.5), width: 2.5),
                        onPressed: () {
                          _selectImage(
                              picker.getImage(
                                  source: ImageSource.gallery,
                                  maxHeight: 400,
                                  maxWidth: 400
                              ),
                              3);
                        },
                        child: _displayChild3(),
                      ),
                    ),
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'enter a product name with 20 characters at maximum',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: red, fontSize: 12),
                ),
              ),

              // Text('Available Colors'),
              //
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: <Widget>[
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: (){
              //           if(productProvider.selectedColors.contains('red')){
              //             productProvider.removeColor('red');
              //           }else{
              //             productProvider.addColors('red');
              //
              //           }
              //           setState(() {
              //             colors = productProvider.selectedColors;
              //           });
              //         },
              //         child: Container(width: 24, height: 24, decoration: BoxDecoration(
              //             color: productProvider.selectedColors.contains('red') ? Colors.blue : grey,
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(2),
              //             child: CircleAvatar(
              //               backgroundColor: Colors.red,
              //             ),
              //           ),),
              //       ),
              //     ),
              //
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: (){
              //           if(productProvider.selectedColors.contains('yellow')){
              //             productProvider.removeColor('yellow');
              //           }else{
              //             productProvider.addColors('yellow');
              //
              //           }
              //           setState(() {
              //             colors = productProvider.selectedColors;
              //           });
              //         },
              //         child: Container(width: 24, height: 24, decoration: BoxDecoration(
              //             color: productProvider.selectedColors.contains('yellow') ? red : grey,
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(2),
              //             child: CircleAvatar(
              //               backgroundColor: Colors.yellow,
              //             ),
              //           ),),
              //       ),
              //     ),
              //
              //
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: (){
              //           if(productProvider.selectedColors.contains('blue')){
              //             productProvider.removeColor('blue');
              //           }else{
              //             productProvider.addColors('blue');
              //
              //           }
              //           setState(() {
              //             colors = productProvider.selectedColors;
              //           });
              //         },
              //         child: Container(width: 24, height: 24, decoration: BoxDecoration(
              //             color: productProvider.selectedColors.contains('blue') ? red : grey,
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(2),
              //             child: CircleAvatar(
              //               backgroundColor: Colors.blue,
              //             ),
              //           ),),
              //       ),
              //     ),
              //
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: (){
              //           if(productProvider.selectedColors.contains('green')){
              //             productProvider.removeColor('green');
              //           }else{
              //             productProvider.addColors('green');
              //
              //           }
              //           setState(() {
              //             colors = productProvider.selectedColors;
              //           });
              //         },
              //         child: Container(width: 24, height: 24, decoration: BoxDecoration(
              //             color: productProvider.selectedColors.contains('green') ? red : grey,
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(2),
              //             child: CircleAvatar(
              //               backgroundColor: Colors.green,
              //             ),
              //           ),),
              //       ),
              //     ),
              //
              //
              //
              //
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: (){
              //           if(productProvider.selectedColors.contains('white')){
              //             productProvider.removeColor('white');
              //           }else{
              //             productProvider.addColors('white');
              //
              //           }
              //           setState(() {
              //             colors = productProvider.selectedColors;
              //           });
              //         },
              //         child: Container(width: 24, height: 24, decoration: BoxDecoration(
              //             color: productProvider.selectedColors.contains('white') ? red : grey,
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(2),
              //             child: CircleAvatar(
              //               backgroundColor: white,
              //             ),
              //           ),),
              //       ),
              //     ),
              //
              //
              //     Padding(
              //       padding: const EdgeInsets.all(8.0),
              //       child: InkWell(
              //         onTap: (){
              //           if(productProvider.selectedColors.contains('black')){
              //             productProvider.removeColor('black');
              //           }else{
              //             productProvider.addColors('black');
              //
              //           }
              //           setState(() {
              //             colors = productProvider.selectedColors;
              //           });
              //         },
              //         child: Container(width: 24, height: 24, decoration: BoxDecoration(
              //             color: productProvider.selectedColors.contains('black') ? red : grey,
              //             borderRadius: BorderRadius.circular(15)
              //         ),
              //           child: Padding(
              //             padding: const EdgeInsets.all(2),
              //             child: CircleAvatar(
              //               backgroundColor: black,
              //             ),
              //           ),),
              //       ),
              //     ),
              //   ],
              // ),

              // Text('Available Sizes'),

              // Row(
              //   children: <Widget>[
              //     Checkbox(
              //         value: selectedSizes.contains('W'),
              //         onChanged: (value) => changeSelectedSize('W')),
              //     Text('W'),
              //     Checkbox(
              //         value: selectedSizes.contains('Kw'),
              //         onChanged: (value) => changeSelectedSize('Kw')),
              //     Text('Kw'),
              //     Checkbox(
              //         value: selectedSizes.contains('A'),
              //         onChanged: (value) => changeSelectedSize('A')),
              //     Text('A'),
              //     Checkbox(
              //         value: selectedSizes.contains('V'),
              //         onChanged: (value) => changeSelectedSize('V')),
              //     Text('V'),
              //     Checkbox(
              //         value: selectedSizes.contains('Ah'),
              //         onChanged: (value) => changeSelectedSize('Ah')),
              //     Text('Ah'),
              //     Checkbox(
              //         value: selectedSizes.contains('KVA'),
              //         onChanged: (value) => changeSelectedSize('KVA')),
              //     Text('KVA'),
              //   ],
              // ),
              //
              // Row(
              //   children: <Widget>[
              //     Checkbox(
              //         value: selectedSizes.contains('inches (“)'),
              //         onChanged: (value) => changeSelectedSize('inches (“)')),
              //     Text('inches (“)'),
              //     Checkbox(
              //         value: selectedSizes.contains('VA'),
              //         onChanged: (value) => changeSelectedSize('VA')),
              //     Text('VA'),
              //     Checkbox(
              //         value: selectedSizes.contains('M'),
              //         onChanged: (value) => changeSelectedSize('M')),
              //     Text('M'),
              //     Checkbox(
              //         value: selectedSizes.contains('HP'),
              //         onChanged: (value) => changeSelectedSize('HP')),
              //     Text('HP'),
              //   ],
              // ),

              // select category
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Category: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: categoriesDropDown,
                    onChanged: changeSelectedCategory,
                    value: _currentCategory,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Brand: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: brandsDropDown,
                    onChanged: changeSelectedBrand,
                    value: _currentBrand,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Size: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: sizeDropDown,
                    onChanged: changeSelectedSize,
                    value: _currentSize,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Pow/Cap: ',
                      style: TextStyle(color: red),
                    ),
                  ),
                  DropdownButton(
                    items: powerCapacityDropDown,
                    onChanged: changeSelectedPowerCapacity,
                    value: _currentPowerCapacity,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Text('Sale'),
                      SizedBox(width: 10,),
                      Switch(value: onSale, onChanged: (value){
                        setState(() {
                          onSale = value;
                        });
                      }),
                    ],
                  ),

                  Row(
                    children: <Widget>[
                      Text('Featured'),
                      SizedBox(width: 10,),
                      Switch(value: featured, onChanged: (value){
                        setState(() {
                          featured = value;
                        });
                      }),
                    ],
                  ),

                ],
              ),


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: productNameController,
                  decoration: InputDecoration(hintText: 'Product name'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the product name';
                    } else if (value.length > 20) {
                      return 'Product name cant have more than 20 letters';
                    }
                  },
                ),
              ),

//
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Quantity',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the product name';
                    }
                  },
                ),
              ),

              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("General Price"),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: priceController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Price',
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'You must enter the product name';
                        }
                      },
                    ),
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Franchise Price"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: partnerFranchiseController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Franchise',
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'You must enter the product name';
                            //   }
                            // },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("IBO Price"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: partnerIBOController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'IBO',
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'You must enter the product name';
                            //   }
                            // },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Agent Price"),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: TextFormField(
                            controller: partnerAgentController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'Agent',
                            ),
                            // validator: (value) {
                            //   if (value.isEmpty) {
                            //     return 'You must enter the product name';
                            //   }
                            // },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),


              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: descriptionController,
                  // keyboardType: TextInputType.number,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Description',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'You must enter the description';
                    }
                  },
                ),
              ),





              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlatButton(
                        color: red,
                        textColor: white,
                        child: Text(widget.isEdit == true ? "Update" : "Add"),
                        onPressed: () {
                          if(widget.isEdit == true) {
                            validateAndUpdate();
                            return;
                          }
                          validateAndUpload();
                        },
                      ),
                      FlatButton(
                        color: red,
                        textColor: white,
                        child: Text('Preview'),
                        onPressed: () {
                          // Map products = {};
                          //
                          // if (_image1 == null) {
                          //   if(widget.productModel != null) {
                          //     products = {
                          //       "picture": widget.productModel.picture,
                          //       "images": [],
                          //       "name": "",
                          //       "price": 0,
                          //       "size": "",
                          //       "description": ""
                          //     };
                          //   }
                          // } else {
                          //
                          //   products = {
                          //     "picture": "",
                          //     "images": [],
                          //     "name": "",
                          //     "price": 0,
                          //     "size": "",
                          //     "description": ""
                          //   };
                          // }
                          // Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPreview(product: products)));
                        },
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    // print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      if(widget.productModel != null) {
        _currentCategory = widget.productModel.category;
      }
      else {
        Map<String, dynamic> data = categories[0].data();
        _currentCategory = data['category'];
      }
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    // print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandosDropDown();
      if(widget.productModel != null) {
        _currentBrand = widget.productModel.brand;
      }
      else {
        Map<String, dynamic> data = brands[0].data();
        _currentBrand = data['brand'];
      }
    });
  }

  _getPowerCapacities() async {
    List<DocumentSnapshot> data = await _powerCapacityService.getPowerCapacities();
    // print(data.length);
    setState(() {
      power_capacities = data;
      powerCapacityDropDown = getPowerCapacityDropDown();
      if(widget.productModel != null) {
        // dynamic aStr = widget.productModel.size.replaceAll(new RegExp(r'[^A-Za-z]'),'');
        // print(aStr);
        _currentPowerCapacity = widget.productModel.size.replaceAll(new RegExp(r'[^A-Za-z]'),'');
      }
      else {
        Map<String, dynamic> data = power_capacities[0].data();
        _currentPowerCapacity = data['power_capacity'];
      }
    });
  }

  _getSizes() async {
    List<DocumentSnapshot> data = await _sizeService.getSizes();
    // print(data.length);
    setState(() {
      sizes = data;
      sizeDropDown = getSizeDropDown();
      if(widget.productModel != null) {
        // dynamic aStr = widget.productModel.size.replaceAll(new RegExp(r'[^A-Za-z]'),'');
        // print(aStr);
        _currentSize = widget.productModel.size.replaceAll(new RegExp(r'[^0-9]'),'');
      }
      else {
        Map<String, dynamic> data = sizes[0].data();
        _currentSize = data['size'];
      }
    });
  }

  changeSelectedCategory(String selectedCategory) {
    setState(() => _currentCategory = selectedCategory);
  }

  changeSelectedBrand(String selectedBrand) {
    setState(() => _currentBrand = selectedBrand);
  }

  changeSelectedPowerCapacity(String selectedPowerCapacity) {
    setState(() => _currentPowerCapacity = selectedPowerCapacity);
  }

  changeSelectedSize(String selectedSize) {
    setState(() => _currentSize = selectedSize);
  }

  // void changeSelectedSize(String size) {
  //   if (selectedSizes.contains(size)) {
  //     setState(() {
  //       selectedSizes.remove(size);
  //     });
  //   } else {
  //     setState(() {
  //       selectedSizes.insert(0, size);
  //     });
  //   }
  // }

  void _selectImage(Future<PickedFile> pickImage, int imageNumber) async {
    PickedFile tempImg = await pickImage;
    switch (imageNumber) {
      case 1:
        setState(() => _image1 = tempImg);
        break;
      case 2:
        setState(() => _image2 = tempImg);
        break;
      case 3:
        setState(() => _image3 = tempImg);
        break;
    }
  }

  Widget _displayChild1() {
    if (_image1 == null) {
      if(widget.productModel != null) {
        return Image.network(
          widget.productModel.picture,
          fit: BoxFit.fill,
          width: double.infinity,
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {

      return Image.file(
        File(_image1.path),
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      if(widget.productModel != null && widget.productModel.images.length > 0) {
        return Image.network(
          widget.productModel.images[1],
          fit: BoxFit.fill,
          width: double.infinity,
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        File(_image2.path),
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      if(widget.productModel != null && widget.productModel.images.length > 0) {
        return Image.network(
          widget.productModel.images[2],
          fit: BoxFit.fill,
          width: double.infinity,
        );
      }
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        File(_image3.path),
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  // void _selectImage(Future<File> pickImage) async {
  //   File tempImg = await pickImage;
  //   setState(() => _image1 = tempImg);
  // }
  //
  // Widget _displayChild1() {
  //   if (_image1 == null) {
  //     return Padding(
  //       padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
  //       child: new Icon(
  //         Icons.add,
  //         color: grey,
  //       ),
  //     );
  //   } else {
  //     return Image.file(
  //       _image1,
  //       fit: BoxFit.fill,
  //       width: double.infinity,
  //     );
  //   }
  // }

  validateAndUpdate() async {
    if (_formKey.currentState.validate()) {
      if (
            widget.productModel.images.isEmpty &&
            widget.productModel.images.length != 3 &&
            (
                (_image2 != null && _image3 == null) ||
                (_image2 == null && _image3 != null))
      ){
          return;
      }

      // if (_image1 != null || _image2 != null || _image3 != null) {
        setState(() => isLoading = true);
        // if (_image1 != null && _image2 != null && _image3 != null) {
        // if (selectedSizes.isNotEmpty) {
        String imageUrl;
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;

        final FirebaseStorage storage = FirebaseStorage.instance;

        UploadTask task1;
        TaskSnapshot snapshot1;
        if (_image1 != null) {
          final String picture1 =
              "1${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          task1 =
              storage.ref().child(picture1).putFile(File(_image1.path));

          snapshot1 =
          await task1.then((snapshot) => snapshot);
        }

        TaskSnapshot snapshot2;
        TaskSnapshot snapshot3;

        if (_image2 != null) {
          final String picture2 =
              "2${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          UploadTask task2 =
          storage.ref().child(picture2).putFile(File(_image2.path));

          snapshot2 =
          await task2.then((snapshot) => snapshot);
        }

        if (_image3 != null) {
          final String picture3 =
              "3${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          UploadTask task3 =
          storage.ref().child(picture3).putFile(File(_image3.path));

          // TaskSnapshot snapshot1 =
          // await task1.then((snapshot) => snapshot);
          // TaskSnapshot snapshot2 =
          // await task2.then((snapshot) => snapshot);

          snapshot3 =
          await task3.then((snapshot) => snapshot);
        }

        // if (task1 != null) {
        //   task1.then((snapshot1) async {
        if (snapshot1 != null) {
          imageUrl = await snapshot1.ref.getDownloadURL();
          imageUrl1 = await snapshot1.ref.getDownloadURL();
        }

        if (snapshot2 != null) {
          // imageUrl1 = await snapshot1.ref.getDownloadURL();
          imageUrl2 = await snapshot2.ref.getDownloadURL();
          // imageUrl3 = await snapshot3.ref.getDownloadURL();
        }

        if (snapshot3 != null) {
          imageUrl3 = await snapshot3.ref.getDownloadURL();
        }

        List<String> imageList = [];

        // if (widget.productModel != null && widget.isEdit == true) {
        if (widget.productModel.images.isNotEmpty && widget.productModel.images.length == 3) {
          imageList = [
            snapshot1 != null ? imageUrl1 : widget.productModel.picture,
            snapshot2 != null ? imageUrl2 : widget.productModel.images[1],
            snapshot3 != null ? imageUrl3 : widget.productModel.images[2]
          ];
        } else if (snapshot2 != null && snapshot3 != null) {
          imageList = [
            snapshot1 != null ? imageUrl1 : widget.productModel.picture,
            imageUrl2,
            imageUrl3
          ];
        } else {
          imageList = [];
        }
        productService.updateProduct({
          "id": widget.productModel.id,
          "name": productNameController.text,
          "price": double.parse(
              priceController.text.split(".").join("")),
          "franchise": double.parse(
              partnerFranchiseController.text.split(".").join("")),
          "ibo": double.parse(
              partnerIBOController.text.split(".").join("")),
          "agent": double.parse(
              partnerAgentController.text.split(".").join("")),
          "size": _currentSize + " " + _currentPowerCapacity,
          // "colors": colors,
          "picture": snapshot1 != null ? imageUrl : widget.productModel
              .picture,
          "images": imageList,
          "quantity": int.parse(quantityController.text),
          "brand": _currentBrand,
          "category": _currentCategory,
          'sale': onSale,
          'featured': featured,
          'description': descriptionController.text
        });
        // }
        _formKey.currentState.reset();
        setState(() => isLoading = false);
        Navigator.pop(context);
        // });
        // }

      // }

//       else {
//         setState(() => isLoading = false);
//
// //        Fluttertoast.showToast(msg: 'all the images must be provided');
//       }
    }
  }

  validateAndUpload() async {
    if (_formKey.currentState.validate()) {

      if (_image1 != null) {
        setState(() => isLoading = true);
        // if (_image1 != null && _image2 != null && _image3 != null) {
        // if (selectedSizes.isNotEmpty) {
        String imageUrl;
        String imageUrl1;
        String imageUrl2;
        String imageUrl3;

        final FirebaseStorage storage = FirebaseStorage.instance;

        UploadTask task1;
        // TaskSnapshot snapshot1;
        if (_image1 != null) {
          final String picture1 =
              "1${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          task1 =
          storage.ref().child(picture1).putFile(File(_image1.path));

          // snapshot1 =
          // await task1.then((snapshot) => snapshot);
        }

        TaskSnapshot snapshot2;
        TaskSnapshot snapshot3;

        if (_image2 != null) {
          final String picture2 =
              "2${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          UploadTask task2 =
          storage.ref().child(picture2).putFile(File(_image2.path));

          snapshot2 =
          await task2.then((snapshot) => snapshot);
        }

        if (_image3 != null) {
          final String picture3 =
              "3${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          UploadTask task3 =
          storage.ref().child(picture3).putFile(File(_image3.path));

          // TaskSnapshot snapshot1 =
          // await task1.then((snapshot) => snapshot);
          // TaskSnapshot snapshot2 =
          // await task2.then((snapshot) => snapshot);

          snapshot3 =
          await task3.then((snapshot) => snapshot);
        }

        // if (task1 != null) {
          task1.then((snapshot1) async {
            if (snapshot1 != null) {
              imageUrl = await snapshot1.ref.getDownloadURL();
              imageUrl1 = await snapshot1.ref.getDownloadURL();
            }

            if (snapshot2 != null) {
              // imageUrl1 = await snapshot1.ref.getDownloadURL();
              imageUrl2 = await snapshot2.ref.getDownloadURL();
              // imageUrl3 = await snapshot3.ref.getDownloadURL();
            }

            if (snapshot3 != null) {
              imageUrl3 = await snapshot3.ref.getDownloadURL();
            }

            List<String> imageList = [];


            imageList = [imageUrl1, imageUrl2, imageUrl3];

            productService.uploadProduct({
              "name": productNameController.text,
              "price": double.parse(
                  priceController.text.split(".").join("")),
              "franchise": double.parse(
                  partnerFranchiseController.text.split(".").join("")),
              "ibo": double.parse(
                  partnerIBOController.text.split(".").join("")),
              "agent": double.parse(
                  partnerAgentController.text.split(".").join("")),
              "size": _currentSize + " " + _currentPowerCapacity,
              // "colors": colors,
              "picture": imageUrl,
              "images": snapshot2 != null && snapshot3 != null
                  ? imageList
                  : [
              ],
              "quantity": int.parse(quantityController.text),
              "brand": _currentBrand,
              "category": _currentCategory,
              'sale': onSale,
              'featured': featured,
              'description': descriptionController.text
            });
            _formKey.currentState.reset();
            setState(() => isLoading = false);
            Navigator.pop(context);
          });
        // }

        // } else {
        //   setState(() => isLoading = false);
        // }
      }
      else {
        setState(() => isLoading = false);

//        Fluttertoast.showToast(msg: 'all the images must be provided');
      }
    }
  }
}
