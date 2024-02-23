import 'dart:io';

import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/components/default_button.dart';
import 'package:getug/constants.dart';
import 'package:getug/models/update_userprofile/update_userprofile.dart';
import 'package:getug/screens/profile/userprofile.dart';
import 'package:getug/size_config.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class EditProfile extends StatefulWidget {
  static String routeName = '/editprofile';
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  String email = "";
  String firstName = "";
  String lastName = "";
  String description = "";
  String mobileNumber = "";
  String alternateNumber = "";
  String UserId = "";
  String photo = "";

  final _formKey = GlobalKey<FormState>();
  final TextEditingController FirstNameController = TextEditingController();
  final TextEditingController LastNameController = TextEditingController();
  final TextEditingController DescriptionController = TextEditingController();
  final TextEditingController AlternateController = TextEditingController();
  final TextEditingController MobileNumberController = TextEditingController();

  Future<void> profiledetails() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString('email') ?? "";
      firstName = prefs.getString('firstName') ?? "";
      lastName = prefs.getString('lastName') ?? "";
      description = prefs.getString('description') ?? "";
      // mobileNumber = prefs.getString('mobileNumber') == "null" ? "" : "";
      mobileNumber = prefs.getString('mobileNumber') ?? "";
      alternateNumber = prefs.getString('alternateNumber') ?? "";
      UserId = prefs.getString('userid') ?? "";
      photo = prefs.getString('photo') ?? "";
      print(photo);
      // if (firstName != null && firstName.isNotEmpty) {
      // setState(() {
      FirstNameController.text = firstName;
      // });
      // }
      //if (lastName != null && lastName.isNotEmpty) {
      //setState(() {
      LastNameController.text = lastName;
      //});
      // }
      //if (description != null && description.isNotEmpty) {
      // setState(() {
      DescriptionController.text = description;
      //});
      //}
      //if (mobileNumber != null && mobileNumber.isNotEmpty) {
      // setState(() {
      MobileNumberController.text = mobileNumber;
      //});
      // }
      //if (alternateNumber != null && alternateNumber.isNotEmpty) {
      // setState(() {
      AlternateController.text = alternateNumber;
      //});
      // }
    });
  }

  Future<update_userprofile> userprofileupdate({
    required int? userid,
    required String? firstName,
    required String? lastName,
    required String? description,
    required int? mobileNumber,
    required int? alterNateNumber,
    required String? email,
  }) async {
    Map<String, String> data = {
      "UserId": "$userid",
      "firstName": "$firstName",
      "lastName": "$lastName",
      "description": "$description",
      "mobileNumber": "$mobileNumber",
      "alterNateNumber": "$alterNateNumber",
      "emailAddress": "$email",
    };
    update_userprofile? Submit;
    var response = await postJson("/api/updateuserprofile", data);
    if (response.statusCode == 200) {
      // print(response);
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("new=$jsonResponse");
      var itemCount = jsonResponse['data'];
      Submit = update_userprofile.fromJson(jsonResponse);
      //updatesharedpreferences();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString("firstName", itemCount['firstName']);
      //prefs.setString("lastName", itemCount['lastName']);
      //prefs.setString("mobileNumber", itemCount['mobileNumber']);
      //prefs.setString("alternateNumber", itemCount['alternateNumber']);
      prefs.setString("photo", itemCount['photo']);
      //prefs.setString("description", itemCount['description']);
      print(itemCount['photo']);

      print('Number of books about http: $jsonResponse.');
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print(jsonResponse);
      var itemCount = jsonResponse['data'];
      // jsonResponse['user'] = {};
      print(itemCount);
      Submit = update_userprofile.fromJson(jsonResponse);
      print(Submit);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return Submit!;
  }

  Future<void> updatesharedpreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("firstName", FirstNameController.text);
    prefs.setString("lastName", LastNameController.text);
    prefs.setString("mobileNumber", MobileNumberController.text);
    prefs.setString("alternateNumber", AlternateController.text);
    prefs.setString("description", DescriptionController.text);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    profiledetails();
  }

  bool isLoading = false;
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: TextStyle(fontSize: 21)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    isLoading
                        ? CircularProgressIndicator(
                            semanticsLabel: "Uploading",
                          )
                        : ClipRRect(
                            clipBehavior: Clip.antiAlias,
                            borderRadius: BorderRadius.circular(100.0),
                            child: getImageWidget(photo, i),
                          ),
                    // ClipRect(

                    //   child: getImageWidget(photo,
                    //       i),
                    // ), // Display the selected image or default image

                    Positioned(
                      height: 240,
                      width: 250,
                      child: IconButton(
                        onPressed: () async {
                          await showImageSelectionDialog(context);
                        },
                        padding: EdgeInsets.only(top: 130, left: 60),
                        icon: Icon(Icons.add_photo_alternate),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: FirstNameController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'First Name',
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
                      return 'Please enter First Name';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 15),
                TextFormField(
                  controller: LastNameController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Last Name',
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
                      return 'Please enter Last Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: DescriptionController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Description',
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
                      return 'Please enter a Description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  controller: MobileNumberController,
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
                  controller: AlternateController,
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    labelText: 'Alternate Number',
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
                      return 'Please enter a alternate number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 25),
                // DefaultButton(
                //   text: "Submit",
                //   press: () async {
                //     update_userprofile p = await userprofileupdate(
                //       description: DescriptionController.text,
                //       mobileNumber: int.parse(MobileNumberController.text),
                //       alterNateNumber: int.parse(AlternateController.text),
                //       firstName: FirstNameController.text,
                //       lastName: LastNameController.text,
                //     );
                //     print(p.data);
                //   },
                // )

                SizedBox(
                  width: 200,
                  height: 45,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: cPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15))),
                      onPressed: () async {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: FutureBuilder(
                                    future: submitData(),
                                    builder: (context, snapshot) {
                                      switch (snapshot.connectionState) {
                                        case ConnectionState.none:
                                        case ConnectionState.waiting:
                                          return const Row(
                                            children: [
                                              CircularProgressIndicator(),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              Text(
                                                "Wait for updating",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )
                                            ],
                                          );
                                        case ConnectionState.done:
                                          if (snapshot.hasError) {
                                            return Text(
                                                'Error : ${snapshot.error}');
                                          } else {
                                            return Text("Success");
                                          }

                                        default:
                                          return Text("Error");
                                      }
                                    }),
                              );
                            });
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

  Future<void> submitData() async {
    final prefs = await SharedPreferences.getInstance();
    final emailv = prefs.getString("email");
    final userids = prefs.getString("userid");

    /*  if (photo != null && photo.isNotEmpty) {
                        // Upload the selected image
                        // Assuming 'photo' contains the image path
                        await uploadImage(photo);
                      }
  */
    update_userprofile p = await userprofileupdate(
      description: DescriptionController.text,
      mobileNumber: int.parse(MobileNumberController.text),
      alterNateNumber: int.parse(AlternateController.text),
      firstName: FirstNameController.text,
      lastName: LastNameController.text,
      email: emailv!,
      userid: int.parse(userids!),
    );

    // print(AlternateController.text);
    // print(MobileNumberController.text);
    if (p != null) {
      await updatesharedpreferences();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          content: Text(
            "Profile Updated Successfully",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          )));
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => UserProfile()));
    }
  }

  Widget getImageWidget(String? photo, int? i) {
    if (photo != null && photo.isNotEmpty && i == 0) {
      return Image.network(
        photo,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    }
    if (photo != null && photo.isNotEmpty && i == 1) {
      return CircleAvatar(
        radius: 70, // Adjust the radius as needed
        backgroundColor: Colors.transparent,
        backgroundImage: FileImage(File('$photo')),
      );
    } else {
      return Image.asset(
        'assets/images/admin.jpg', // Replace 'default_image.png' with your asset image path
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      );
    }
  }

  // Widget getImageWidget(String? photo) {
  //   if (photo != null && photo.isNotEmpty) {
  //     return CircleAvatar(
  //       radius: 70, // Adjust the radius as needed
  //       backgroundColor: Colors.transparent,
  //       backgroundImage: FileImage(File(
  //           '$photo')), // Assuming 'photo' contains the path of the selected image
  //     );
  //   } else {
  //     return CircleAvatar(
  //       radius: 70, // Adjust the radius as needed
  //       backgroundColor: Colors.transparent,
  //       backgroundImage: AssetImage(
  //         'assets/images/admin.jpg', // Replace with your default image path
  //       ),
  //     );
  //   }
  // }

  final ImagePicker picker = ImagePicker();

  XFile? image;
  int? i = 0;

  Future<void> getImage(ImageSource source) async {
    XFile? pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
        photo = pickedImage.path;
        i = 1;
        // Set the selected image path to 'photo'
      });

      // Call method to upload image to API
      int? result = await uploadImage(pickedImage.path);
      print('result : $result');
      if (result == 1) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.green,
            content: Text(
              "Image successfully updated",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            )));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
            content: Text(
              "Sorry, image not uploaded",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            )));
      }
    }
  }

  // Future<void> uploadImage(String imagePath) async {
  //   // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint for image upload
  //   var request =
  //       http.MultipartRequest('POST', Uri.parse("/api/updateuserprofile"));

  //   request.files.add(await http.MultipartFile.fromPath('image', imagePath));

  //   try {
  //     var response = await request.send();

  //     if (response.statusCode == 200) {
  //       // Image successfully uploaded
  //       print('Image uploaded successfully');
  //       // You can handle the response data here
  //     } else {
  //       // Error in uploading image
  //       print('Failed to upload image');
  //     }
  //   } catch (error) {
  //     // Handle upload error
  //     print('Error: $error');
  //   }
  // }

  Future<int> uploadImage(String imagePath) async {
    setState(() {
      isLoading = true;
    });
    print(imagePath);
    int i = 0;
    final prefs = await SharedPreferences.getInstance();

    // final emailv = prefs.getString("email");
    final userids = prefs.getString("userid");
    // Replace 'YOUR_API_ENDPOINT' with your actual API endpoint for image upload
    var request = http.MultipartRequest(
        'POST', Uri.parse("https://devapi.get-ug.com/api/insertProfileImage"));

    request.files.add(await http.MultipartFile.fromPath('formFile', imagePath));
    request.fields['UserId'] = userids!;
    try {
      var response = await request.send();

      if (response.statusCode == 200) {
        i = 1;
        // Image successfully uploaded
        final resp = await response.stream.bytesToString();
        print('Image uploaded successfully $resp');
        setState(() {
          isLoading = false;
        });
        // You can handle the response data here
      } else {
        // Error in uploading image
        print('Failed to upload image');
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      // Handle upload error
      print('Error: $error');
      setState(() {
        isLoading = false;
      });
    }
    return i;
  }

  Future<void> showImageSelectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Do you want to change profile picture?',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900]),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Select Image',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    getImage(ImageSource.gallery);
                  },
                  child: ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from gallery'),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    getImage(ImageSource.camera);
                  },
                  child: ListTile(
                    leading: Icon(Icons.camera_alt),
                    title: Text('Take a photo'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
