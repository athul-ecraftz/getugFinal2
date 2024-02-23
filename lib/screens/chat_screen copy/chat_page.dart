import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/chat/getChatHeader.dart';
import 'package:getug/screens/chat_screen/chatsample.dart';
import 'dart:convert' as convert;

class ChatPage extends StatefulWidget {
  static String routeName = '/chatpage';
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPage();
}

class _ChatPage extends State<ChatPage> {
  late List<Data> chatDataHeader = [];
  bool isLoading = true;
  String errorMessage = '';
  late Map<String, dynamic> args;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // print(args['userId']);
      final getchatHeader = await getChat(
          args['userId'].toString(), args['productId'].toString());
      setState(() {
        chatDataHeader = getchatHeader?.data ?? [];
        isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data. Please try again.';
      });
    }
  }

  Future<ChatHeader?> getChat(String userId, String productId) async {
    var response =
        await getJson("/api/getChatHeader?UserId=$userId&ProductId=$productId");
    ChatHeader? getchatHeader;
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getchatHeader = ChatHeader.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getchatHeader = ChatHeader.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return getchatHeader;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(55),
                  // child: Image.asset(
                  //   'assets/images/profile.png',
                  //   height: 70,
                  //   width: 70,
                  // ),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.grey,
                    child: Image.network(
                      chatDataHeader.isNotEmpty
                          ? chatDataHeader[0].img.toString()
                          : "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Row(
                  children: [
                    CustomAppBarContent(
                      name: chatDataHeader.isNotEmpty
                          ? chatDataHeader[0].name.toString()
                          : '',
                      prodName: chatDataHeader.isNotEmpty
                          ? chatDataHeader[0].prodname.toString()
                          : '',
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 7, left: 10), // Adjust left padding
                      child: Icon(
                        Icons.more_vert,
                        size: 25,
                      ),
                    ),
                  ],
                ),
                // const Padding(
                //   padding:
                //       EdgeInsets.only(top: 7, left: 10), // Adjust left padding
                //   child: Icon(
                //     Icons.more_vert,
                //     size: 25,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ChatSample(
              productId: args['productId'].toString(),
              senderId: args['userId'].toString(),
            ),
    );
  }
}

class CustomAppBarContent extends StatelessWidget {
  final String name;
  final String prodName;

  const CustomAppBarContent({
    required this.name,
    required this.prodName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name.isNotEmpty ? name : '......',
          style: const TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 5),
        Text(
          prodName.isNotEmpty ? prodName : '.....',
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
