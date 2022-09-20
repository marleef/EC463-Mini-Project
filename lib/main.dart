import 'dart:convert';
import 'dart:developer';
import 'dart:html';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'postModel.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'dart:ui' as ui;

Future<void> main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Future<Post> fetchPostman() async {
  var headers = {
    'Access-Control-Allow-Origin': '*',
    'Authorization':
        'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
    'Cookie': 'guest_id=v1%3A166335990863918549'
  };

  String url = "https://api.twitter.com/2/users/23083404";

  final response = await http.get(
    Uri.parse(url),
    headers: headers,
  );
  if (response.statusCode == 200) {
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch from twitter');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EC463 Mini Project',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black87,
        fontFamily: 'JetBrainsMono',
        textTheme: const TextTheme(
          headline1: TextStyle(
              fontSize: 72.0, fontWeight: FontWeight.w700, color: Colors.white),
          headline2: TextStyle(
              fontSize: 36.0, fontWeight: FontWeight.w700, color: Colors.white),
          bodyText1: TextStyle(
              fontSize: 14.0,
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
        textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
          foregroundColor: Colors.white,
        )),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          titleTextStyle: TextStyle(
              color: Colors.white,
              fontFamily: 'JetBrainsMono',
              fontSize: 24.0,
              fontWeight: FontWeight.w700),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
      ),
      home: const HomePage(title: 'Home'),
    );
  }
}

class UserInfo {
  dynamic id = "";
  dynamic name = "";
  dynamic username = "";

  UserInfo({this.id, this.name, this.username});
}

class InputField {
  final String input;
  InputField({required this.input});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final inputController = TextEditingController();
  // TextEditingController textEditingController = TextEditingController();
  // dynamic _id = "";
  // dynamic _name = "";
  // dynamic _username = "";

  // Future<void> readJson() async {
  //   var headers = {
  //     'Access-Control-Allow-Origin': '*',
  //     'Authorization':
  //         'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
  //     'Cookie': 'guest_id=v1%3A166335990863918549'
  //   };
  //   var request = http.Request(
  //       'GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
  //   request.headers.addAll(headers);

  //   http.StreamedResponse response = await request.send();

  //   if (response.statusCode == 200) {
  //     var rawResponse = await response.stream.bytesToString();
  //     var decodedResponse = json.decode(rawResponse);
  //     setState(() {
  //       _id = decodedResponse["data"]["id"];
  //       _name = decodedResponse["data"]["name"];
  //       _username = decodedResponse["data"]["username"];
  //     });
  //     print(decodedResponse["data"]);
  //   } else {
  //     print(response.reasonPhrase);
  //     throw Exception("nononn");
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Twitter Monitor',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        backgroundColor: Colors.black87,
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: inputController,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              TextButton(
                child: const Text('Query User by ID',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TweetsPage(
                                title: 'Tweets',
                                //data: inputController.text,
                              )));
                },
              ),
            ],
          ),
        ));
  }
}

// class ResultsPage extends StatefulWidget {
//   dynamic data;
//   ResultsPage({super.key, required this.title, this.data});
//   //final TextEditingController inputController;
//   final String title;

//   @override
//   _ResultsPageState createState() => _ResultsPageState();
// }

// class _ResultsPageState extends State<ResultsPage> {
//   TextEditingController textEditingController = TextEditingController();
//   dynamic _id = "";
//   dynamic _name = "";
//   dynamic _username = "";

//   Future<void> readJson() async {
//     var headers = {
//       'Access-Control-Allow-Origin': '*',
//     'Authorization':
//         'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
//     'Cookie': 'guest_id=v1%3A166335990863918549'
//   };
//   var request = http.Request(
//       'GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     var rawResponse = await response.stream.bytesToString();
//     var decodedResponse = json.decode(rawResponse);
//     setState(() {
//       _id = decodedResponse["data"]["id"];
//       _name = decodedResponse["data"]["name"];
//       _username = decodedResponse["data"]["username"];
//     });
//     print(decodedResponse["data"]);
//   } else {
//     print(response.reasonPhrase);
//     throw Exception("nononn");
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     appBar: AppBar(
//       centerTitle: true,
//       title: Text(
//         'Twitter Monitor',
//         style: Theme.of(context).appBarTheme.titleTextStyle,
//       ),
//     ),
//     backgroundColor: Colors.black87,
//     body: Padding(
//       padding: const EdgeInsets.all(25),
//       child: Column(
//         children: [
//           Text(
//             'id : $_id',
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           Text(
//             'name: $_name',
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             style: Theme.of(context).textTheme.bodyText1,
//           ),
//           Text(
//             'username: $_username',
//             textAlign: TextAlign.center,
//             overflow: TextOverflow.ellipsis,
//             style: Theme.of(context).textTheme.bodyText1,
// ),
// TextButton(
//   child: const Text(
//     'Tweets',
//     style: TextStyle(fontSize: 24, color: Colors.white),
//   ),
//   onPressed: () {
//     Navigator.push(context, MaterialPageRoute(builder: (context) {
//       return const TweetsPage(title: 'Tweets');
//     }));
//   },
// ),
//             TextButton(
//               child: const Text(
//                 'Sentiments',
//                 style: TextStyle(fontSize: 24, color: Colors.white),
//               ),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return const SentimentsPage(title: 'Sentiments');
//                 }));
//               },
//             ),
//             TextButton(
//               child: const Text(
//                 'Topics',
//                 style: TextStyle(fontSize: 24, color: Colors.white),
//               ),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return const TopicsPage(title: 'Topics');
//                 }));
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SentimentsPage extends StatelessWidget {
  const SentimentsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      backgroundColor: Colors.black87,
    );
  }
}

class TopicsPage extends StatelessWidget {
  const TopicsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      backgroundColor: Colors.black87,
    );
  }
}

class TweetsPage extends StatelessWidget {
  const TweetsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  // String _id = "";
  // String _name = "";
  // String _username = "";
  @override
  Widget build(BuildContext context) {
    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'twitter',
      (int uid) {
        IFrameElement _iFrame = IFrameElement()..src = "web/twitter.html";
        _iFrame.style.border = "none";
        return _iFrame;
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).appBarTheme.titleTextStyle),
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.all(200.0),
                child: Column(
                  
                            mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'id: \n',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'name: \n',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      Text(
                        'username: \n',
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                      TextButton(
                        child: const Text(
                          'Sentiments',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 121, 177, 224)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const SentimentsPage(title: 'Sentiments');
                          }));
                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Topics',
                          style: TextStyle(
                              fontSize: 14.0,
                              color: Color.fromARGB(255, 121, 177, 224)),
                        ),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return const TopicsPage(title: 'Topics');
                          }));
                        },
                      ),
                    ]),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(30.0),
                child: HtmlElementView(
                  viewType: "twitter",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
