import 'dart:async';

import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/chat/getChatHistory.dart';
import 'dart:convert' as convert;

import 'package:shared_preferences/shared_preferences.dart';

class ChatSample extends StatefulWidget {
  final String? productId;
  final String? senderId;

  const ChatSample({
    Key? key,
    required this.productId,
    required this.senderId,
  }) : super(key: key);

  @override
  State<ChatSample> createState() => _ChatSampleState();
}

class _ChatSampleState extends State<ChatSample> {
  late Timer _pollingTimer = Timer(Duration.zero, () {});
  late List<Data> chatDataHistory = [];
  late DateTime _lastUpdateTime = DateTime.now();
  var _messageController = TextEditingController();
  void _startPolling() {
    print('Starting polling timer...');
    _pollingTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      print('Polling timer ticked...');
      // Debounce: Only fetch data if more than 2 seconds have passed since the last update
      if (DateTime.now().difference(_lastUpdateTime).inSeconds >= 30) {
        _loadData();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _startPolling();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _pollingTimer.cancel();
    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      print("Sender Id: ${widget.senderId}");
      final prefs = await SharedPreferences.getInstance();
      String userid = prefs.getString('userid').toString();
      final getchathistory = await getChat(
          userid, widget.productId.toString(), widget.senderId.toString());
      print('Setting state for fetchChat History data...');

      setState(() {
        chatDataHistory = getchathistory?.data ?? [];
      });

      print('API data fetched successfully.'); // Add this line

      _lastUpdateTime = DateTime.now();
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  Future<ChatHistory?> getChat(
      String userId, String productId, String senderId) async {
    print('Fetching chatHistory data...');
    var response = await getJson(
        "/api/getChatHistory?ProductId=$productId&SenderId=$senderId&ReceiverId=$userId");
    ChatHistory? getchathistory;
    print(getchathistory);
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getchathistory = ChatHistory.fromJson(jsonResponse);
    } else if (response.statusCode == 400) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      getchathistory = ChatHistory.fromJson(jsonResponse);
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
    return getchathistory;
  }

  void _submitMessage() {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 170),
          child: ClipPath(
            clipper: UpperNipMessageClipperTwo(MessageType.send),
            child: Container(
              padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 228, 236, 243),
              ),
              child: const Text(
                "Hi, I'm interested to buy",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 20),
          child: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: ClipPath(
              clipper: UpperNipMessageClipperTwo(MessageType.receive),
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 25, right: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 228, 237),
                ),
                child: const Text(
                  "Hi, please call @923***79",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 20),
          child: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: ClipPath(
              clipper: UpperNipMessageClipperTwo(MessageType.receive),
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 25, right: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 228, 237),
                ),
                child: const Text(
                  "Hi, please call @923***79",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          margin: const EdgeInsets.only(top: 20),
          child: Padding(
            padding: const EdgeInsets.only(right: 80),
            child: ClipPath(
              clipper: UpperNipMessageClipperTwo(MessageType.receive),
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 25, right: 10),
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 243, 228, 237),
                ),
                child: const Text(
                  "Hi, please call @923***79",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 4,
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Type your message here...",
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.send,
                    color: Colors.blue,
                  ),
                  onPressed: _submitMessage,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(
                    10.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
