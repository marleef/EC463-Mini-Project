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
import 'dart:math' as math;

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

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;
  @override
  State<HomePage> createState() => _HomePageState();
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

class _HomePageState extends State<HomePage> {
  late TextEditingController _c;
  String _text = "initial";

  @override
  void initState() {
    _c = TextEditingController();
    super.initState();
  }

  SliverPersistentHeader makeHeader(String headerText) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverAppBarDelegate(
        minHeight: 60.0,
        maxHeight: 200.0,
        child: Container(
            color: Colors.lightBlue, child: Center(child: Text(headerText))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'twitter',
      (int uid) {
        IFrameElement _iFrame = IFrameElement()..src = "web/twitter.html";
        _iFrame.style.border = "none";
        return _iFrame;
      },
    );

    return CustomScrollView(slivers: <Widget>[
      makeHeader('Twitter Monitor'),
      SliverFixedExtentList(
          itemExtent: 5.0,
          delegate: SliverChildListDelegate([
            Container(
              child: TextField(
                  controller: _c, style: Theme.of(context).textTheme.bodyText1),
            ),
            Container(
              child: TextButton(
                child: const Text('Query User by ID',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  setState(() {
                    _text = _c.text;
                  });
                  Navigator.pop(context);
                  _sendDataToQueryUserbyIdScreen(context, _text);
                },
              ),
            ),
            //Container(child: HtmlElementView(viewType: "twitter")),
          ]))
    ]);
  }

/*
    return Scaffold(
        appBar: AppBar(
          title: Text('Twitter Monitor',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        backgroundColor: Colors.black87,
        body: Center(
          // child: ListView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, int index) => _items[index],
                ),
              ),
              TextField(
                controller: _c,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              TextButton(
                child: const Text('Query User by ID',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  setState(() {
                    _text = _c.text;
                    _items.add(HtmlElementView(viewType: "twitter"));
                  });
                  Navigator.pop(context);
                  _sendDataToQueryUserbyIdScreen(context, _text);

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => TweetsPage(
                  //               title: 'Tweets',
                  //             )));
                },
              ),
              TextButton(
                child: const Text('Check User/Bot Function',
                    style: TextStyle(
                        fontSize: 14.0,
                        color: Color.fromARGB(255, 121, 177, 224))),
                onPressed: () {
                  setState(() {
                    _text = _c.text;
                  });
                  // Navigator.pop(context);
                  _sendDataToCheckBotScreen(context, _text);
                },
              ),
            ],
          ),
        ));
  }
*/
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
                style: Theme.of(context).textTheme.bodyText1),
            const SizedBox(
              height: 20.0,
            ),
            TextButton(
              onPressed: () async {
                await CheckBot(_c.text);
              },
              child: const Text(
                'Click to check bot user',
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 121, 177, 224)),
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
      appBar: AppBar(title: Text('Query User by ID Page')),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: _c,
              decoration: const InputDecoration(
                hintText: "Input ID to check if user is real",
              ),
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              onPressed: () async {
                await readJson(_c.text);
              },
              child: const Text('Click to check another user by ID'),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Id: $_id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Name: $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            const SizedBox(
              height: 10.0,
            ),
            Text(
              'Username: $_username',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyText1,
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
                style: Theme.of(context).textTheme.bodyText1,
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

// )
// return Scaffold(
//     appBar: AppBar(
//       title: Text('Twitter Monitor',
//       style: Theme.of(context).appBarTheme.titleTextStyle),
// ),
// backgroundColor: Colors.black87,
// body: Padding(
//   padding: const EdgeInsets.all(25),
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: [
//       TextField(
//         controller: inputController,
//         style: Theme.of(context).textTheme.bodyText1,
//       ),
//       TextButton(
//         child: const Text('Query User by ID',
//             style: TextStyle(
//                 fontSize: 14.0,
//                 color: Color.fromARGB(255, 121, 177, 224))),
//         onPressed: () {
//           Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => TweetsPage(
//                         title: 'Tweets',
//                         //data: inputController.text,
//                       )));
//         },
//       ),
//     ],
//   ),
// ));
//   }
// }

class ResultsPage extends StatefulWidget {
  dynamic data;
  ResultsPage({super.key, required this.title, this.data});
  //final TextEditingController inputController;
  final String title;

  @override
  _ResultsPageState createState() => _ResultsPageState();
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
        title: Text(
          'Twitter Monitor',
          style: Theme.of(context).appBarTheme.titleTextStyle,
        ),
      ),
      backgroundColor: Colors.black87,
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
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
                'Tweets',
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const TweetsPage(title: 'Tweets');
                }));
              },
            ),
            TextButton(
              child: const Text(
                'Sentiments',
                style: TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 121, 177, 224)),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const SentimentsPage(title: 'Sentiments');
                }));
              },
            ),
            TextButton(
              child: const Text(
                'Topics',
                style: TextStyle(
                    fontSize: 14.0, color: Color.fromARGB(255, 121, 177, 224)),
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