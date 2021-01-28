import 'package:admin_as_solar_sales/models/user.dart';
import 'package:admin_as_solar_sales/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:admin_as_solar_sales/providers/app_states.dart';
import 'package:admin_as_solar_sales/widgets/small_card.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:provider/provider.dart';
import 'add_product.dart';
import '../db/category.dart';
import '../db/brand.dart';
import '../db/size.dart';
import '../db/power_capacity.dart';


enum Page { dashboard, manage }

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<charts.Series<Task, String>> _seriesPieData;
  Page _selectedPage = Page.dashboard;
  MaterialColor active = Colors.red;
  MaterialColor notActive = Colors.grey;
  TextEditingController categoryController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController powerCapacityController = TextEditingController();
  GlobalKey<FormState> _categoryFormKey = GlobalKey();
  GlobalKey<FormState> _brandFormKey = GlobalKey();
  GlobalKey<FormState> _sizeFormKey = GlobalKey();
  GlobalKey<FormState> _powerCapacityFormKey = GlobalKey();
  BrandService _brandService = BrandService();
  SizeService _sizeService = SizeService();
  CategoryService _categoryService = CategoryService();
  PowerCapacityService _powerCapacityService = PowerCapacityService();

  // UserModel _userModel = UserModel();

  _getData(){
    var piedata = [
      new Task('Girls', 35.8, Color(0xff3366cc)),
      new Task('Women', 8.3, Color(0xff990099)),
      new Task('Pants', 10.8, Color(0xff109618)),
      new Task('Formal', 15.6, Color(0xfffdbe19)),
      new Task('Shoes', 19.2, Color(0xffff9900)),
      new Task('Other', 10.3, Color(0xffdc3912)),
    ];

    _seriesPieData.add(
      charts.Series(
        domainFn: (Task task, _) => task.task,
        measureFn: (Task task, _) => task.taskvalue,
        colorFn: (Task task, _) =>
            charts.ColorUtil.fromDartColor(task.colorval),
        id: 'Air Pollution',
        data: piedata,
        labelAccessorFn: (Task row, _) => '${row.taskvalue}',
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _seriesPieData = List<charts.Series<Task, String>>();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final appState = Provider.of<AppState>(context);

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.dashboard);
                      },
                      icon: Icon(
                        Icons.dashboard,
                        color: _selectedPage == Page.dashboard
                            ? active
                            : notActive,
                      ),
                      label: Text('Dashboard'))),
              Expanded(
                  child: FlatButton.icon(
                      onPressed: () {
                        setState(() => _selectedPage = Page.manage);
                      },
                      icon: Icon(
                        Icons.sort,
                        color:
                        _selectedPage == Page.manage ? active : notActive,
                      ),
                      label: Text('Manage'))),
            ],
          ),
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        // elevation: 0.0,
      backgroundColor: Colors.grey[200],
      body: _loadScreen(appState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          userProvider.signOut();
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.deepOrange,
      ),

    );
  }
  Widget _loadScreen(appState) {
    switch (_selectedPage) {
      case Page.dashboard:
        return ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: RichText(
                    // textAlign: TextAlign.left,
                    text: TextSpan(children: [
                      TextSpan(text: 'Revenue\n', style: TextStyle(fontSize: 25, color: Colors.grey)),
                      TextSpan(text: 'NGN 1287.99', style: TextStyle(fontSize: 40, color: Colors.black, fontWeight: FontWeight.w300)),

                    ]),
                  ),
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SmallCard(color2: Colors.indigo,color1: Colors.blue, icon: Icons.person_outline, value: 1265, title: 'Users',),
                      SmallCard(color2: Colors.indigo,color1: Colors.blue, icon: Icons.shopping_cart, value: 30, title: 'Orders',),
                    ],
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SmallCard(color2: Colors.black87,color1: Colors.black87, icon: Icons.attach_money, value: 65, title: 'Sales',),
                      SmallCard(color2: Colors.black,color1: Colors.black87, icon: Icons.shopping_basket, value: 230, title: 'Stock',),
                    ],
                  ),
                // ),

                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text('Sales per category', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey),),
                ),

                // Expanded(
                //   child: Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: Container(
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(15),
                //           color: Colors.white,
                //           boxShadow: [
                //             BoxShadow(
                //                 color: Colors.grey[400],
                //                 offset: Offset(1.0, 1.0),
                //                 blurRadius: 4
                //             )
                //           ]
                //       ),
                //       width: MediaQuery.of(context).size.width / 1.2,
                //       child: ListTile(
                //         title: charts.PieChart(
                //             _seriesPieData,
                //             animate: true,
                //             animationDuration: Duration(seconds: 3),
                //             behaviors: [
                //               new charts.DatumLegend(
                //                 outsideJustification: charts.OutsideJustification.endDrawArea,
                //                 horizontalFirst: false,
                //                 desiredMaxRows: 2,
                //                 cellPadding: new EdgeInsets.only(right: 4.0, bottom: 4.0),
                //               )
                //             ],
                //             defaultRenderer: new charts.ArcRendererConfig(
                //                 arcWidth: 30,
                //                 arcRendererDecorators: [
                //                   new charts.ArcLabelDecorator(
                //                       labelPosition: charts.ArcLabelPosition.inside)
                //                 ])),
                //       ),
                //     ),
                //   ),
                // )

              ],
            );
        break;
      case Page.manage:
        return ListView(
                    children: <Widget>[

                    ListTile(
                      leading: Icon(Icons.add),
                      title: Text("Add product"),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => AddProduct()));
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.change_history),
                      title: Text("Products list"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.add_circle),
                      title: Text("Add category"),
                      onTap: () {
                        _categoryAlert();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.category),
                      title: Text("Category list"),
                      onTap: () {},
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.add_circle_outline),
                      title: Text("Add brand"),
                      onTap: () {
                        _brandAlert();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.library_books),
                      title: Text("brand list"),
                      onTap: () {
                        _brandService.getBrands();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.line_weight),
                      title: Text("Add size"),
                      onTap: () {
                        _sizeAlert();
                      },
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(Icons.power),
                      title: Text("Add Power/Capacity"),
                      onTap: () {
                        _powerCapacityAlert();
                      },
                    ),
                    Divider(),
                ]
            );

        break;
      default:
        return Container();
    }
  }

  void _categoryAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _categoryFormKey,
        child: TextFormField(
          controller: categoryController,
          validator: (value){
            if(value.isEmpty){
              return 'category cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add category"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(categoryController.text != null){
            _categoryService.createCategory(categoryController.text);
          }
//          Fluttertoast.showToast(msg: 'category created');
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _brandAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _brandFormKey,
        child: TextFormField(
          controller: brandController,
          validator: (value){
            if(value.isEmpty){
              return 'brand cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add brand"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(brandController.text != null){
            _brandService.createBrand(brandController.text);
          }
//          Fluttertoast.showToast(msg: 'brand added');
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }

  void _sizeAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _sizeFormKey,
        child: TextFormField(
          controller: sizeController,
          validator: (value){
            if(value.isEmpty){
              return 'size cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add size"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(sizeController.text != null){
            _sizeService.createSize(sizeController.text);
          }
//          Fluttertoast.showToast(msg: 'brand added');
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }


  void _powerCapacityAlert() {
    var alert = new AlertDialog(
      content: Form(
        key: _powerCapacityFormKey,
        child: TextFormField(
          controller: powerCapacityController,
          validator: (value){
            if(value.isEmpty){
              return 'power cannot be empty';
            }
          },
          decoration: InputDecoration(
              hintText: "add power/capacity"
          ),
        ),
      ),
      actions: <Widget>[
        FlatButton(onPressed: (){
          if(powerCapacityController.text != null){
            _powerCapacityService.createPowerCapacity(powerCapacityController.text);
          }
//          Fluttertoast.showToast(msg: 'brand added');
          Navigator.pop(context);
        }, child: Text('ADD')),
        FlatButton(onPressed: (){
          Navigator.pop(context);
        }, child: Text('CANCEL')),

      ],
    );

    showDialog(context: context, builder: (_) => alert);
  }
}

class Task {
  String task;
  double taskvalue;
  Color colorval;

  Task(this.task, this.taskvalue, this.colorval);
}
