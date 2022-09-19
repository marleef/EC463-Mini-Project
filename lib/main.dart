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

// void getapi() async {
//   var headers = {
//     'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
//     'Cookie': 'guest_id=v1%3A166335990863918549'
//   };
//   var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/34/following'));

//   request.headers.addAll(headers);

//   http.StreamedResponse response = await request.send();

//   if (response.statusCode == 200) {
//     print(await response.stream.bytesToString());
//   }
//   else {
//     print(response.reasonPhrase);
//   }

// }

Future<Post> fetchPostman() async {
  var headers = {
    'Access-Control-Allow-Origin': '*',
    'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
    'Cookie': 'guest_id=v1%3A166335990863918549'
  };
  // var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/23083404'));
  // request.headers.addAll(headers);

  // http.StreamedResponse response = await request.send();

  // if (response.statusCode == 200) {
  //   final String rawResponse = await response.stream.bytesToString();
  //   final decodedResponse = jsonDecode(rawResponse);
  //   return decodedResponse;
  // }
  // else {
  //   print(response.reasonPhrase);
  //   throw Exception("nononn");
  // }
  // var response = await request.send();
  // final sendresponse = await http.Response.fromStream(response);
  // if (response.statusCode == 200) {
  //   var responseData = jsonDecode(sendresponse["Data"]);
  //   List<Post> users = [];
  //   for (var singleData in responseData) {
  //     Post user = Post(
  //         id: singleData["id"],
  //         name: singleData["name"],
  //         username: singleData["username"]);
  
  //     //Adding user to the list.
  //     users.add(user);
  //   }
  //   return users;
  // }
  // else {
  //   print(response.reasonPhrase);
  //   throw Exception('nonononono');
  // }


    
  String url = "https://api.twitter.com/2/users/23083404";
  //   // Map<String, String> headers = {
  //   //   "Content-Type": "application/json",
  //   //   "Application-Token": "1569025925387272193-eeB8czHPQ9SZAG3afgFftQg7FvnUGP"
  //   // };
  //   // String id = '1228393702244134912';

  //   //var responseJson = json.decode(response.body);
  //   // List<Post> posts = [];
  //   // for (var singleContent in responseJson) {
  //   //   Post post = Post(
  //   //     userId: singleContent["userId"],
  //   //     id: singleContent["id"],
  //   //     title: singleContent["title"],
  //   //     body: singleContent["body"]);
  //   //   posts.add(post);
  //   // }
  //       //print(_response);
  //       // return _response;
  final response =
    await http.get(Uri.parse(url),
    headers: headers,
  );
  if(response.statusCode == 200){
    return Post.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to fetch from twitter');
  }
    // int statusCode = response.statusCode;
  // print('This is the statuscode: $statusCode');
    
    

    //print('This is the API response: $responseJson');
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
  //TextEditingController textEditingController = TextEditingController();
  String _text = "initial";
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";
  
  Future<void> readJson(String text) async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/$text'));
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
    }
    else {
      print(response.reasonPhrase);
      throw Exception("nononn");
    }
  }
  // var _posts;
  // void initState(){
  //   super.initState();
  //   Response = fetchPostman();

  //   setState(() {
  //     _posts = Response;
  //   });
  // }
  // int _counter = 0;
  // void _incrementCounter() {
  //   setState(() {
  //     // This call to setState tells the Flutter framework that something has
  //     // changed in this State, which causes it to rerun the build method below
  //     // so that the display can reflect the updated values. If we changed
  //     // _counter without calling setState(), then the build method would not be
  //     // called again, and so nothing would appear to happen.
  //     _counter++;
  //   });
  // }

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
            ElevatedButton(
              child: const Text(
                'Query User by id',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () {
                setState(() {
                  _text = _c.text;
                });
                // Navigator.pop(context);
                _sendDataToQueryUserbyIdScreen(context, _text);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await readJson(_text);
              },
              child: const Text('Present Results'),
            ),
            Text('id: $_id',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            Text('name: $_name',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            Text('username: $_username',
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold),),
            // Display the data loaded from sample.json
            // _items.isEmpty
            //     ? Expanded(
            //         child: ListView.builder(
            //           itemCount: _items.length,
            //           itemBuilder: (context, index) {
            //             return Card(
            //               margin: const EdgeInsets.all(10),
            //               child: ListTile(
            //                 leading: Text(_items),
            //                 title: Text(_items),
            //                 subtitle: Text(_items),
            //               ),
            //             );
            //           },
            //         ),
            //       )
            //     : Container(),
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
          builder: (context) => QueryUserbyIdScreen(text: textToSend,),
        ));
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
  late TextEditingController _c;
  //TextEditingController textEditingController = TextEditingController();
  String _text = "initial";
  dynamic _id = "";
  dynamic _name = "";
  dynamic _username = "";
  var Data;
  String url = 'http://10.0.2.2:5000/23083404';

  Future<void> readJson(String text) async {
    var headers = {
      'Access-Control-Allow-Origin': '*',
      'Authorization': 'Bearer AAAAAAAAAAAAAAAAAAAAAHbigwEAAAAAYLdcL0KXSTmyQJc%2FToCqDKoWSYg%3DL6Td4vHj1Q3MIvu7tjge6iyRYIwQOTXw0gCWaiS79ESHtPWrxj',
      'Cookie': 'guest_id=v1%3A166335990863918549'
    };
    var request = http.Request('GET', Uri.parse('https://api.twitter.com/2/users/$text'));
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
    }
    else {
      print(response.reasonPhrase);
      throw Exception("nononn");
    }
  }

  Future ConvertUrl(url) async {
    var request = http.Request('GET', Uri.parse(url));
    var headers = {
      "Access-Control-Allow-Origin": "*", // Required for CORS support to work
      // "Access-Control-Allow-Credentials": true, // Required for cookies, authorization headers with HTTPS
      "Access-Control-Allow-Headers": "Origin,content-type,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale, X-RapidAPI-Key, X-RapidAPI-Host",
      'Referrer-Policy' : 'no-referrer-when-downgrade',
      //'Accept': '*/*'
    };
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    // var uri = Uri.https('10.0.2.2:5000', '/23083404');
    // var response = await Client.get(uri);
    // http.Response response = await http.get(Uri.parse(url),headers: headers);
    // return response.body;
    if (response.statusCode == 200) {
      //var rawResponse = await response.stream.bytesToString();
      var rawResponse = await http.Response.fromStream(response);
      return rawResponse.body;
    } else{
      throw 'ConvertUrl request not successful';
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
      appBar: AppBar(title: Text('Query User by id Result Page')),
      body: Center(
        child: Column(children: [
        ElevatedButton(
              onPressed: () async {
                await readJson(widget.text);
              },
              child: const Text('Present Results'),
            ),
        ElevatedButton(
          onPressed: () async{
            const url = 'https://twitter.com/i/flow/login';
            if(await canLaunchUrl(Uri.parse(url))){
              await launchUrl(Uri.parse(url));
            } else {
              throw 'Could not launch $url';
            }
          },
          child: const Text('Open Twitter URL'),
        ),
        Text('id: $_id',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),),
        Text('name: $_name',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),),
        Text('username: $_username',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),),
        TextField(
          onChanged: (value) {
            url = 'http://127.0.0.1:5000/$value';
          },
          decoration: const InputDecoration(
            hintText: "Input id to check if user is real",
            // suffixIcon: GestureDetector(onTap: ()async{
            //   Data = await ConvertUrl(url);
            //   var DecodedData = jsonDecode(Data);
            //   setState(() {
            //     _c.text = DecodedData['astroturf'];
            //   });
            // },),
            ),
          style: const TextStyle(
            fontSize: 24,
            color: Colors.black,
          ),
        ),
        ElevatedButton(
              onPressed: () async {
                Data = await ConvertUrl(url);
                //var DecodedData = jsonDecode(Data);
                setState(() {
                  _text = Data;
                });
              },
              child: const Text('Click to check bot user'),
            ),
        Text('username: $_text, url = $url',
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.bold),),
        ],),
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

