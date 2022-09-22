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
import 'package:url_launcher/url_launcher.dart';

Future<void> main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EC463 Mini Project',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Twitter Monitor'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late TextEditingController _c;
  String _text = "initial";

  @override
  void initState() {
    _c = TextEditingController();
    super.initState();
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(hintText: "Search by id"),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: const Text(
                'Query User by id Function',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                setState(() {
                  _text = _c.text;
                });
                // Navigator.pop(context);
                _sendDataToQueryUserbyIdScreen(context, _text);
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              child: const Text(
                'Check User/Bot Function',
                style: TextStyle(fontSize: 30),
              ),
              onPressed: () {
                setState(() {
                  _text = _c.text;
                });
                // Navigator.pop(context);
                _sendDataToCheckBotScreen(context, _text);
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                const url = 'https://twitter.com/i/flow/login';
                if (await canLaunchUrl(Uri.parse(url))) {
                  await launchUrl(Uri.parse(url));
                } else {
                  throw 'Could not launch $url';
                }
              },
              child: const Text('Open Twitter URL',
                  style: TextStyle(fontSize: 30)),
            ),
          ],
        ),
      ),
    );
  }

  void _sendDataToQueryUserbyIdScreen(BuildContext context, String text) {
    String textToSend = text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QueryUserbyIdScreen(
            text: textToSend,
          ),
        ));
  }

  void _sendDataToCheckBotScreen(BuildContext context, String text) {
    String textToSend = text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CheckBotScreen(
            text: textToSend,
          ),
        ));
  }
}

class CheckBotScreen extends StatefulWidget {
  final String text;

  // receive data from the FirstScreen as a parameter
  const CheckBotScreen({super.key, required this.text});
  @override
  _CheckBotScreenState createState() {
    return _CheckBotScreenState();
  }
}

class _CheckBotScreenState extends State<CheckBotScreen> {
  TextEditingController _c = TextEditingController();
  var Data;
  String url = '';
  String _text = '';
  Future ConvertUrl(String urL) async {
    var request = http.Request('GET', Uri.parse(urL));
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      "Access-Control-Allow-Headers":
          "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
      'Referrer-Policy': 'no-referrer-when-downgrade',
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var rawResponse = await http.Response.fromStream(response);
      return rawResponse.body;
    } else {
      return "User Not found, cannot perform bot check.";
    }
  }

  Future<void> CheckBot(String inputText) async {
    var inputUrl = 'http://127.0.0.1:5000/$inputText';
    Data = await ConvertUrl(inputUrl);
    setState(() {
      _text = Data;
      url = inputUrl;
    });
  }

  @override
  void initState() {
    CheckBot(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bot Account Checker Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                hintText: "Input id to check if user is real",
              ),
              style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await CheckBot(_c.text);
              },
              child: const Text(
                'Click to check bot user',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Bot score: $_text\n\nQueried url: $url',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}

class QueryUserbyIdScreen extends StatefulWidget {
  final String text;

  // receive data from the FirstScreen as a parameter
  const QueryUserbyIdScreen({super.key, required this.text});
  @override
  _QueryUserbyIdScreenState createState() {
    return _QueryUserbyIdScreenState();
  }
}

class _QueryUserbyIdScreenState extends State<QueryUserbyIdScreen> {
  TextEditingController _c = TextEditingController();
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";
  dynamic _error_flag;
  dynamic _error_visibility = false;

  Future<void> readJson(String text) async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization':
          'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request =
        http.Request('GET', Uri.parse('https://api.twitter.com/2/users/$text'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var rawResponse = await response.stream.bytesToString();
      //var rawResponse = await http.Response.fromStream(response);
      var decodedResponse = json.decode(rawResponse);
      try {
        setState(() {
          _id = decodedResponse["data"]["id"];
          _name = decodedResponse["data"]["name"];
          _username = decodedResponse["data"]["username"];
          _error_flag = "";
          _error_visibility = false;
        });
      } catch (error) {
        setState(() {
          _id = "";
          _name = "";
          _username = "";
          _error_flag = decodedResponse["errors"][0]["detail"];
          _error_visibility = true;
        });
      }

      // if (error_visibility){
      //   setState(() {
      //     _error_flag = "Cannot find User with Userid $text.";
      //     error_visibility = true;
      //   });
      // }
    } else {
      throw Exception("Check user by Id request failed.");
    }
  }

  @override
  void initState() {
    readJson(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Query User by id Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                hintText: "Input id to check if user is real",
              ),
              style: const TextStyle(
                fontSize: 24,
                color: Colors.black,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await readJson(_c.text);
              },
              child: const Text('Click to check another user by Id'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Id: $_id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Name: $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Username: $_username',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
            ),
            SizedBox(
              height: 10.0,
            ),
            Visibility(
              visible: _error_visibility,
              child: Text(
                'Error Message: $_error_flag',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: Colors.red),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
          ],
        ),
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return MaterialApp(
//     title: 'Fetch Data Example',
//     theme: ThemeData(
//       primarySwatch: Colors.blue,
//     ),
//     home: Scaffold(
//       appBar: AppBar(
//         title: const Text('Fetch Data Example'),
//       ),
//       body: Center(
//         child: FutureBuilder(
//           future: fetchPostman(),
//           builder: (BuildContext ctx, AsyncSnapshot snapshot) {
//             if (snapshot.data == null) {
//               return Container(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data.length,
//                 itemBuilder: (ctx, index) => ListTile(
//                   title: Text(snapshot.data[index].name),
//                   subtitle: Text(snapshot.data[index].username),
//                   contentPadding: EdgeInsets.only(bottom: 20.0),
//                 ),
//               );
//             }
//           },
//         ),

// child: ListView.builder(
//   itemCount: _posts.length,
//   itemBuilder: (context, i) {
//     final post = _posts[i];
//     return Text("id: ${post["id"]}\n Name: ${post["name"]} \n username: ${post["username"]}}\n\n");
//   }
// ),

// child: FutureBuilder(
//   future: Response,
//   builder: (context, snapshot) {
//     if (snapshot.hasData) {
//       return ListView.builder(
//         itemCount: _posts.length,
//         itemBuilder: (context, i) {
//           final post = _posts[i];
//           return Text("id: ${post["id"]}\n Name: ${post["name"]} \n username: ${post["username"]}}\n\n");
//         }
//       );
//     } else if (snapshot.hasError) {
//       return Text('hello, ${snapshot.error}');
//     }

//     // By default, show a loading spinner.
//     return const CircularProgressIndicator();
//   },
// ),
//       ),
//     ),
//   );
// }
