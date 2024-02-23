import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/default_button.dart';
import 'dart:convert' as convert;
import 'package:getug/models/categories/categories.dart';
import 'package:getug/models/insert_product/insert_product.dart';
import 'package:getug/models/my_post/getProductById.dart';
import 'package:getug/models/productcondition/product_condition.dart';
import 'package:getug/models/productstatus/productstatus.dart';
import 'package:getug/models/producttype/producttype.dart';
import 'package:getug/models/states/states.dart';
import 'package:getug/screens/forgot_password/components/forgot_otp.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/products/product_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdatePost extends StatefulWidget {
  final String? productId;

  const UpdatePost({
    super.key,
    required this.productId,
  });

  @override
  State<UpdatePost> createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController TitleController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController PriceController = TextEditingController();
  final TextEditingController PhoneNumberController = TextEditingController();
  final TextEditingController AddressController = TextEditingController();

  final List<String> errors = [];
  late String category;
  late String subcategory;
  late String state;
  late String posttype;
  late String title;
  late String condition;
  late String description;
  late int price;
  late int phonenumber;
  late String address;
  bool remember = false;

  Future<insert_product> myproduct(
      {required String category,
      required String subcategory,
      required String state,
      required String posttype,
      required String title,
      required String condition,
      required String description,
      required int price,
      required int phonenumber,
      required String address,
      required int userid}) async {
    Map<String, String> data = {
      "categoryId": "$category",
      "subCategoryId": "$subcategory",
      "productTitle": "$title",
      "description": "$description",
      "price": "$price",
      "productConditionId": "$condition",
      "userId": "$userid",
      "stateId": "$state",
      "address": "$address",
      "productStatusId": "1",
      "phoneNumber": "$phonenumber",
      "productTypeId": "$posttype"
    };

    insert_product? Continue;
    var response = await postJson("/api/insertproduct", data);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("New= $jsonResponse");

      var itemCount = jsonResponse['data'];
      Continue = insert_product.fromJson(jsonResponse);
      print('Number of books about http: $jsonResponse}.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);

      // jsonResponse['data'] = null;
      var itemCount = jsonResponse['data'];

      print(itemCount);
      Continue = insert_product.fromJson(jsonResponse);
      print(Continue);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return Continue!;
  }

  String categoryValue = 'Item 1';
  String stateValue = 'State 1';
  List<Category> categoriesList = [];
  List<Map<String, dynamic>> categoryList = [];
  List<States> stateList = [];
  List<Map<String, dynamic>> statesList = [];
  String? selectedCategory;
  String? selectedSubCategory;
  String? selectedstate;
  String? postType;
  List<String>? postTypeList = ['For Sale', 'For Rend'];
  String? Condition;
  List<String>? ConditionList = [
    'Brand New',
    'Like New',
    'Lightly Used',
    'Well Used',
    'Heavily Used'
  ];

  List<ProductType> productList = [];
  List<Map<String, dynamic>> productsList = [];
  List<ProductCondition> productconditionList = [];
  List<Map<String, dynamic>> productconditionsList = [];
  List<ProductStatus> productstatusList = [];
  List<Map<String, dynamic>> productstatusLists = [];

  getproduct? productDetails;

  @override
  void initState() {
    super.initState();
    productList.add(ProductType(productTypeId: 1, productTypeName: "For Sale"));
    productList.add(ProductType(productTypeId: 2, productTypeName: "For Rent"));

    productconditionList.add(ProductCondition(
        productConditionId: 1, productConditionName: "Brand New"));
    productconditionList.add(ProductCondition(
        productConditionId: 2, productConditionName: "Like New"));
    productconditionList.add(ProductCondition(
        productConditionId: 3, productConditionName: "Lightly Used"));
    productconditionList.add(ProductCondition(
        productConditionId: 4, productConditionName: "Well Used"));
    productconditionList.add(ProductCondition(
        productConditionId: 5, productConditionName: "Heavily Used"));

//  productstatusList.add(ProductStatus(productStatusId: 1, productStatusName: "For Sale"));
//     productstatusList.add(ProductStatus(productStatusId: 2, productStatusName: "For Rent"));

    fetchData();
    fetchData1();
    fetchMyPost(widget.productId.toString());
  }

  Future<void> fetchData() async {
    try {
      var response = await getJson("/api/homePageGetCategory");
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        var result = jsonResponse['data'];
        setState(() {
          categoryList = List<Map<String, dynamic>>.from(result);
          categoriesList = categoryList
              .map((category) => Category.fromJson(category))
              .toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  Future<void> fetchMyPost(String productId) async {
    var url = "/api/getProductById?productId=$productId";
    getproduct? ap;

    var response = await getJson(url);
    print(['productId']);

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      print(jsonResponse);
      setState(() {
        productDetails = getproduct.fromJson(jsonResponse);
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  List<SubCategory> getSubcategories(int categoryId) {
    Category selectedCategory = categoriesList
        .firstWhere((category) => category.categoryId == categoryId);
    return selectedCategory.subCategorys ?? [];
  }

  Future<void> fetchData1() async {
    try {
      var response = await getJson("/api/getAllStates");
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        var result = jsonResponse['data'];
        setState(() {
          statesList = List<Map<String, dynamic>>.from(result);
          stateList =
              statesList.map((state) => States.fromJson(state)).toList();
        });
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (error) {
      print('Error fetching data: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 9, vertical: 10),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Category",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              DropdownButton<String>(
                value: selectedCategory,
                hint: const Text("Category"),
                isExpanded: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue;
                    // _selectedSubCategory = null;
                  });
                },
                items: categoriesList.map((category) {
                  return DropdownMenuItem<String>(
                    value: category.categoryId.toString(),
                    child: Text(category.categoryName!),
                  );
                }).toList(),
              ),
              SizedBox(height: 6),
              if (selectedCategory != null)
                const Text(
                  "Sub category",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              DropdownButton<String>(
                value: selectedSubCategory,
                hint: const Text("Subcategory"),
                isExpanded: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedSubCategory = newValue;
                  });
                },
                items: getSubcategories(int.parse(selectedCategory!))
                    .map((subcategory) {
                  return DropdownMenuItem<String>(
                    value: subcategory.categoryId.toString(),
                    child: Text(subcategory.categoryName!),
                  );
                }).toList(),
              ),
              SizedBox(height: 6),
              const Text(
                "State",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              DropdownButton<String>(
                value: selectedstate,
                hint: const Text("State"),
                isExpanded: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedstate = newValue;
                  });
                },
                items: stateList.map((states) {
                  return DropdownMenuItem<String>(
                    value: states.locationId.toString(),
                    child: Text(states.locationName!),
                  );
                }).toList(),
              ),
              SizedBox(height: 6),
              const Text(
                "Post type",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              DropdownButton2<String>(
                value: postType,
                hint: const Text("Post Type"),
                isExpanded: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    postType = newValue;
                  });
                },
                items: productList?.map((ProductType) {
                      return DropdownMenuItem<String>(
                        value: ProductType.productTypeId.toString(),
                        child: Text(ProductType.productTypeName!),
                      );
                    }).toList() ??
                    [],
              ),
              SizedBox(height: 6),
              const Text(
                "Title",
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextFormField(
                controller: TitleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              DropdownButton2<String>(
                value: Condition,
                hint: const Text("Condition"),
                isExpanded: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onChanged: (String? newValue) {
                  setState(() {
                    Condition = newValue;
                  });
                },
                items: productconditionList?.map((ProductCondition) {
                      return DropdownMenuItem<String>(
                        value: ProductCondition.productConditionId.toString(),
                        child: Text(ProductCondition.productConditionName!),
                      );
                    }).toList() ??
                    [],
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: DescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: PriceController,
                decoration: InputDecoration(
                  labelText: 'Price',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: PhoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a Phone Number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 5),
              TextFormField(
                controller: AddressController,
                decoration: InputDecoration(
                  labelText: 'Address',
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.black, width: 2.0),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an address';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 55,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Color.fromARGB(255, 22, 5, 172)),
                  ),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    if (_formKey.currentState != null &&
                        _formKey.currentState!.validate()) {
                      final userid = await prefs.getString('userid');
                      _formKey.currentState!.save();
                      insert_product s = await myproduct(
                        category: selectedCategory ?? '',
                        subcategory: selectedSubCategory ?? '',
                        state: selectedstate ?? '',
                        posttype: postType ?? '',
                        title: TitleController.text,
                        condition: Condition ?? '',
                        description: DescriptionController.text,
                        price: int.parse(PriceController.text),
                        phonenumber: int.parse(PhoneNumberController.text),
                        address: AddressController.text,
                        userid: int.parse(userid!),
                      );
                      print(s.data);
                      if (s != null) {
                        Navigator.pushNamed(
                          context,
                          productImage.routeName,
                          arguments: {
                            "categoryId": selectedCategory ?? '',
                            "subCategoryId": selectedSubCategory ?? '',
                            "productTitle": TitleController.text,
                            "description": DescriptionController.text,
                            "price": PriceController.text,
                            "productConditionId": Condition ?? '',
                            "userId": int.parse(userid!),
                            "stateId": selectedstate ?? '',
                            "address": AddressController.text,
                            "productStatusId": 1,
                            "phoneNumber": PhoneNumberController.text,
                            "productTypeId": postType ?? '',
                            "productid": s.data.toString(),
                          },
                        );
                      }
                    }
                  },
                  child: const Text(
                    "Continue",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),

                // child: DefaultButton(
                //   text: "Continue",
                //   press: () async {
                //     final prefs = await SharedPreferences.getInstance();
                //     if (_formKey.currentState != null &&
                //         _formKey.currentState!.validate()) {
                //       final userid = await prefs.getString('userid');
                //       _formKey.currentState!.save();
                //       insert_product s = await myproduct(
                //         category: selectedCategory ?? '',
                //         subcategory: selectedSubCategory ?? '',
                //         state: selectedstate ?? '',
                //         posttype: postType ?? '',
                //         title: TitleController.text,
                //         condition: Condition ?? '',
                //         description: DescriptionController.text,
                //         price: int.parse(PriceController.text),
                //         phonenumber: int.parse(PhoneNumberController.text),
                //         address: AddressController.text,
                //         userid: int.parse(userid!),
                //       );
                //       print(s.data);
                //       if (s != null) {
                //         Navigator.pushNamed(
                //           context,
                //           productImage.routeName,
                //           arguments: {
                //             "categoryId": selectedCategory ?? '',
                //             "subCategoryId": selectedSubCategory ?? '',
                //             "productTitle": TitleController.text,
                //             "description": DescriptionController.text,
                //             "price": PriceController.text,
                //             "productConditionId": Condition ?? '',
                //             "userId": int.parse(userid!),
                //             "stateId": selectedstate ?? '',
                //             "address": AddressController.text,
                //             "productStatusId": 1,
                //             "phoneNumber": PhoneNumberController.text,
                //             "productTypeId": postType ?? '',
                //             "productid": s.data.toString(),
                //           },
                //         );
                //       }
                //     }
                //   },
                // ),
              ),
              SizedBox(height: 16),
              Text(widget.productId.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
