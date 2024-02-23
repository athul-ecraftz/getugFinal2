import 'dart:async';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/chat/getChatHistory.dart';
import 'package:getug/signalR.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:record/record.dart';

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
  late ScrollController _scrollController;
  late List<Data> chatDataHistory = [];
  var _messageController = TextEditingController();
  int counter = 1;
  Map<int, AudioPlayer> audioPlayers = {}; // Map to store AudioPlayers
  bool isRecording = false;
  bool isTyping = false;
  String? recordedFilePath;
  final record = AudioRecorder();

  void _startPolling() {
    _loadData();
  }

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startPolling();

    // Only one call is necessary
    WidgetsFlutterBinding.ensureInitialized();
  }

  Future<void> _startRecording() async {
    try {
      if (await record.hasPermission()) {
        final stream = await record.startStream(const RecordConfig());
        // await record.start(const RecordConfig(), path: 'aFullPath/myFile.m4a');
      } else {
        // Handle the case where the app doesn't have recording permissions
      }
      setState(() {
        isRecording = true;
      });
      print('Recording started');
    } catch (e) {
      print('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      // await _audioPlayer.stop();
      final path = await record.stop();
      print('Recording Path: $path');
      setState(() {
        isRecording = false;
        recordedFilePath = path; // Store the path in a variable
      });
      print('Recording stopped');
      // Access the recorded audio sources in _recordingSource.children
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  void _setupAudioplayer(int messageIndex, String audioFileUrl) {
    if (!audioPlayers.containsKey(messageIndex)) {
      audioPlayers[messageIndex] = AudioPlayer(); // Create a new AudioPlayer
      audioPlayers[messageIndex]!.playbackEventStream.listen((event) {},
          onError: (Object e, StackTrace stacktrace) {
        print("A stream error occurred: $e");
      });
    }

    try {
      audioPlayers[messageIndex]!
          .setAudioSource(AudioSource.uri(Uri.parse(audioFileUrl)));
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  Widget _playbackControlButton(int messageIndex) {
    return StreamBuilder(
      stream: audioPlayers[messageIndex]?.playerStateStream,
      builder: (context, snapshot) {
        final processingState = snapshot.data?.processingState;
        final playing = snapshot.data?.playing;

        if (processingState == ProcessingState.loading ||
            processingState == ProcessingState.buffering) {
          return Container(
            margin: const EdgeInsets.all(1.0),
            width: 64,
            height: 64,
            child: const CircularProgressIndicator(),
          );
        } else if (playing != true) {
          return IconButton(
            onPressed: () {
              _setupAudioplayer(
                  messageIndex, chatDataHistory[messageIndex].file ?? "");
              audioPlayers[messageIndex]!.play();
            },
            iconSize: 32,
            icon: const Icon(Icons.play_arrow),
          );
        } else if (processingState != ProcessingState.completed) {
          return IconButton(
            onPressed: audioPlayers[messageIndex]!.pause,
            icon: const Icon(Icons.pause),
          );
        } else {
          return IconButton(
            onPressed: () => audioPlayers[messageIndex]!.seek(Duration.zero),
            icon: const Icon(Icons.replay),
          );
        }
      },
    );
  }

  Widget _progressBar(int messageIndex) {
    return StreamBuilder<Duration?>(
      stream: audioPlayers[messageIndex]?.positionStream,
      builder: (context, snapshot) {
        return Container(
          width: 200,
          child: ProgressBar(
            progress: snapshot.data ?? Duration.zero,
            buffered:
                audioPlayers[messageIndex]?.bufferedPosition ?? Duration.zero,
            total: audioPlayers[messageIndex]?.duration ?? Duration.zero,
            onSeek: (duration) {
              audioPlayers[messageIndex]?.seek(duration);
            },
          ),
        );
      },
    );
  }

  void handleReceivedMessage() async {
    print('Messages updated');
    _loadData();
  }

  @override
  void dispose() {
    _messageController.dispose();

    super.dispose();
  }

  Future<void> _loadData() async {
    try {
      print("Sender Id: ${widget.senderId}");
      final prefs = await SharedPreferences.getInstance();
      String userid = prefs.getString('userid').toString();

      // Fetch data using the SignalRProvider
      final signalRProvider =
          Provider.of<SignalRProvider>(context, listen: false);
      SignalRProvider(
        onMessageReceived: handleReceivedMessage,
      );
      await signalRProvider.initialiseChat();

      final getchathistory = await getChat(
          userid, widget.productId.toString(), widget.senderId.toString());
      print('Setting state for fetchChat History data...');

      setState(() {
        chatDataHistory = getchathistory?.data ?? [];
      });

      // Inside the loop where you fetch messages
      for (int index = 0; index < chatDataHistory.length; index++) {
        var message = chatDataHistory[index];
        if (message.subtype == "audio" && message.file != null) {
          _setupAudioplayer(index, message.file!);
        }
      }

      // Scroll to the end of the ListView
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 0),
        curve: Curves.easeOut,
      );

      // Scroll to the end of the ListView
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });

      print('API data fetched successfully.');
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

  void _submitMessage() async {
    final enteredMessage = _messageController.text;
    if (enteredMessage.trim().isEmpty) {
      return;
    }
    print(enteredMessage);

    final signalRProvider =
        Provider.of<SignalRProvider>(context, listen: false);
    final prefs = await SharedPreferences.getInstance();
    String userid = prefs.getString('userid').toString();
    signalRProvider.sendMessage(
      senderId: widget.senderId!,
      recipientId: userid,
      productId: widget.productId!,
      message: enteredMessage,
      msgType: 'msg',
      file: null,
      subtype: 'msgSubType',
      fileName: "",
    );
    _loadData();
    _messageController.clear();
    isRecording = false;
    isTyping = false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            reverse: false,
            padding: const EdgeInsets.only(bottom: 45),
            itemCount: chatDataHistory.length,
            itemBuilder: (BuildContext context, int index) {
              var message = chatDataHistory[index];

              // Check if the message subtype is "audio"
              if (message.subtype == "audio") {
                // Display audio player UI for audio messages
                return Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                  child: ClipPath(
                    clipper: UpperNipMessageClipperTwo(
                      message.outgoing ?? true
                          ? MessageType.send
                          : MessageType.receive,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 25,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: message.outgoing ?? true
                            ? Color.fromARGB(255, 228, 236, 243)
                            : Color.fromARGB(255, 243, 228, 237),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _playbackControlButton(index),
                              _progressBar(index),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            message.sentTime.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                // Display regular text message UI for non-audio messages
                return Padding(
                  padding: const EdgeInsets.only(right: 15, left: 15, top: 10),
                  child: ClipPath(
                    clipper: UpperNipMessageClipperTwo(
                      message.outgoing ?? true
                          ? MessageType.receive
                          : MessageType.send,
                    ),
                    child: Container(
                      padding: const EdgeInsets.only(
                        top: 30,
                        left: 25,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                        color: message.outgoing ?? true
                            ? Color.fromARGB(255, 228, 236, 243)
                            : Color.fromARGB(255, 243, 228, 237),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 1),
                            child: Text(
                              message.message ?? '',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            message.sentTime.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(top: 10),
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
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: isRecording
                        ? Text(
                            'Recording...',
                            style: TextStyle(color: Colors.blue),
                          )
                        : TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Type your message here...",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            onChanged: (text) {
                              setState(() {
                                // Toggle between mic and send icon based on whether there is text in the TextField
                                isTyping = text.isNotEmpty;
                                isRecording = false;
                              });
                            },
                          ),
                  ),
                  SizedBox(width: 10),
                  if (isTyping)
                    IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: _submitMessage),
                  if (!isTyping)
                    IconButton(
                      icon: Icon(Icons.mic, color: Colors.blue),
                      onPressed: isRecording ? _stopRecording : _startRecording,
                    ),
                  if (isRecording)
                    IconButton(
                      icon: Icon(Icons.stop, color: Colors.red),
                      onPressed: _stopRecording,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
