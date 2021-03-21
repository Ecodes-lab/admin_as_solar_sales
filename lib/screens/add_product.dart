import 'dart:io';

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
  TextEditingController quatityController = TextEditingController();
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

  File _image1;
  File _image2;
  File _image3;
  bool isLoading = false;

  @override
  void initState() {
    _getCategories();
    _getBrands();
    _getPowerCapacities();
    _getSizes();
  }

  List<DropdownMenuItem<String>> getCategoriesDropdown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < categories.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(categories[i].data()['category']),
                value: categories[i].data()['category']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getBrandosDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < brands.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(brands[i].data()['brand']),
                value: brands[i].data()['brand']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getPowerCapacityDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < power_capacities.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(power_capacities[i].data()['power_capacity']),
                value: power_capacities[i].data()['power_capacity']));
      });
    }
    return items;
  }

  List<DropdownMenuItem<String>> getSizeDropDown() {
    List<DropdownMenuItem<String>> items = new List();
    for (int i = 0; i < sizes.length; i++) {
      setState(() {
        items.insert(
            0,
            DropdownMenuItem(
                child: Text(sizes[i].data()['size']),
                value: sizes[i].data()['size']));
      });
    }
    return items;
  }

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
          "add product",
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
                          onPressed: () {
                            _selectImage(
                                ImagePicker.pickImage(
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
                                ImagePicker.pickImage(
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
                              ImagePicker.pickImage(
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
                  controller: quatityController,
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





              FlatButton(
                color: red,
                textColor: white,
                child: Text('add product'),
                onPressed: () {
                  validateAndUpload();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  _getCategories() async {
    List<DocumentSnapshot> data = await _categoryService.getCategories();
    print(data.length);
    setState(() {
      categories = data;
      categoriesDropDown = getCategoriesDropdown();
      _currentCategory = categories[0].data()['category'];
    });
  }

  _getBrands() async {
    List<DocumentSnapshot> data = await _brandService.getBrands();
    print(data.length);
    setState(() {
      brands = data;
      brandsDropDown = getBrandosDropDown();
      _currentBrand = brands[0].data()['brand'];
    });
  }

  _getPowerCapacities() async {
    List<DocumentSnapshot> data = await _powerCapacityService.getPowerCapacities();
    print(data.length);
    setState(() {
      power_capacities = data;
      powerCapacityDropDown = getPowerCapacityDropDown();
      _currentPowerCapacity = power_capacities[0].data()['power_capacity'];
    });
  }

  _getSizes() async {
    List<DocumentSnapshot> data = await _sizeService.getSizes();
    print(data.length);
    setState(() {
      sizes = data;
      sizeDropDown = getSizeDropDown();
      _currentSize = sizes[0].data()['size'];
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

  void _selectImage(Future<File> pickImage, int imageNumber) async {
    File tempImg = await pickImage;
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
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image1,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild2() {
    if (_image2 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image2,
        fit: BoxFit.fill,
        width: double.infinity,
      );
    }
  }

  Widget _displayChild3() {
    if (_image3 == null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 50, 14, 50),
        child: new Icon(
          Icons.add,
          color: grey,
        ),
      );
    } else {
      return Image.file(
        _image3,
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



  void validateAndUpload() async {
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
        final String picture1 =
            "1${DateTime.now().millisecondsSinceEpoch.toString()}.jpg";
        UploadTask task1 =
        storage.ref().child(picture1).putFile(_image1);

        TaskSnapshot snapshot2;
        TaskSnapshot snapshot3;

        if (_image2 != null && _image3 != null) {
          final String picture2 =
              "2${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          UploadTask task2 =
          storage.ref().child(picture2).putFile(_image2);
          final String picture3 =
              "3${DateTime
              .now()
              .millisecondsSinceEpoch
              .toString()}.jpg";
          UploadTask task3 =
          storage.ref().child(picture3).putFile(_image3);

          // TaskSnapshot snapshot1 =
          // await task1.then((snapshot) => snapshot);
          // TaskSnapshot snapshot2 =
          // await task2.then((snapshot) => snapshot);

          snapshot2 =
          await task2.then((snapshot) => snapshot);
          snapshot3 =
          await task3.then((snapshot) => snapshot);
        }

        task1.then((snapshot1) async {
          imageUrl = await snapshot1.ref.getDownloadURL();

          if (snapshot2 != null && snapshot2 != null) {
            imageUrl1 = await snapshot1.ref.getDownloadURL();
            imageUrl2 = await snapshot2.ref.getDownloadURL();
            imageUrl3 = await snapshot3.ref.getDownloadURL();
          }

          List<String> imageList = [imageUrl1, imageUrl2, imageUrl3];

          productService.uploadProduct({
            "name":productNameController.text,
            "price":double.parse(priceController.text.split(".").join("")),
            "franchise": double.parse(partnerFranchiseController.text.split(".").join("")),
            "ibo": double.parse(partnerIBOController.text.split(".").join("")),
            "agent": double.parse(partnerAgentController.text.split(".").join("")),
            "size":_currentSize + " " + _currentPowerCapacity,
            // "colors": colors,
            "picture":imageUrl,
            "images": snapshot2 != null && snapshot3 != null ? imageList : [],
            "quantity":int.parse(quatityController.text),
            "brand":_currentBrand,
            "category":_currentCategory,
            'sale':onSale,
            'featured':featured,
            'description':descriptionController.text
          });
          _formKey.currentState.reset();
          setState(() => isLoading = false);
          Navigator.pop(context);
        });
        // } else {
        //   setState(() => isLoading = false);
        // }
      } else {
        setState(() => isLoading = false);

//        Fluttertoast.showToast(msg: 'all the images must be provided');
      }
    }
  }
}
