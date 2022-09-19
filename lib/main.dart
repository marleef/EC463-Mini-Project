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
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  // runApp(MaterialApp(
  //   initialRoute: '/',
  //   routes: {
  //     '/': (context) => const MyHomePage(),
  //     '/second': (context) => const PresentResults(),
  //   },
  //));
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

// class HomeRoute extends StatelessWidget {
//   const HomeRoute({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('EC463 Mini Project'),
//         backgroundColor: Colors.blue,
//       ), // AppBar
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               child: const Text('Click Me!'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/second');
//               },
//             ), // ElevatedButton
//             ElevatedButton(
//               child: const Text('Tap Me!'),
//               onPressed: () {
//                 Navigator.pushNamed(context, '/third');
//               },
//             ), // ElevatedButton
//           ], // <Widget>[]
//         ), // Column
//       ), // Center
//     ); // Scaffold
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EC463 Mini Project',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(title: 'Twitter Monitor'),
    );
  }
}

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   TextEditingController textEditingController = TextEditingController();
//   dynamic _id = "";
//   dynamic _name = "";
//   dynamic _username = "";

//   Future<void> readJson() async {
//     var headers = {
//       'Access-Control-Allow-Origin': '*',
//       'Authorization':
//           'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
//       'Cookie': 'guest_id=v1%3A166335990863918549'
//     };
//     var request = http.Request(
//         'GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
//     request.headers.addAll(headers);

//     http.StreamedResponse response = await request.send();

//     if (response.statusCode == 200) {
//       var rawResponse = await response.stream.bytesToString();
//       //var rawResponse = await http.Response.fromStream(response);
//       var decodedResponse = json.decode(rawResponse);
//       setState(() {
//         _id = decodedResponse["data"]["id"];
//         _name = decodedResponse["data"]["name"];
//         _username = decodedResponse["data"]["username"];
//       });
//       print(decodedResponse["data"]);
//     } else {
//       print(response.reasonPhrase);
//       throw Exception("nononn");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text(
//           'Twitter App',
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(25),
//         child: Column(
//           children: [
//             TextField(
//               controller: textEditingController,
//               style: const TextStyle(
//                 fontSize: 24,
//                 color: Colors.black,
//               ),
//             ),
//             ElevatedButton(
//               child: const Text(
//                 'Query User by id',
//                 style: TextStyle(fontSize: 24),
//               ),
//               onPressed: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return const TweetsPage(title: 'Landing Page');
//                 }));
//               },
//             ),
//             ElevatedButton(
//               onPressed: readJson,
//               child: const Text('Present Results'),
//             ),
//             Text(
//               'id: $_id',
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(
//               'name: $_name',
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(
//               'username: $_username',
//               textAlign: TextAlign.center,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // void _sendDataToQueryUserbyIdScreen(BuildContext context) {
//   //   String textToSend = textEditingController.text;
//   //   Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder: (context) => QueryUserbyIdScreen(
//   //           text: textToSend,
//   //         ),
//   //       ));
//   // }
// }

// class QueryUserbyIdScreen extends StatelessWidget {
//   final String text;

//   // receive data from the FirstScreen as a parameter
//   const QueryUserbyIdScreen({Key? key, required this.text}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Second screen')),
//       body: Center(
//         child: Text(
//           text,
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }

class UserInfo {
  dynamic id = "";
  dynamic name = "";
  dynamic username = "";

  UserInfo({this.id, this.name, this.username});
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Twitter App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            children: [
              TextField(
                controller: textEditingController,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              ElevatedButton(
                child: const Text(
                  'Query User by id',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: () {
                  // Navigator.push(context, MaterialPageRoute(builder: (context) {
                  //   return const TweetsPage(title: 'Landing Page');
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const ResultsPage(title: 'Results Page');
                  }));
                },
              ),
            ],
          ),
        ));
  }
}

class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, required this.title});

  final String title;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  TextEditingController textEditingController = TextEditingController();
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";

  Future<void> readJson() async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization':
          'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request = http.Request(
        'GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var rawResponse = await response.stream.bytesToString();
      //var rawResponse = await http.Response.fromStream(response);
      var decodedResponse = json.decode(rawResponse);
      setState(() {
        _id = decodedResponse["data"]["id"];
        _name = decodedResponse["data"]["name"];
        _username = decodedResponse["data"]["username"];
      });
      print(decodedResponse["data"]);
    } else {
      print(response.reasonPhrase);
      throw Exception("nononn");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Twitter App',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text(
              'id: $_id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'name: $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'username: $_username',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              child: const Text(
                'Tweets',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TweetsPage(title: 'Tweets');
                }));
              },
            ),
            ElevatedButton(
              child: const Text(
                'Sentiments',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SentimentsPage(title: 'Sentiments');
                }));
              },
            ),
            ElevatedButton(
              child: const Text(
                'Topics',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TopicsPage(title: 'Topics');
                }));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SentimentsPage extends StatelessWidget {
  const SentimentsPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      backgroundColor: Colors.blue,
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
        title: Text(title),
      ),
      backgroundColor: Colors.blue,
    );
  }
}

class TweetsPage extends StatelessWidget {
  const TweetsPage({Key? key, required this.title}) : super(key: key);
  final String title;
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
        title: Text(title),
      ),
      backgroundColor: Colors.blue,
      body: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                child: Center(
                  child: Text(
                    "Twitter Timeline \nin \nFlutter Web",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline3?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20.0),
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
