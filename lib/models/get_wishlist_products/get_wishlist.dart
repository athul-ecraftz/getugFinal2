import 'package:json_annotation/json_annotation.dart';
part 'get_wishlist.g.dart';

@JsonSerializable()
class get_wishlist {
  String? status;
  String? time;
  List<Data>? data;

  get_wishlist({this.status, this.time, this.data});

  get_wishlist.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? name;
  String? price;
  String? conditionName;
  int? productStatusId;
  String? cover;
  String? productType;
  UserDetail? userDetail;

  Data(
      {this.id,
      this.name,
      this.price,
      this.conditionName,
      this.productStatusId,
      this.cover,
      this.productType,
      this.userDetail});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    conditionName = json['conditionName'];
    productStatusId = json['productStatusId'];
    cover = json['cover'];
    productType = json['productType'];
    userDetail = json['userDetail'] != null
        ? new UserDetail.fromJson(json['userDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['conditionName'] = this.conditionName;
    data['productStatusId'] = this.productStatusId;
    data['cover'] = this.cover;
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
