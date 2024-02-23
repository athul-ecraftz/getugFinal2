import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/enquiry/enquiry.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class EnquiryPage extends StatefulWidget {
  static String routeName = '/enquiry';
  const EnquiryPage({super.key});

  @override
  State<EnquiryPage> createState() => _EnquiryPageState();
}

class _EnquiryPageState extends State<EnquiryPage> {
  String Name = "";
  String Email = "";
  String MobileNumber = "";
  String Message = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController NameController = TextEditingController();
  final TextEditingController EmailController = TextEditingController();
  final TextEditingController PhoneController = TextEditingController();
  final TextEditingController MessageController = TextEditingController();

  Future<void> Equirydetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      Email = prefs.getString('email') ?? "";
      Name = prefs.getString('firstName') ?? "";
      MobileNumber = prefs.getString('mobileNumber') ?? "";

      NameController.text = Name;
      EmailController.text = Email;
      PhoneController.text = MobileNumber;
    });
  }

  Future<Enquiry> enquirydetails({
    required String? Name,
    required String? Email,
    required int? mobileNumber,
    required String? Message,
  }) async {
    Map<String, String> data = {
      "Name": "$Name",
      "Email": "$Email",
      "MobileNumber": "$mobileNumber",
      "Message": "$Message",
    };
    Enquiry? Submit;
    var response = await postJson("/api/insertEnquiryDetails", data);
    if (response.statusCode == 200) {
      // print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("new=$jsonResponse");
      var itemCount = jsonResponse['data'];
      Submit = Enquiry.fromJson(jsonResponse);
      print('Number of books about http: $jsonResponse.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      var itemCount = jsonResponse['data'];
      // jsonResponse['user'] = {};
      print(itemCount);
      Submit = Enquiry.fromJson(jsonResponse);
      print(Submit);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return Submit!;
  }

  @override
  void initState() {
    super.initState();
    Equirydetails();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enquiry", style: TextStyle(fontSize: 21)),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 15),
                TextFormField(
                  controller: NameController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: EmailController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter Email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: PhoneController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Mobile Number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: MessageController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Message',
                    labelStyle:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black, width: 1.0),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a Message';
                    }
                    return null;
                  },
                  maxLines: 4,
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () async {
                        Enquiry s = await enquirydetails(
                          Name: NameController.text,
                          Email: EmailController.text,
                          mobileNumber: int.parse(PhoneController.text),
                          Message: MessageController.text,
                        );
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
