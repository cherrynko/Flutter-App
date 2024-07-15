import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:convert' show utf8;

import 'package:sat_project/three_dots_orange.dart';

class SecondPage extends StatefulWidget {
  @override
  _ChatAppState createState() => _ChatAppState();
}

class _ChatAppState extends State<SecondPage> {
  List<Map<String, String>> chat = [];
  String end = '';
  List<String> buttons = [];
  List<Map<String, dynamic>> protocol = [];
  String title = '';
  TextEditingController messageController = TextEditingController();

  ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  bool isProtocol(Map<String, dynamic> res) {
    if (res['response'] == "لطفا تمرین زیر رو انجام بده.") {
      return true;
    }
    return false;
  }

  Future<void> manageProtocol(
      String message, String status, List<Map<String, dynamic>> details) async {
    String protocolTitle = details[0]['response']['title'];
    setState(() {
      title = protocolTitle;
      protocol = details[0]['response']['details'];
    });

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
        "message": createProtocolText(protocolTitle, protocol),
        "sender": "protocol"
      });
    });
  }

  String createProtocolText(String title, List<Map<String, dynamic>> details) {
    String text = '$title\n\n';
    for (var detail in details) {
      text += '✅ ${detail['detail']}\n\n';
    }
    return text;
  }

  Future<void> sendMessage(String message) async {
    print("hiiiii");
    print(message);

    setState(() {
      chat.add({"message": message, "sender": "user"});
    });

    try {
      if (message.toLowerCase() == "restart") {
        setState(() {
          chat = [];
          end = '';
        });
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

  Future<List<Map<String, dynamic>>> fetchMessageFromAPI(String message) async {
    final Uri uri = Uri.parse('http://127.0.0.1:8000/api/');

    try {
      final response = await http.post(uri, body: {"question": message});
      print(response.body);

      // final responseData = json.decode(response.body);

      final responseData = jsonDecode(utf8.decode(response.bodyBytes));

      if (responseData is Map<String, dynamic>) {
        final responseText = responseData['answer'];

        print(responseText);

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

        return [
          {"message": message, "sender": "user"},
          {"response": responseText, "sender": "bot"}
        ];
      } else {
        // Handle the case where responseData is not a map (unexpected format)
        print('Unexpected response format: $responseData');
        return [];
      }
    } catch (error) {
      print('Error making POST request: $error');
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
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title: Text('Chat App'),
        // ),
        appBar: AppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            ),
          ),
          backgroundColor: Colors.orange,
          title: Text(
            'خود سے لگاؤ ​​کا استا',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: chat.length,
                itemBuilder: (context, index) {
                  return ChatMessageBubble(
                    sender: chat[index]['sender']!,
                    message: chat[index]['message']!,
                    title: title,
                    isWaiting: true,
                  );
                },
              ),
            ),
            if (end == 'end')
              ElevatedButton(
                onPressed: restart,
                child: Text('دوبارہ شروع کریں'),
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
//                 ? Colors.orangeAccent
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

  // Define the isWaiting flag
  final bool isWaiting;

  ChatMessageBubble({
    required this.sender,
    required this.message,
    required this.title,
    required this.isWaiting,
  });

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
                child: Row(
                  children: <Widget>[
                    Align(
                      alignment: sender == 'user'
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(12),
                        constraints: BoxConstraints(
                          maxWidth: screenWidth < 600
                              ? sender == 'protocol'
                                  ? 300
                                  : 300
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
                            topRight:
                                Radius.circular(sender == 'user' ? 16 : 0),
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
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Align(
                  alignment: sender == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: screenWidth < 600
                          ? sender == 'protocol'
                              ? 300
                              : 300
                          : sender == 'protocol'
                              ? 650
                              : 750,
                    ),
                    decoration: BoxDecoration(
                      color: sender == 'user'
                          ? Colors.orangeAccent
                          : sender == 'protocol'
                              ? Colors.green
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
            child: FlickeringDotsAnimationOrange(),
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
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: buttons.map((button) {
          return ElevatedButton(
            onPressed: () => onPressed(button),
            child: Text(button),
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

    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[300],
      child: Row(
        children: [
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
                hintText:
                   'آپ مجھ سے خود سے منسلک ہونے کے بارے میں کوئی سوال پوچھ سکتے ہیں :) مثال کے طور پر؛ خود سے لگاؤ ​​کیا ہے؟',
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
              width: screenWidth < 600 ? 80 : 150, // Set the desired width
              height: screenWidth < 600 ? 30 : 50, // Set the desired height
              child: ElevatedButton(
                onPressed: () => onPressed(messageController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // Set the background color to orange
                ),
                child: Text(
                  'سوالات پوچھنا',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: screenWidth < 600 ? 14 : 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

