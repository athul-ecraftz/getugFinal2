import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/chat/getAllChat.dart';
import 'package:getug/screens/chat_screen/chat_page.dart';
import 'package:getug/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:signalr_netcore/signalr_client.dart';
import 'package:logging/logging.dart';
import 'package:getug/signalR.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Data> chatData = [];
  bool trigger = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void handleReceivedMessage() async {
    print('Chat screen updated');
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      // Fetch data using the SignalRProvider
      final signalRProvider =
          Provider.of<SignalRProvider>(context, listen: false);
      SignalRProvider(
        onMessageReceived: handleReceivedMessage,
      );
      await signalRProvider.initialiseChat();

      final getchat = await getChat();
      print('Setting state for fetchChat data...');
      setState(() {
        chatData = getchat?.data ?? [];
      });
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<AllChats?> getChat() async {
    print('Fetching mypost data...');
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();
    var response = await getJson("/api/getAllChats?UserId=$userid");
    AllChats? getchat;
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getchat = AllChats.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getchat = AllChats.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return getchat;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: chatData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: chatData.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    tabChat(
                      name: chatData[index].name,
                      product: chatData[index].prodName,
                      msg: chatData[index].msg,
                      img: chatData[index].img,
                      time: chatData[index].time,
                      id: chatData[index].id,
                      userId: chatData[index].userId,
                      messageCount: chatData[index].unread.toString(),
                    ),
                    const Divider(
                      height: 1,
                      color: Color.fromARGB(255, 236, 236, 236),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget tabChat({
    String? name,
    String? product,
    String? msg,
    String? img,
    String? time,
    String? messageCount,
    int? id,
    int? userId,
  }) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          ChatPage.routeName,
          arguments: {'productId': id ?? '', 'userId': userId ?? ''},
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey,
                  child: Image.network(
                    img ??
                        "https://upload.wikimedia.org/wikipedia/commons/d/d1/Image_not_available.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name ?? "",
                    style: const TextStyle(
                      fontFamily: 'Arial',
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  Text(
                    product ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                      color: Color.fromARGB(134, 0, 0, 0),
                    ),
                  ),
                  Text(
                    msg ?? "",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Column(
              children: [
                Text(
                  formatTimestamp(time ?? ""),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (messageCount != null &&
                    messageCount.isNotEmpty &&
                    int.parse(messageCount) > 0)
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        messageCount!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 6),
            PopupMenuButton(
              padding: const EdgeInsets.symmetric(vertical: 10),
              iconSize: 28,
              itemBuilder: (context) => [],
            )
          ],
        ),
      ),
    );
  }

  PreferredSize appBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: AppBar(
        elevation: 0,
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Messages",
            style: TextStyle(fontSize: 21),
          ),
        ),
      ),
    );
  }

  String formatTimestamp(String timestamp) {
    DateTime now = DateTime.now();
    DateTime dateTime = DateTime.parse(timestamp);
    Duration difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Today: show the time with AM/PM
      return DateFormat('h:mm a').format(dateTime);
    } else if (difference.inDays == 1) {
      // Yesterday: show yesterday only
      return "Yesterday";
    } else if (difference.inDays <= 6) {
      // Within one week: show the day of the week only
      return DateFormat('EEEE').format(dateTime);
    } else {
      // More than one week: show the date
      return DateFormat('yyyy-MM-dd').format(dateTime);
    }
  }
}
