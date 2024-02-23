import 'package:json_annotation/json_annotation.dart';
part 'post_page.g.dart';

@JsonSerializable()
class Mypost {
  String? status;
  String? time;
  List<Data>? data;

  Mypost({this.status, this.time, this.data});

  Mypost.fromJson(Map<String, dynamic> json) {
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
  String? cover;
  String? wishlist;
  String? approvalStatus;
  PromotionDetails? promotionDetails;

  Data(
      {this.id,
      this.name,
      this.price,
      this.conditionName,
      this.cover,
      this.wishlist,
      this.approvalStatus,
      this.promotionDetails});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    conditionName = json['conditionName'];
    cover = json['cover'];
    wishlist = json['wishlist'];
    approvalStatus = json['approvalStatus'];
    promotionDetails = json['promotionDetails'] != null
        ? new PromotionDetails.fromJson(json['promotionDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['conditionName'] = this.conditionName;
    data['cover'] = this.cover;
    data['wishlist'] = this.wishlist;
    data['approvalStatus'] = this.approvalStatus;
    if (this.promotionDetails != null) {
      data['promotionDetails'] = this.promotionDetails!.toJson();
    }
    return data;
  }
}

class PromotionDetails {
  int? promotionId;
  int? promotionTypeId;
  int? productId;
  String? createdDate;
  String? endDate;
  String? uploadImage;
  int? isAproved;
  String? message;
  Null? rejectMessage;
  Null? isAprovedNavigation;
  Null? product;
  Null? promotionType;

  PromotionDetails(
      {this.promotionId,
      this.promotionTypeId,
      this.productId,
      this.createdDate,
      this.endDate,
      this.uploadImage,
      this.isAproved,
      this.message,
      this.rejectMessage,
      this.isAprovedNavigation,
      this.product,
      this.promotionType});

  PromotionDetails.fromJson(Map<String, dynamic> json) {
    promotionId = json['promotionId'];
    promotionTypeId = json['promotionTypeId'];
    productId = json['productId'];
    createdDate = json['createdDate'];
    endDate = json['endDate'];
    uploadImage = json['uploadImage'];
    isAproved = json['isAproved'];
    message = json['message'];
    rejectMessage = json['rejectMessage'];
    isAprovedNavigation = json['isAprovedNavigation'];
    product = json['product'];
    promotionType = json['promotionType'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['promotionId'] = this.promotionId;
    data['promotionTypeId'] = this.promotionTypeId;
    data['productId'] = this.productId;
    data['createdDate'] = this.createdDate;
    data['endDate'] = this.endDate;
    data['uploadImage'] = this.uploadImage;
    data['isAproved'] = this.isAproved;
    data['message'] = this.message;
    data['rejectMessage'] = this.rejectMessage;
    data['isAprovedNavigation'] = this.isAprovedNavigation;
    data['product'] = this.product;
    data['promotionType'] = this.promotionType;
    return data;
  }
}
