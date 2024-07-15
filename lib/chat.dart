import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:sat_project/teacher.dart';
import 'dart:convert';
import 'dart:convert' show utf8;

import 'package:sat_project/three_dots.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:sat_project/voice_recorder_button.dart';
import 'faq_component.dart';

// void main() {
//   runApp(ChatApp());
// }

class ChatApp extends StatefulWidget {
  final String username; // Add the username parameter

  ChatApp({required this.username}); // Constructor with the username parameter

  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  List<Map<String, String>> chat = [];
  String end = '';
  List<String> buttons = [];
  List<Map<String, dynamic>> protocol = [];
  String title = '';
  TextEditingController messageController = TextEditingController();
  List<bool> isWaiting = [];

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }
  // bool isWaiting = false;

  bool isProtocol(String res) {
    print("hala ress");
    print(res);
    if (res == "لطفا تمرین زیر رو انجام بده.") {
      return true;
    }
    return false;
  }

  String createProtocolText(String title, List<dynamic> details) {
    String string = "";
    string += title + ' ✅ \n\n';
    for (int i = 0; i < details.length; i += 1) {
      string += '${details[i]}\n\n';
    }
    return string;
  }

  Future<void> manageProtocol(String message, String status, String title,
      List<dynamic> details) async {
    print("protocolllllll, ${message}, ${status}, ${details}");
    // String protocolTitle = title;
    // setState(() {
    //   title = protocolTitle;
    //   protocol = details;
    // });

    await Future.delayed(Duration(milliseconds: 2500));
    setState(() {
      chat.add({"message": message, "sender": "user"});
    });

    await Future.delayed(Duration(milliseconds: 700));
    setState(() {
      chat.add({"message": status, "sender": "bot"});
    });

    await Future.delayed(Duration(milliseconds: 200));
    setState(() {
      chat.add({
        "message": createProtocolText(title, details),
        "sender": "protocol"
      });
    });
  }

  // String createProtocolText(String title, List<Map<String, dynamic>> details) {
  //   String text = '$title\n\n';
  //   for (var detail in details) {
  //     text += '✅ ${detail['detail']}\n\n';
  //   }
  //   return text;
  // }

  // Future<void> sendMessage(String message) async {
  //   print("hiiiii");
  //   print(message);
  //   setState(() {
  //     chat.add({"message": message, "sender": "user"});
  //   });

  //   if (message.toLowerCase() == "restart") {
  //     setState(() {
  //       chat = [];
  //       end = '';
  //     });
  //     // await restart(); // Call restart method instead of messageSet
  //   } else {
  //     final response = await fetchMessageFromAPI(message);
  //     if (isProtocol(response[0])) {
  //       await manageProtocol(message, response[0]['response'], response);
  //     } else {
  //       await Future.delayed(Duration(milliseconds: 2000));
  //       setState(() {
  //         chat.add({"message": response[0]['response'], "sender": "bot"});
  //       });
  //     }
  //     setState(() {
  //       end = response[0]['status'];
  //     });
  //   }

  //   setState(() {
  //     messageController.clear();
  //   });
  // }

  Future<void> sendMessage(String message) async {
    print("hiiiii");
    print(message);

    if (message != "empty") {
      setState(() {
        chat.add({"message": message, "sender": "user"});
      });
    }

    try {
      if (message.toLowerCase() == "restart") {
        setState(() {
          chat = [];
          end = '';
        });
        final response = await fetchMessageFromAPI(message);
        // Handle restart logic here
      } else {
        final response = await fetchMessageFromAPI(message);

        // Check if the response has the expected format
        // if (response.isNotEmpty && response[0].containsKey('response')) {
        final responseText = response[0]['response'];
        // if (isProtocol(responseText)) {
        //   await manageProtocol(message, responseText, response);
        // } else {
        print("done");
        // await Future.delayed(Duration(milliseconds: 2000));
        // print(responseText);
        // setState(() {
        //   chat.add({"message": responseText, "sender": "bot"});
        // });
        // }

        // setState(() {
        //   end = response[0]['status'];
        // });
        // } else {
        // print('Invalid response format: $response');
        // Handle unexpected response format
        // }
      }
    } catch (error) {
      print('Error sending message: $error');
      // Handle the error
    }

    setState(() {
      messageController.clear();
    });
  }

  // Future<List<Map<String, dynamic>>> fetchMessageFromAPI(String message) async {
  //   // Replace with your API call using http or Dio package
  //   await Future.delayed(Duration(seconds: 2)); // Simulating API call delay
  //   return [
  //     {
  //       "response": "This is a bot response for: $message",
  //       "status": "end",
  //     }
  //   ];
  // }

//  Future<List<Map<String, dynamic>>> fetchMessageFromAPI(String message) async {
//   final Uri uri = Uri.parse('http://127.0.0.1:8000/api/');
//   // final response = await http.post(uri, body: {"message": message});
//   // print(response.body);
//   // try {
//   //   final response = await http.post(
//   //     uri,
//   //     headers: {
//   //       'Content-Type': 'application/json', // Modify the content type if needed
//   //       "Access-Control-Allow-Origin": "*"
//   //     },
//   //     body: jsonEncode({
//   //       'message': message,
//   //     }),
//   //   );

//   //   if (response.statusCode == 200) {
//   //     print('POST request successful');
//   //     print('Response: ${response.body}');
//   //   } else {
//   //     print('POST request failed with status code: ${response.statusCode}');
//   //     print('Response: ${response.body}');
//   //   }
//   // } catch (error) {
//   //   print('Error making POST request: $error');
//   // }

//     final response = await http.post(uri, body: {"message": message});
//   print(response.body);
//   if (message == "restart") {
//     return [
//       {"response": response.body, "sender": "bot"}
//     ];
//   } else {
//     final responseData = json.decode(response.body);
//     final responseText = responseData['response'];
//     // print(utf8.decode(responseText));

//     if (isProtocol(responseText)) {
//       manageProtocol(
//           message, responseText.response, responseData); // Adjust the arguments accordingly
//     } else {
//       await Future.wait([
//         // controlTypingAnimation(1),
//         Future.delayed(Duration(milliseconds: 2000)),
//         // controlTypingAnimation(0)
//       ]);

//       return [
//         {"message": message, "sender": "user"},
//         {"response": responseText, "sender": "bot"}
//       ];
//     }

//     return [
//       {"message": message, "sender": "user"},
//       {"response": responseText, "sender": "bot"}
//     ];
//   }
// }

  Future<List<Map<String, dynamic>>> fetchMessageFromAPI(String message) async {
    print(chat);
    setState(() {
      isWaiting.add(true);
    });

    final Uri uri = Uri.parse('http://127.0.0.1:8000/api/');

    try {
      final response = await http
          .post(uri, body: {"username": widget.username, "message": message});
      print(response.body);

      // final responseData = json.decode(response.body);

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (message == "restart") {
        setState(() {
          isWaiting[isWaiting.length - 1] = false;
        });
        final responseText = responseData['response'];

        setState(() {
          chat.add({"message": responseText, "sender": "bot"});
        });

        setState(() {
          buttons.clear();
          buttons.add(responseData["buttons"][0]);
          buttons.add(responseData["buttons"][1]);
        });

        return [
          {
            "response": responseData,
            "sender": "bot"
          } // Assuming responseData is a string here
        ];
      } else {
        if (responseData is Map<String, dynamic>) {
          final responseText = responseData['response'];
          print("responseText, ${responseText}");
          setState(() {
            end = responseData["status"];
          });
          if (!(responseText is String)) {
            print("responseText, ${responseText}, ${responseText["response"]}");
            print("this is literally protocol!");
            manageProtocol(
                message,
                responseText["response"],
                responseText["title"],
                responseText["details"]); // Adjust the arguments accordingly

            setState(() {
              buttons.clear();
              buttons.add(responseData["buttons"][0]);
              buttons.add(responseData["buttons"][1]);
            });
          } else {
            await Future.wait([
              // controlTypingAnimation(1),
              Future.delayed(Duration(milliseconds: 2000)),
              // controlTypingAnimation(0)
            ]);

            //         setState(() {
            //   chat.add({"message": message, "sender": "user"});
            // });

            setState(() {
              chat.add({"message": responseText, "sender": "bot"});
            });

            setState(() {
              buttons.clear();
              buttons.add(responseData["buttons"][0]);
              buttons.add(responseData["buttons"][1]);
            });

            print(isWaiting);
            print(isWaiting.length);
            setState(() {
              isWaiting[isWaiting.length - 1] = false;
            });

            return [
              {"message": message, "sender": "user"},
              {"response": responseText, "sender": "bot"}
            ];
          }

          setState(() {
            isWaiting[isWaiting.length - 1] = false;
          });

          return [
            {"message": message, "sender": "user"},
            {"response": responseText, "sender": "bot"}
          ];
        } else {
          // Handle the case where responseData is not a map (unexpected format)
          print('Unexpected response format: $responseData');
          setState(() {
            isWaiting[isWaiting.length - 1] = false;
          });

          return [];
        }
      }
    } catch (error) {
      print('Error making POST request: $error');
      setState(() {
        isWaiting[isWaiting.length - 1] = false;
      });

      return [];
    }
  }

  void restart() {
    setState(() {
      chat = [];
      end = '';
    });
    sendMessage('restart');
  }

  @override
  void initState() {
    sendMessage("empty");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // useEffect(
    //   () {
    //     // initState

    //     return () {
    //       // dispose
    //     };
    //   },
    //   [],
    // );
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Chat App'),
        // ),
        body: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              color: Colors.blue,
              child: Text(
               'خود سے محبت کی بات',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chat.length + 1, // Add 1 for the FAQComponent
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // Display the FAQComponent as the first item
                    return FAQComponent();
                  } else {
                    // Display the regular chat items
                    final chatIndex = index - 1;
                    return ChatMessageBubble(
                      sender: chat[chatIndex]['sender']!,
                      message: chat[chatIndex]['message']!,
                      title: title,
                      isWaiting: true,
                      context: context,
                    );
                  }
                },
              ),
            ),
            if (end == 'end')
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0),
                child: ElevatedButton(
                  onPressed: restart,
                  child: Text(
                   'دوبارہ شروع کریں',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple, // Set the background color to blue
                    minimumSize: Size(120, 60), // Set the minimum size
                  ),
                ),
              ),
            if (end != 'end')
              Column(
                children: [
                  ButtonGroup(buttons: buttons, onPressed: sendMessage),
                  ChatInput(
                    messageController: messageController,
                    onPressed: sendMessage,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

// class ChatMessageBubble extends StatelessWidget {
//   final String sender;
//   final String message;
//   final String title;

//   ChatMessageBubble(
//       {required this.sender, required this.message, required this.title});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Align(
//         alignment:
//             sender == 'user' ? Alignment.centerRight : Alignment.centerLeft,
//         child: Container(
//           padding: EdgeInsets.all(12),
//           constraints: BoxConstraints(
//             maxWidth: sender == 'protocol' ? 650 : 750,
//           ),
//           decoration: BoxDecoration(
//             color: sender == 'user'
//                 ? Colors.blueAccent
//                 : sender == 'protocol'
//                     ? Colors.green
//                     : Colors.grey[300],
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(16),
//               topRight: Radius.circular(sender == 'user' ? 16 : 0),
//               bottomLeft: Radius.circular(16),
//               bottomRight: Radius.circular(sender == 'user' ? 0 : 16),
//             ),
//           ),
//           child: sender == 'protocol'
//               ? Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 17,
//                       ),
//                     ),
//                     Text(
//                       message.substring(title.length).trim(),
//                     ),
//                   ],
//                 )
//               : Text(
//                   message,
//                   style: TextStyle(
//                     color: sender == 'user' ? Colors.white : Colors.black,
//                     fontSize: 17,
//                   ),
//                 ),
//         ),
//       ),
//     );
//   }
// }

class ChatMessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final String title;
  final BuildContext context;
  AudioPlayer audioPlayer = AudioPlayer();

  // Define the isWaiting flag
  final bool isWaiting;

  ChatMessageBubble(
      {required this.sender,
      required this.message,
      required this.title,
      required this.isWaiting,
      required this.context});

  Future<void> playAudio(Source audioUrl) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'مجھے لگتا ہے کہ کوئی مسئلہ پیش آیا ہے۔ فی الحال آواز کی پخش ممکن نہیں ہے۔',
          textAlign: TextAlign.center,
        ),
        duration: Duration(seconds: 2), // مدت کو ترتیب دیں
      ),
    );
    await audioPlayer.play(audioUrl);
  }

  @override
  Widget build(BuildContext context) {
    print(message);
    print(isWaiting);

    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        sender == 'bot'
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(children: <Widget>[
                  Align(
                    alignment: sender == 'user'
                        ? Alignment.centerRight
                        : Alignment.centerRight,
                    child: Container(
                      padding: EdgeInsets.all(12),
                      constraints: BoxConstraints(
                        maxWidth: screenWidth < 500
                            ? 300
                            : screenWidth < 750
                                ? sender == 'protocol'
                                    ? 350
                                    : 400
                                : sender == 'protocol'
                                    ? 650
                                    : 750,
                      ),
                      decoration: BoxDecoration(
                        color: sender == 'user'
                            ? Colors.blueAccent
                            : sender == 'protocol'
                                ? Colors.green
                                : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(sender == 'user' ? 16 : 0),
                          bottomLeft: Radius.circular(16),
                          bottomRight:
                              Radius.circular(sender == 'user' ? 0 : 16),
                        ),
                      ),
                      child: sender == 'protocol'
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: screenWidth < 600 ? 14.5 : 17,
                                  ),
                                ),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Text(
                                    message.substring(title.length).trim(),
                                    style: TextStyle(
                                      fontSize: screenWidth < 600 ? 14.5 : 18,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Directionality(
                              textDirection: TextDirection.rtl,
                              child: Text(
                                message,
                                style: TextStyle(
                                  color: sender == 'user'
                                      ? Colors.white
                                      : Colors.black,
                                  fontSize: screenWidth < 600 ? 14.5 : 17,
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.volume_up),
                      onPressed: () {
                        // Assuming message is an audio URL
                        playAudio(UrlSource(
                            'https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav'));
                      },
                    ),
                  ),
                ]))
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: sender == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: screenWidth < 500
                          ? 300
                          : screenWidth < 750
                              ? sender == 'protocol'
                                  ? 350
                                  : 400
                              : sender == 'protocol'
                                  ? 650
                                  : 750,
                    ),
                    decoration: BoxDecoration(
                      color: sender == 'user'
                          ? Colors.blueAccent
                          : sender == 'protocol'
                              ? Color.fromARGB(255, 163, 218, 255)
                              : Colors.grey[300],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(sender == 'user' ? 16 : 0),
                        bottomLeft: Radius.circular(16),
                        bottomRight: Radius.circular(sender == 'user' ? 0 : 16),
                      ),
                    ),
                    child: sender == 'protocol'
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth < 600 ? 14.5 : 17,
                                ),
                              ),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: Text(
                                  message.substring(title.length).trim(),
                                  style: TextStyle(
                                    fontSize: screenWidth < 600 ? 14.5 : 18,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              message,
                              style: TextStyle(
                                color: sender == 'user'
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: screenWidth < 600 ? 14.5 : 17,
                              ),
                            ),
                          ),
                  ),
                ),
              ),
        // Use Visibility to show FlickeringDotsAnimation based on isWaiting
        Visibility(
          visible: isWaiting == true && sender == 'user',
          child: Align(
            alignment: Alignment.topRight,
            child: FlickeringDotsAnimation(),
          ),
        )
      ],
    );
  }
}

class ButtonGroup extends StatelessWidget {
  final List<String> buttons;
  final void Function(String) onPressed;

  ButtonGroup({required this.buttons, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth < 600 ? 300 : 700,
      height: screenWidth < 600 ? 70 : 80,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return Container(
            width: screenWidth < 600 ? 120 : 300,
            height: screenWidth < 600 ? 45 : 80,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Set the background color to blue
                minimumSize: Size(200, 90), // Set the minimum size
              ),
              onPressed: () => onPressed(button),
              child: Text(
                button,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth < 600 ? 14.5 : 16,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class ChatInput extends StatelessWidget {
  final TextEditingController messageController;
  final void Function(String) onPressed;

  ChatInput({required this.messageController, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: EdgeInsets.all(16),
        color: Colors.grey[300],
        child: Row(
          children: [
            Visibility(
              visible: screenWidth > 600,
              child: VoiceRecorderButton(
                uploadUrl: 'https://your-server.com/upload-audio',
              ),
            ),
            SizedBox(width: 8),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Set the desired border radius
              child: SizedBox(
                width: screenWidth < 600 ? 80 : 150, // Set the desired width
                height: screenWidth < 600 ? 35 : 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () => onPressed(messageController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set the background color to orange
                  ),
                  child: Text(
                    'ارسال پیام',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth < 600 ? 12 : 16,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: messageController,
                textAlign: TextAlign.right, // Align text input to the right
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                        20), // Set the desired border radius
                  ),
                  hintText: 'اپنا پیغام یہاں درج کریں...',
                  hintStyle: TextStyle(fontSize: screenWidth < 600 ? 13 : 18),
                  alignLabelWithHint: true, // Align the hint text to the right
                ),
              ),
            ),
            SizedBox(width: 8),
            ClipRRect(
              borderRadius:
                  BorderRadius.circular(10), // Set the desired border radius
              child: SizedBox(
                width: screenWidth < 600 ? 40 : 100, // Set the desired width
                height: screenWidth < 600 ? 30 : 50, // Set the desired height
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the SecondPage when the button is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SecondPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Set the background color to orange
                  ),
                  child: Image.asset('assets/help.png',
                      width: screenWidth < 600 ? 20 : 30,
                      height: screenWidth < 600 ? 20 : 30,
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

