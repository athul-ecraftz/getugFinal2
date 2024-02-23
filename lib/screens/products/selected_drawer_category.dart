import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/get_categoryproduct_byname/category_productbyname.dart';
import 'dart:convert' as convert;
import 'package:shared_preferences/shared_preferences.dart';

class SelectedCategory extends StatefulWidget {
  const SelectedCategory({super.key});

  @override
  State<SelectedCategory> createState() => _SelectedCategoryState();
}

class _SelectedCategoryState extends State<SelectedCategory> {
  Future<category_productbyname> getcategory(String? UserId) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userid');
    final selectedCategory = prefs.getString('selectedCategory');

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

  category_productbyname? fetchpost;

  @override
  void initState() {
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
