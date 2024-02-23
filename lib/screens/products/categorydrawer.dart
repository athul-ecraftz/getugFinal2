import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/categories/categories.dart';
import 'package:getug/models/get_categoryproduct_byname/category_productbyname.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class CategoryDrawer extends StatefulWidget {
  static String routeName = '/CategoryDrawer';
  final Function(String, String) onCategorySelected;
  const CategoryDrawer({Key? key, required this.onCategorySelected})
      : super(key: key);

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  late Future<Categories> _categoriesFuture;
  String selectedCategory = 'All';
  category_productbyname? fetchpost;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = getCategories();
    _loadData();
  }

  _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final UserId = prefs.getString('userid');
    final getpost = await getcategory(UserId.toString());
    print(UserId);
    userId:
    int.parse(UserId!);
    setState(() {
      fetchpost = getpost;
    });
  }

  Future<Categories> getCategories() async {
    var response = await getJson("/api/homePageGetCategory");
    Categories? categories;
    print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      categories = Categories.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      categories = Categories.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return categories!;
  }

  Future<category_productbyname> getcategory(String? UserId) async {
    var response = await getJson(
        "/api/getCategoryProductByName?catId=$selectedCategory&UserId=$UserId&limit=20&stateId=0");
    category_productbyname? cat;
    List<Data>? d;
    print(response.toString());
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      print(jsonResponse);
      cat = category_productbyname.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var itemCount = jsonResponse['data'];
      cat = category_productbyname.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return cat!;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: const EdgeInsets.all(0),
        children: [
          ListTile(
            title: Row(
              children: [
                const SizedBox(width: 20),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black, width: 2),
                    ),
                  ),
                  child: const Text(
                    'Filter',
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
          const ListTile(
            title: Text(
              'Categories',
              style: TextStyle(color: Colors.black, fontSize: 18),
            ),
          ),
          FutureBuilder<Categories>(
            future: _categoriesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData ||
                  snapshot.data?.data?.isEmpty == true) {
                return Center(child: Text('No data available'));
              } else {
                var categories = snapshot.data?.data;
                return Column(
                  children: [
                    for (var category in categories!)
                      buildCategoryRadioTile(category),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  ListTile buildCategoryRadioTile(Category category) {
    return ListTile(
      title: Row(
        children: [
          Radio(
            value: category.categoryId.toString(),
            groupValue: selectedCategory,
            onChanged: (value) {
              setState(() {
                selectedCategory = value.toString();
              });
              print('Selected Category: $selectedCategory');

              widget.onCategorySelected(
                selectedCategory,
                category.categoryName ?? '',
              );
              Navigator.pop(context);
            },
          ),
          Text(
            category.categoryName ?? '',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ],
      ),
      onTap: () {
        setState(() {
          selectedCategory = category.categoryId.toString();
        });
        widget.onCategorySelected(
            selectedCategory, category.categoryName ?? '');
        Navigator.pop(context);
      },
    );
  }
}
