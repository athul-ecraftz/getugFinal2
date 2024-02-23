import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/my_post/deleteProduct.dart';
import 'dart:convert' as convert;

Future<DeleteProduct> deleteProduct(String pId) async {
  try {
    var response = await getJson("/api/deleteproduct?productId=$pId");

    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      return DeleteProduct.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      print('Failed to delete product. Error: ${jsonResponse['error']}');
      return DeleteProduct.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
      throw Exception('Failed to delete product');
    }
  } catch (error) {
    print('Error deleting product: $error');
    throw Exception('Failed to delete product');
  }
}
