import 'package:json_annotation/json_annotation.dart';
part 'states.g.dart';

@JsonSerializable()
class AllStates {
  String? status;
  String? time;
  List<States>? data;

  AllStates({this.status, this.time, this.data});

  AllStates.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    time = json['time'];
    if (json['data'] != null) {
      data = <States>[];
      json['data'].forEach((v) {
        data!.add(new States.fromJson(v));
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

class States {
  String? locationName;
  int? locationId;
  String? createdOn;

  States({this.locationName, this.locationId, this.createdOn});

  States.fromJson(Map<String, dynamic> json) {
    locationName = json['locationName'];
    locationId = json['locationId'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['locationName'] = this.locationName;
    data['locationId'] = this.locationId;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
