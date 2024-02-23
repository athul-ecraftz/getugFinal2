import 'package:json_annotation/json_annotation.dart';
part 'update_userprofile.g.dart';

@JsonSerializable()
class update_userprofile {
  String? status;
  String? time;
  Data? data;

  update_userprofile({this.status, this.time, this.data});

  update_userprofile.fromJson(Map<String, dynamic> json) {
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
  String? userName;
  int? mobileNumber;
  String? email;
  String? photo;
  String? firstName;
  String? lastName;
  String? description;
  int? alternateNumber;
  int? userId;
  int? registerPlatformId;

  Data(
      {this.userName,
      this.mobileNumber,
      this.email,
      this.photo,
      this.firstName,
      this.lastName,
      this.description,
      this.alternateNumber,
      this.userId,
      this.registerPlatformId});

  Data.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    mobileNumber = json['mobileNumber'];
    email = json['email'];
    photo = json['photo'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    description = json['description'];
    alternateNumber = json['alternateNumber'];
    userId = json['userId'];
    registerPlatformId = json['registerPlatformId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['mobileNumber'] = this.mobileNumber;
    data['email'] = this.email;
    data['photo'] = this.photo;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['description'] = this.description;
    data['alternateNumber'] = this.alternateNumber;
    data['userId'] = this.userId;
    data['registerPlatformId'] = this.registerPlatformId;
    return data;
  }
}
