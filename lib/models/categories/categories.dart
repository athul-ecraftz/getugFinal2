import 'package:json_annotation/json_annotation.dart';
part 'categories.g.dart';

@JsonSerializable()
class Categories {
  String? status;
  String? time;
  List<Category>? data;

  Categories({this.status, this.time, this.data});

  Categories.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Category>[];
      json['data'].forEach((v) {
        data!.add(new Category.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Category {
  int? categoryId;
  String? categoryName;
  List<SubCategory>? subCategorys;

  Category({this.categoryId, this.categoryName, this.subCategorys});

  Category.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    if (json['subCategorys'] != null) {
      subCategorys = <SubCategory>[];
      json['subCategorys'].forEach((v) {
        subCategorys!.add(new SubCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    if (this.subCategorys != null) {
      data['subCategorys'] = this.subCategorys!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategory {
  int? categoryId;
  String? categoryName;

  SubCategory({this.categoryId, this.categoryName});

  SubCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['categoryName'] = this.categoryName;
    return data;
  }
}
