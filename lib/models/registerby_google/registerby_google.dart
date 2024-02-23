import 'package:json_annotation/json_annotation.dart';
part 'registerby_google.g.dart';

@JsonSerializable()
class registerby_google {
  String? status;
  String? time;
  User? user;

  registerby_google({this.status, this.time, this.user});

  registerby_google.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['time'] = this.time;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class User {
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

  User(
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

  User.fromJson(Map<String, dynamic> json) {
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
