import 'package:json_annotation/json_annotation.dart';
part 'getAllChat.g.dart';

@JsonSerializable()
class AllChats {
  String? status;
  String? time;
  List<Data>? data;

  AllChats({this.status, this.time, this.data});

  AllChats.fromJson(Map<String, dynamic> json) {
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
  String? prodName;
  String? img;
  int? userId;
  String? name;
  String? msg;
  String? time;
  int? unread;

  Data(
      {this.id,
      this.prodName,
      this.img,
      this.userId,
      this.name,
      this.msg,
      this.time,
      this.unread});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodName = json['prodName'];
    img = json['img'];
    userId = json['userId'];
    name = json['name'];
    msg = json['msg'];
    time = json['time'];
    unread = json['unread'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prodName'] = this.prodName;
    data['img'] = this.img;
    data['userId'] = this.userId;
    data['name'] = this.name;
    data['msg'] = this.msg;
    data['time'] = this.time;
    data['unread'] = this.unread;
    return data;
  }
}
