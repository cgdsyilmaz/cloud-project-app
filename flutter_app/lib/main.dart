//reference : https://github.com/carzacc/jwt-tutorial-flutter
import 'package:flutter/material.dart';

import 'login_screen.dart';
import 'create_screen.dart';
import 'constants.dart';
import 'dart:convert';

void main() => runApp(new URLShortenerApp());

class URLShortenerApp extends StatelessWidget
{
    Future<String> get isTokenExist async
    {
        var token = await storage.read(key: "urlToken");
        if(token == null)
            return "";
        return token;
    }
    @override
    Widget build(BuildContext context)
    {

        return new MaterialApp(
            theme: new ThemeData(primarySwatch: Colors.deepOrange),
            title: 'URL Shortener App',
            home: FutureBuilder(
                future: isTokenExist,
                builder: (context, snapshot)
                {
                    if(!snapshot.hasData)
                        return CircularProgressIndicator();
                    if(snapshot.data != "")
                    {
                        var data = snapshot.data;
                        var token = data.split(".");

                        if(token.length != 3)
                        {
                            return LoginScreen();
                        }
                        else
                        {
                            var payload = json.decode(ascii.decode(base64.decode(base64.normalize(token[1]))));
                            return CreateScreen(data, payload);
                        }
                    }
                    else
                    {
                        return LoginScreen();
                    }
                },
            ),
        );
    }

}