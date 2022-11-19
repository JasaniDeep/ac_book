import 'package:ac_book/first.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screen_lock

import 'package:flutter_screen_lock/flutter_screen_lock.dart';
void main(){
  runApp(MaterialApp(
  home: first(),
));
}
class lock extends StatefulWidget {
  const lock({Key? key}) : super(key: key);

  @override
  State<lock> createState() => _lockState();
}

class _lockState extends State<lock> {
  bool confirn=true;
  String str="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        ),
      body: ScreenLock(
        // context: context,
        secretsConfig: SecretsConfig(
          spacing: 50,
          secretConfig: SecretConfig(
            borderColor: Colors.teal,
            enabledColor: Colors.orange,
            disabledColor: Colors.red,

          ),
        ),
        correctString: '1234',
        didUnlocked: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return first();
        },));
      },
      ),
    );
  }
}
