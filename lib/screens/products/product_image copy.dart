import 'package:flutter/material.dart';
import 'package:getug/constants.dart';
import 'package:getug/screens/products/post_products.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

String? productid;
late Map<String, dynamic> args;

class productImage extends StatefulWidget {
  static String routeName = '/productImage';

  const productImage({Key? key}) : super(key: key);

  @override
  State<productImage> createState() => _ProductImageState();
}

class _ProductImageState extends State<productImage> {
  final ImagePicker picker = ImagePicker();
  XFile? image;
  final _formKey = GlobalKey<FormState>();
  File? _image;
  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    print(args);
    productid = args['productid']!;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pushNamed(context, ProductPost.routeName);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: const Row(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text('Post Your Add'),
            ),
            Spacer(),
          ],
        ),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300.0,
                height: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Color.fromARGB(255, 34, 138, 207),
                    width: 1.0,
                  ),
                ),
                child: GestureDetector(
                  onTap: () async {
                    await showImageSelectionDialog(context);
                  },
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.file(
                            _image!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_photo_alternate,
                                size: 40.0,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 8.0),
                              Text(
                                'Choose your image',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (_image != null) {
                      _uploadImage(productid!);
                    }
                    // if (image != null) {

                    //   uploadImage(image! as File, productid!);
                    // }
                    else {
                      print('No image selected');
                    }
                  }
                },
                child: const Text(
                  "Submit",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16),
                ),
              )
              // ElevatedButton(
              //   onPressed: () {
              //     if (_formKey.currentState!.validate()) {
              //       if (_image != null) {
              //         _uploadImage(productid!).then((_) {
              //           print('Image upload completed!');
              //           Navigator.pushNamed(context, ProductPost.routeName);
              //         }).catchError((error) {
              //           print('Error during image upload: $error');
              //         });
              //       } else {
              //         print('No image selected');
              //       }
              //     }
              //   },
              //   child: Text("Submit"),
              // )
            ],
          ),
        ),
      ),
    );
  }

  // void uploadImageAndShowResult(String productid) async {
  //   XFile? image = await pickImage();

  //   if (image != null) {
  //     File imageFile = File(image.path);
  //     await uploadImage(imageFile, productid);
  //   }
  // }

  Future<void> getImage(ImageSource source) async {
    XFile? pickedImage = await picker.pickImage(source: source);
    print('--------------------------');
    print('Image location: ${pickedImage!.path}');
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage = await ImagePicker().pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  Future<void> _uploadImage(String productid) async {
    if (_image == null) {
      print("Please select an image first.");
      return;
    }

    try {
      String apiUrl =
          "https://devapi.get-ug.com/api/insertProductImage/$productid/upload";

      Dio dio = Dio();
      String fileName = _image!.path.split('/').last;
      print(fileName);
      FormData formData = FormData.fromMap({
        "files": await MultipartFile.fromFile(_image!.path, filename: fileName),
        "ProductId": productid,
        // Add additional parameters if required
      });

      Response response = await dio.post(apiUrl, data: formData);

      // Handle the response as needed
      print(response);
    } catch (e) {
      print("Error uploading image: $e");
    }
  }

  Future<void> uploadImages(String imagePath, String productid) async {
    final url =
        "https://devapi.get-ug.com/api/insertProductImage/$productid/upload";

    try {
      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['ProductId'] = productid
        ..files.add(
          await http.MultipartFile.fromPath('formFile', imagePath),
        );

      var response = await request.send();

      if (response.statusCode == 200) {
        final resp = await response.stream.bytesToString();
        print(resp);
        Navigator.pushNamed(context, ProductPost.routeName);
      } else {
        print('Failed to upload image');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> showImageSelectionDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                  child: const ListTile(
                    leading: Icon(Icons.photo_library),
                    title: Text('Choose from gallery'),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                  child: const ListTile(
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
