import 'dart:async';
import 'dart:convert';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:custom_clippers/custom_clippers.dart';
import 'package:flutter/material.dart';
import 'package:getug/common/apiconnect.dart';
import 'package:getug/models/chat/getChatHistory.dart';
import 'package:getug/models/chat/saveChatFile.dart';
import 'package:getug/signalR.dart';
import 'package:provider/provider.dart';
import 'dart:convert' as convert;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:getug/models/chat/sendAudioChat.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:open_file/open_file.dart';

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
  String photo = "";
  final record = AudioRecorder();
  bool isLoading = false;
  bool isUploading = false;
  Set<String> downloadedFiles = Set();

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
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '${appDocDir.path}/myFile.m4a';
        await record.start(const RecordConfig(), path: filePath);
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

  void _viewFileLocally(String fileUrl) {
    // Implement file viewing logic
    // ...
  }

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
      SaveChatFile? result = await uploadImage(pickedImage.path);
      print('result :----- camera');
      print(result.data);

      if (result.status == 'Success') {
        String? fileUrl = result.data;
        String imageName = pickedImage.name ?? 'Unknown';
        if (fileUrl != null) {
          print('--------------------------------------');
          print(fileUrl);
          print(imageName);
          print('--------------------------------------');
          // Send the recorded audio message through SignalR
          final signalRProvider =
              Provider.of<SignalRProvider>(context, listen: false);
          final prefs = await SharedPreferences.getInstance();
          String userid = prefs.getString('userid').toString();

          signalRProvider.sendAudioMessage(
            senderId: widget.senderId!,
            recipientId: userid,
            productId: widget.productId!,
            message: "",
            msgType: 'msg',
            file: fileUrl ?? '', // Use the file URL obtained from the server
            subtype: 'doc',
            fileName: imageName,
          );
          _loadData();
        }
      }
    }
  }

  Future<void> _downloadFile(String fileUrl) async {
    try {
      // Get the documents directory using path_provider
      final directory = await getApplicationDocumentsDirectory();

      // Specify the file name based on your server response
      // For simplicity, assume a generic file name for now
      final fileName = 'downloaded_file';

      // Specify the file path using the documents directory
      final filePath = '${directory.path}/$fileName';

      final response = await http.get(Uri.parse(fileUrl));

      if (response.statusCode == 200) {
        setState(() {
          downloadedFiles.add(fileUrl);
        });
        // Save the file locally
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Open the file using the default viewer for its type
        await OpenFile.open(filePath);
      } else {
        print('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      print('Error downloading file: $e');
    }
  }

  Future<SaveChatFile> uploadImage(String imagePath) async {
    setState(() {
      isLoading = true;
    });
    print(imagePath);
    try {
      if (imagePath.isEmpty) {
        throw Exception('No audioBytes found');
      }

      FormData formData = FormData.fromMap({
        'FormFile': await MultipartFile.fromFile(imagePath),
      });

      // Send POST request using Dio
      final response = await Dio().post(
        'https://devapi.get-ug.com/api/saveChatFile', // Replace with your server endpoint
        data: formData,
        options: Options(headers: {
          // Add any headers if needed
        }),
      );

      // Handle success
      if (response.statusCode == 200) {
        // Parse the response data as needed
        var jsonResponse = response.data as Map<String, dynamic>;
        return SaveChatFile.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to upload photo: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading image: $error');
      rethrow; // Rethrow the error for further handling
    }
  }

  Future<sendAudioChat> uploadToServer(
      Uint8List audioBytes, String fileName) async {
    try {
      if (audioBytes.isEmpty) {
        throw Exception('No audioBytes found');
      }

      // Create FormData
      FormData formData = FormData.fromMap({
        'FormFile': MultipartFile.fromBytes(audioBytes, filename: fileName),
      });

      // Send POST request using Dio
      final response = await Dio().post(
        'https://devapi.get-ug.com/api/saveAudioChatFile', // Replace with your server endpoint
        data: formData,
        options: Options(headers: {
          // Add any headers if needed
        }),
      );

      // Handle success
      if (response.statusCode == 200) {
        // Parse the response data as needed
        var jsonResponse = response.data as Map<String, dynamic>;
        return sendAudioChat.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to upload audio: ${response.statusCode}');
      }
    } catch (error) {
      print('Error uploading audio: $error');
      rethrow; // Rethrow the error for further handling
    }
  }

  Future<void> _stopRecording() async {
    try {
      // Stop recording
      final path = await record.stop();
      print('Recording Path: $path');
      setState(() {
        isRecording = false;
        recordedFilePath = path; // Store the path in a variable
      });
      print('Recording stopped');

      // Check if the recordedFilePath is not null
      if (recordedFilePath != null) {
        // Read the audio file data
        final file = File(recordedFilePath!);

        if (!await file.exists()) {
          print("File not found: $recordedFilePath");
          return;
        }

        // Read the audio file as bytes
        final bytes = await file.readAsBytes();

        // Upload audio file to server
        try {
          String fileName =
              'audio-${DateTime.now().millisecondsSinceEpoch}.mp3';

          // Change the dynamic to sendAudioChat
          sendAudioChat response = await uploadToServer(bytes, fileName);

          print(response);

          // Check the status directly on the response
          if (response.status == 'Success') {
            String? fileUrl = response.data;
            if (fileUrl != null) {
              print('--------------------------------------');
              print(fileUrl);
              print(fileName);
              print('--------------------------------------');
              // Send the recorded audio message through SignalR
              final signalRProvider =
                  Provider.of<SignalRProvider>(context, listen: false);
              final prefs = await SharedPreferences.getInstance();
              String userid = prefs.getString('userid').toString();

              signalRProvider.sendAudioMessage(
                senderId: widget.senderId!,
                recipientId: userid,
                productId: widget.productId!,
                message: "",
                msgType: 'msg',
                file:
                    fileUrl ?? '', // Use the file URL obtained from the server
                subtype: 'audio',
                fileName: fileName,
              );
            }
          }

          // Reload chat data
          _loadData();
        } catch (e) {
          print('Error uploading audio: $e');
          // Handle the error (e.g., show an error message)
        }
      }
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

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // Handle the picked file, e.g., upload to the server
      setState(() {
        isUploading = true; // Show progress indicator
      });
      String filePath = result.files.single.path!;
      String fileName = result.files.single.name!;
      print('Selected file: $filePath');

      SaveChatFile? result1 = await uploadImage(filePath);
      print('result :----- camera');
      print(result1.data);

      if (result1.status == 'Success') {
        String? fileUrl = result1.data;
        String imageName = fileName ?? 'Unknown';
        if (fileUrl != null) {
          print('--------------------------------------');
          print(fileUrl);
          print(imageName);
          print('--------------------------------------');
          // Send the recorded audio message through SignalR
          final signalRProvider =
              Provider.of<SignalRProvider>(context, listen: false);
          final prefs = await SharedPreferences.getInstance();
          String userid = prefs.getString('userid').toString();

          signalRProvider.sendAudioMessage(
            senderId: widget.senderId!,
            recipientId: userid,
            productId: widget.productId!,
            message: "",
            msgType: 'msg',
            file: fileUrl ?? '', // Use the file URL obtained from the server
            subtype: 'doc',
            fileName: imageName,
          );
          _loadData();
        }
      }
    }
  }

  Future<void> chooseFile() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select File'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from files'),
                onTap: () async {
                  Navigator.pop(context);
                  await pickFile();
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a photo'),
                onTap: () async {
                  Navigator.pop(context);
                  await getImage(ImageSource.camera);
                },
              ),
              // Add more options for different file types (e.g., audio)
            ],
          ),
        );
      },
    );
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _playbackControlButton(index),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: _progressBar(index),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Text(
                            message.sentTime.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (message.subtype == "doc") {
                // Display UI for document (image or other file) messages
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
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (message.file != null &&
                              (message.file!.toLowerCase().endsWith('.jpg') ||
                                  message.file!
                                      .toLowerCase()
                                      .endsWith('.jpeg') ||
                                  message.file!.toLowerCase().endsWith('.png')))
                            // Use PhotoView for images
                            GestureDetector(
                              onTap: () {
                                // Open the image viewer
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => PhotoViewGallery(
                                    pageController: PageController(),
                                    pageOptions: [
                                      PhotoViewGalleryPageOptions(
                                        imageProvider: NetworkImage(message
                                            .file!), // Use the file URL obtained from the server
                                        heroAttributes: PhotoViewHeroAttributes(
                                            tag: message.file!),
                                      ),
                                    ],
                                    backgroundDecoration: const BoxDecoration(
                                      color: Colors.black,
                                    ),
                                  ),
                                ));
                              },
                              child: Image.network(
                                message
                                    .file!, // Use the file URL obtained from the server
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            )
                          else
                            GestureDetector(
                              onTap: () {
                                if (downloadedFiles.contains(message.file!)) {
                                  _viewFileLocally(message.file!);
                                } else {
                                  _downloadFile(message.file!);
                                }
                              },
                              child: Row(
                                children: [
                                  // Display a generic file icon for other document types
                                  const Icon(Icons.insert_drive_file,
                                      size: 50, color: Colors.blue),
                                  Text(message.fileName.toString()),
                                  const Spacer(),
                                  const Padding(
                                    padding: EdgeInsets.only(right: 20),
                                    child: Icon(Icons.download_for_offline,
                                        size: 40, color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          Text(
                            message.sentTime.toString(),
                            style: const TextStyle(
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
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            message.sentTime.toString(),
                            style: const TextStyle(
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
            margin: const EdgeInsets.only(top: 10),
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
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file, color: Colors.blue),
                    onPressed: () async {
                      await chooseFile();
                    },
                  ),
                  Expanded(
                    child: isRecording
                        ? const Text(
                            'Recording...',
                            style: TextStyle(color: Colors.blue),
                          )
                        : TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: "Type your message here...",
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.blue),
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
                  const SizedBox(width: 10),
                  if (isTyping)
                    IconButton(
                        icon: const Icon(Icons.send, color: Colors.blue),
                        onPressed: _submitMessage),
                  if (!isTyping)
                    IconButton(
                      icon: const Icon(Icons.mic, color: Colors.blue),
                      onPressed: isRecording ? _stopRecording : _startRecording,
                    ),
                  if (isRecording)
                    IconButton(
                      icon: const Icon(Icons.stop, color: Colors.red),
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
