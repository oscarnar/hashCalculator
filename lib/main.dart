import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

void main() {
  runApp(MyApp());
}

String message,keyHMAC;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hash Calculator',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HashCalculator(), //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HashCalculator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hash Calculator'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: FormWidget(),
          ),
        ],
      ),
    );
  }
}

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Invalid text";
                }
              },
              keyboardType: TextInputType.emailAddress,
              decoration: decorationField(
                hintText: 'Text',
                icon: Icon(Icons.text_snippet),
              ),
              onSaved: (value) {
                message = value;
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              height: size.width * 0.1,
            ),
            ButtonLogin(formKey: _formKey),
          ],
        ),
      ),
    );
  }

  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red[400], width: 2.5),
    borderRadius: BorderRadius.circular(25),
  );
  final OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.teal,
      width: 2.5,
    ),
    borderRadius: BorderRadius.circular(25),
  );
  final OutlineInputBorder enableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(25),
  );
  InputDecoration decorationField(
      {@required String hintText, @required Icon icon}) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: enableBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedBorder,
      disabledBorder: enableBorder,
      fillColor: Colors.white54,
      filled: true,
      prefixIcon: icon,
    );
  }
}

class ButtonLogin extends StatelessWidget {
  ButtonLogin({Key key, @required GlobalKey<FormState> formKey})
      : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildRaisedButton(context, "MD5"),
        SizedBox(
          height: 8,
        ),
        buildRaisedButton(context, "SHA1"),
        SizedBox(
          height: 8,
        ),
        buildRaisedButton(context, "SHA256"),
        SizedBox(
          height: 8,
        ),
        buildRaisedButton(context, "HMAC-SHA256"),
      ],
    );
  }

  RaisedButton buildRaisedButton(BuildContext context, String function) {
    return RaisedButton(
      padding: EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 40,
      ),
      onPressed: () {
        if (_formKey.currentState.validate()) {
          _formKey.currentState.save();
          print(message);
          hashFuntion(context, message, function).then((value) => print(value));
        }
      },
      color: Colors.teal, //Colors.blue[700], //Color(0xFF005099),
      shape: StadiumBorder(),
      child: Text(
        "$function",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontSize: 17,
        ),
      ),
    );
  }
}

Future<String> hashFuntion(
    BuildContext context, String message, String function) async {
  var bytes = utf8.encode(message); // data being hashed

  var digest = sha1.convert(bytes);

  Future<String> ReadKey() {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: FormKey(),
        );
      },
    );
  }

  switch (function) {
    case "MD5":
      {
        digest = md5.convert(bytes);
      }
      break;
    case "SHA1":
      {
        digest = sha1.convert(bytes);
      }
      break;
    case "SHA256":
      {
        digest = sha256.convert(bytes);
      }
      break;
    case "HMAC-SHA256":
      {
        String userkey;
        await ReadKey().then((value) => userkey = value);
        print("$userkey from switch case");
        var key = utf8.encode(userkey);
        var hmacSha256 = new Hmac(sha256, key); // HMAC-SHA256
        digest = hmacSha256.convert(bytes);
      }
      break;
    default:
  }

  print("Digest as hex string: ${digest.toString()}");
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('$function'),
        content: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("$digest"),
            ],
          ),
        ),
        actions: [
          MaterialButton(
            elevation: 5,
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop("Successful!");
            },
          )
        ],
      );
    },
  );
}

class FormKey extends StatefulWidget {
  @override
  _FormKeyState createState() => _FormKeyState();
}

class _FormKeyState extends State<FormKey> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 10),
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return "Invalid key";
                }
              },
              keyboardType: TextInputType.emailAddress,
              obscureText: true,
              decoration: decorationField(
                  hintText: 'Key',
                  icon: Icon(
                    Icons.security,
                  )),
              onSaved: (value) {
                keyHMAC = value;
              },
            ),
            SizedBox(height: 10),
            SizedBox(
              height: size.width * 0.1,
            ),
            RaisedButton(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 40,
              ),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  print(keyHMAC);
                  Navigator.of(context).pop("$keyHMAC");
                }
              },
              color: Colors.teal, //Colors.blue[700], //Color(0xFF005099),
              shape: StadiumBorder(),
              child: Text(
                "Calculate",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  final OutlineInputBorder errorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.red[400], width: 2.5),
    borderRadius: BorderRadius.circular(25),
  );
  final OutlineInputBorder focusedBorder = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.teal,
      width: 2.5,
    ),
    borderRadius: BorderRadius.circular(25),
  );
  final OutlineInputBorder enableBorder = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white),
    borderRadius: BorderRadius.circular(25),
  );
  InputDecoration decorationField(
      {@required String hintText, @required Icon icon}) {
    return InputDecoration(
      hintText: hintText,
      enabledBorder: enableBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedBorder,
      disabledBorder: enableBorder,
      fillColor: Colors.white54,
      filled: true,
      prefixIcon: icon,
    );
  }
}
