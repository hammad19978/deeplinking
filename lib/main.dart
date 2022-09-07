import 'package:deeplinking/post_screen.dart';
import 'package:deeplinking/utils.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_share/flutter_share.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:
          ThemeData(primarySwatch: Colors.yellow, brightness: Brightness.dark),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String url = "";
  bool isCheck = false;

  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  ///Retreive dynamic link firebase.
  void initDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    final Uri? deepLink = data?.link;

    if (deepLink != null) {
      handleDynamicLink(deepLink);
    }
    FirebaseDynamicLinks.instance.onLink(
        onSuccess: (PendingDynamicLinkData? dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      if (deepLink != null) {
        handleDynamicLink(deepLink);
      }
    }, onError: (OnLinkErrorException e) async {
      print(e.message);
    });
  }

  handleDynamicLink(Uri url) {
    List<String> separatedString = [];
    separatedString.addAll(url.path.split('/'));
    if (separatedString[1] == "deeplink") {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PostScreen(separatedString[2])));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: () async {
                  try {
                    url = await AppUtils.buildDynamicLink();
                  } catch (e) {
                    print(e);
                  }
                  isCheck = true;
                  setState(() {});
                },
                child: Text(
                  "Generate Dynamic Link",
                  style: TextStyle(fontSize: 20),
                )),
            const SizedBox(
              height: 20,
            ),
            if (url.isNotEmpty)
              Center(
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(text: url, style: TextStyle(fontSize: 20)),
                  WidgetSpan(
                      child: IconButton(
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: url));
                          },
                          icon: Icon(Icons.copy))),
                ])),
              ),
            (isCheck == true)
                ? MaterialButton(
                    onPressed: () {
                      share();
                    },
                    child: Text("Share the link"),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Future<void> share() async {
    await FlutterShare.share(
      title: 'DeepLink share',
      text: 'Lets do it',
      linkUrl: url,
    );
  }
}
