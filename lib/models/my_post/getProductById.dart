import 'package:json_annotation/json_annotation.dart';
part 'getProductById.g.dart';

@JsonSerializable()
class getproduct {
  String? status;
  String? time;
  Data? data;

  getproduct({this.status, this.time, this.data});

  getproduct.fromJson(Map<String, dynamic> json) {
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
  String? productTitle;
  int? categoryId;
  int? subCategoryId;
  int? statusId;
  int? productStatusId;
  int? productConditionId;
  int? userId;
  String? description;
  int? price;
  int? stateId;
  String? createdOn;
  String? createdDate;
  String? phoneNumber;
  String? address;
  int? productTypeId;
  List<Images>? images;

  Data(
      {this.productTitle,
      this.categoryId,
      this.subCategoryId,
      this.statusId,
      this.productStatusId,
      this.productConditionId,
      this.userId,
      this.description,
      this.price,
      this.stateId,
      this.createdOn,
      this.createdDate,
      this.phoneNumber,
      this.address,
      this.productTypeId,
      this.images});

  Data.fromJson(Map<String, dynamic> json) {
    productTitle = json['productTitle'];
    categoryId = json['categoryId'];
    subCategoryId = json['subCategoryId'];
    statusId = json['statusId'];
    productStatusId = json['productStatusId'];
    productConditionId = json['productConditionId'];
    userId = json['userId'];
    description = json['description'];
    price = json['price'];
    stateId = json['stateId'];
    createdOn = json['createdOn'];
    createdDate = json['createdDate'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    productTypeId = json['productTypeId'];
    if (json['images'] != null) {
      images = <Images>[];
      json['images'].forEach((v) {
        images!.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productTitle'] = this.productTitle;
    data['categoryId'] = this.categoryId;
    data['subCategoryId'] = this.subCategoryId;
    data['statusId'] = this.statusId;
    data['productStatusId'] = this.productStatusId;
    data['productConditionId'] = this.productConditionId;
    data['userId'] = this.userId;
    data['description'] = this.description;
    data['price'] = this.price;
    data['stateId'] = this.stateId;
    data['createdOn'] = this.createdOn;
    data['createdDate'] = this.createdDate;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['productTypeId'] = this.productTypeId;
    if (this.images != null) {
      data['images'] = this.images!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String? imageName;
  String? normalImage;
  int? productId;
  int? statusId;
  String? createdOn;
  String? createdDate;

  Images(
      {this.imageName,
      this.normalImage,
      this.productId,
      this.statusId,
      this.createdOn,
      this.createdDate});

  Images.fromJson(Map<String, dynamic> json) {
    imageName = json['imageName'];
    normalImage = json['normalImage'];
    productId = json['productId'];
    statusId = json['statusId'];
    createdOn = json['createdOn'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['imageName'] = this.imageName;
    data['normalImage'] = this.normalImage;
    data['productId'] = this.productId;
    data['statusId'] = this.statusId;
    data['createdOn'] = this.createdOn;
    data['createdDate'] = this.createdDate;
    return data;
  }
}
