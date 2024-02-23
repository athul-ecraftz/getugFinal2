import 'package:flutter/material.dart';
import 'package:getug/constants.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:getug/screens/products/mypost.dart';
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
  List<File> _images = [];
  final _formKey = GlobalKey<FormState>();
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _images.isNotEmpty
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Container(
                                width: 100.0,
                                height: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Color.fromARGB(255, 34, 138, 207),
                                    width: 1.0,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.file(
                                    _images[index],
                                    width: double.infinity,
                                    height: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _images.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          );
                        },
                      )
                    : Container(),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () {
                    showImageSelectionDialog(context);
                  },
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_photo_alternate,
                        size: 40.0,
                        color: Colors.blue,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        'Add images',
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Color.fromARGB(255, 94, 94, 94),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cPrimaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _isUploading ? null : () => _uploadImages(context),
                  child: _isUploading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          "Submit",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    XFile? pickedImage = await picker.pickImage(source: source);

    if (pickedImage != null) {
      setState(() {
        _images.add(File(pickedImage.path));
      });
    }
  }

  Future<void> _uploadImages(BuildContext context) async {
    setState(() {
      _isUploading = true;
    });

    try {
      for (File image in _images) {
        await _uploadImage(productid!, image.path);
      }

      // Delayed navigation to the next screen
      await Future.delayed(Duration(seconds: 2));
      Navigator.pushNamed(context, HomeScreen.routeName);
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadImage(String productid, String imagePath) async {
    final url =
        "https://devapi.get-ug.com/api/insertProductImage/$productid/upload";

    try {
      print('Image uploading started');
      print(imagePath);

      var request = http.MultipartRequest('POST', Uri.parse(url))
        ..fields['ProductId'] = productid
        ..files.add(await http.MultipartFile.fromPath(
          'files',
          imagePath,
          filename: imagePath.split('/').last,
        ));

      http.Response response =
          await http.Response.fromStream(await request.send());

      if (response.statusCode == 200) {
        final resp = response.body;
        print(resp);
        // Handle success
      } else {
        print('Failed to upload image. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle failure
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
          title: const Text('Select Image'),
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
