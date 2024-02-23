import 'package:json_annotation/json_annotation.dart';
part 'single_product.g.dart';

@JsonSerializable()
class Single_product {
  String? status;
  String? time;
  Data? data;

  Single_product({this.status, this.time, this.data});

  Single_product.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  int? id;
  String? name;
  int? categoryId;
  String? price;
  int? productStatusId;
  List<dynamic>? cover;
  String? createdDate;
  String? description;
  String? createdOn;
  String? address;
  String? productType;
  UserDetail? userDetail;

  Data(
      {this.id,
      this.name,
      this.categoryId,
      this.price,
      this.productStatusId,
      this.cover,
      this.createdDate,
      this.description,
      this.createdOn,
      this.address,
      this.productType,
      this.userDetail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    categoryId = json['categoryId'];
    price = json['price'];
    productStatusId = json['productStatusId'];
    cover = json['cover'].cast<String>();
    createdDate = json['createdDate'];
    description = json['description'];
    createdOn = json['createdOn'];
    address = json['address'];
    productType = json['productType'];
    userDetail = json['userDetail'] != null
        ? new UserDetail.fromJson(json['userDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['categoryId'] = this.categoryId;
    data['price'] = this.price;
    data['productStatusId'] = this.productStatusId;
    data['cover'] = this.cover;
    data['createdDate'] = this.createdDate;
    data['description'] = this.description;
    data['createdOn'] = this.createdOn;
    data['address'] = this.address;
    data['productType'] = this.productType;
    if (this.userDetail != null) {
      data['userDetail'] = this.userDetail!.toJson();
    }
    return data;
  }
}

class UserDetail {
  int? userId;
  String? userName;
  int? mobileNumber;
  String? email;

  UserDetail({this.userId, this.userName, this.mobileNumber, this.email});

  UserDetail.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    userName = json['userName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    return data;
  }
}
