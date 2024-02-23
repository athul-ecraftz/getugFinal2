import 'package:json_annotation/json_annotation.dart';
part 'getChatHeader.g.dart';

@JsonSerializable()
class ChatHeader {
  String? status;
  String? time;
  List<Data>? data;

  ChatHeader({this.status, this.time, this.data});

  ChatHeader.fromJson(Map<String, dynamic> json) {
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
  String? prodname;
  String? img;
  String? name;
  bool? status;

  Data({this.id, this.prodname, this.img, this.name, this.status});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    prodname = json['prodname'];
    img = json['img'];
    name = json['name'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['prodname'] = this.prodname;
    data['img'] = this.img;
    data['name'] = this.name;
    data['status'] = this.status;
    return data;
  }
}
