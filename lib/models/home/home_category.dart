import 'package:json_annotation/json_annotation.dart';
part 'home_category.g.dart';

@JsonSerializable()
class Category {
  String? status;
  String? time;
  List<Data>? data;

  Category({this.status, this.time, this.data});

  Category.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  int? categoryId;
  String? categoryName;
  List<SubCategorys>? subCategorys;

  Data({this.categoryId, this.categoryName, this.subCategorys});

  Data.fromJson(Map<String, dynamic> json) {
    categoryId = json['categoryId'];
    categoryName = json['categoryName'];
    if (json['subCategorys'] != null) {
      subCategorys = <SubCategorys>[];
      json['subCategorys'].forEach((v) {
        subCategorys!.add(new SubCategorys.fromJson(v));
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

class SubCategorys {
  int? categoryId;
  String? categoryName;

  SubCategorys({this.categoryId, this.categoryName});

  SubCategorys.fromJson(Map<String, dynamic> json) {
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
