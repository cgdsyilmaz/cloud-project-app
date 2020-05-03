import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'create_screen.dart';

class LoginScreen extends StatelessWidget
{
	final TextEditingController _usernameController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

	void displayNotification(context, title, text) => showDialog(
		context: context,
		builder: (context) =>
			AlertDialog(
				title: Text(title),
				content: Text(text)
			),
	);

	Future<String> tryLogin(String username, String password) async
	{
		var httpResult = await http.post(
			'$SERVER_ADDRESS_AUTH/$AUTH_LOGIN_PATH',
			headers: {"Accept": "application/json", "content-type": "application/json"},
			body:jsonEncode(
			{
				"username": username,
				"password": password
			}
			)
		);
		if(httpResult.statusCode == 200) //login success
		{
			return httpResult.body;
		}

		return null;
	}

	Future<int> trySignUp(String username, String password) async
	{
		var httpResult = await http.post(
			'$SERVER_ADDRESS_AUTH/$AUTH_SIGN_UP_PATH',
			headers: {"Accept": "application/json", "content-type": "application/json"},
			body: jsonEncode(
			{
				"username": username,
				"password": password,
				"role": "CUSTOMER"
			}
			)
		);
		return httpResult.statusCode;
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: Text("URL Shortener Login"),),
			body: Padding(
				padding: const EdgeInsets.all(15.0),
				child: Column(
					children: <Widget>[
						TextField(
							controller: _usernameController,
							decoration: InputDecoration(
								hintText: 'Username'
							),
						),
						TextField(
							controller: _passwordController,
							obscureText: true,
							decoration: InputDecoration(
								hintText: 'Password'
							),
						),
						FlatButton(
							onPressed: () async {
								var username = _usernameController.text;
								var password = _passwordController.text;
								var token = await tryLogin(username, password);
								if(token != null) {
									storage.write(key: "urlToken", value: token);
									Navigator.push(
										context,
										MaterialPageRoute(
											builder: (context) => CreateScreen.fromBase64(token)
										)
									);
								} else {
									displayNotification(context, "An Error Occurred", "No matching account found!");
								}
							},
							child: Text("Login")
						),
						FlatButton(
							onPressed: () async {
								var username = _usernameController.text;
								var password = _passwordController.text;

								var httpResultStatusCode = await trySignUp(username, password);
								if(httpResultStatusCode == 200)
									displayNotification(context, "Success!", "Account created successfully. Please login.");
								else if(httpResultStatusCode == 409)
									displayNotification(context, "Username exists!", "Sign up using different username or login.");
								else {
									displayNotification(context, "Error!", "Something has gone wrong!");
								}

							},
							child: Text("Sign Up")
						)
					],
				),
			)
		);
	}
}