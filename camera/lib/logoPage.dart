import 'package:camera/homePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LogoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(
                      'https://image.freepik.com/free-vector/image-upload-concept-landing-page_23-2148321612.jpg'),
                  fit: BoxFit.contain)),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 160),
            child: ButtonTheme(
              minWidth: 200,
              height: 40,
              child: RaisedButton(
                elevation: 10,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: Colors.green[300],
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyHomePage()),
                  );
                },
                child: Text("Get Started"),
              ),
            ),
          ),
        )
      ],
    );
  }
}
