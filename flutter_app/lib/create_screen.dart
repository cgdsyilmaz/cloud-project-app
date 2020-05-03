import 'dart:convert';
import 'package:app/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:intl/intl.dart';

class ShortenedURL
{
	final String longURL;
	final String shortURL;
	final DateTime expirationDate;

	ShortenedURL({this.shortURL, this.expirationDate, this.longURL});

	factory ShortenedURL.fromJson(Map<String, dynamic> json)
	{
		return ShortenedURL(
			shortURL: json['shortURLWithPrefix'],
			longURL: json['longURL'],
			expirationDate: json['expirationDate']
		);
	}
}

class CreateScreen extends StatefulWidget {
	CreateScreen(this.token, this.payload);
	final String token;
	final Map<String, dynamic> payload;
	factory CreateScreen.fromBase64(String token)
	{
		return CreateScreen(
			token,
			json.decode(
				ascii.decode(
					base64.decode(base64.normalize(token.split(".")[1]))
				)
			)
		);
	}
	@override
	CreateScreenState createState() => new CreateScreenState(token);
}
class CreateScreenState extends State<CreateScreen> {
	final TextEditingController _longURLController = TextEditingController();
	final TextEditingController _shortURLController = TextEditingController();

	Future<ShortenedURL> futureShortenedURL;
	DateTime expirationDate = DateTime.now().toLocal().add(Duration(days: 1));

	CreateScreenState(this.token);
	final String token;

	Future<Null> selectDate(BuildContext context) async {
		final DateTime picked = await showDatePicker(
			context: context,
			initialDate: DateTime.now().toLocal().add(Duration(days: 1)),
			firstDate: DateTime.now(),
			lastDate: DateTime(2101));

		if (picked != null)
		{
			setState(() {
				expirationDate = picked;
			});
		}

	}

	Future<ShortenedURL> tryShortenURL(String token, String longURL) async
	{
		var tempToken = token.substring(17, token.length - 2);
		_shortURLController.clear();
		var httpResponse = await http.post(
			"$SERVER_ADDRESS_MANAGER/$SHORTEN_URL_PATH",
			headers: {"Authorization": tempToken, "Accept": "application/json", "content-type": "application/json"},
			body:jsonEncode(
			{
				"longURL": longURL,
				"expirationDate": DateFormat('yyyy-MM-dd').format(expirationDate)
			}
			)
		);
		if(httpResponse.statusCode == 200) //login success
		{
			ShortenedURL shortenedURL = ShortenedURL.fromJson(json.decode(httpResponse.body));
			_shortURLController.text = shortenedURL.shortURL;
			return shortenedURL;
		}
		else
		{
			throw Exception('Failed to get that shortened url for you! Another try maybe?');
		}
	}

	Future<ShortenedURL> tryCustomShortenURL(String token, String longURL, String customURL) async
	{
		var tempToken = token.substring(17, token.length - 2);
		_shortURLController.clear();
		var httpResponse = await http.post(
			"$SERVER_ADDRESS_MANAGER/$CUSTOM_SHORTEN_PATH",
			headers: {"Authorization": tempToken, "Accept": "application/json", "content-type": "application/json"},
			body:jsonEncode(
			{
				"longURL": longURL,
				"customURL": customURL,
				"expirationDate": DateFormat('yyyy-MM-dd').format(expirationDate)
			}
			)
		);
		if(httpResponse.statusCode == 200) //login success
		{
			ShortenedURL shortenedURL = ShortenedURL.fromJson(json.decode(httpResponse.body));
			_shortURLController.text = shortenedURL.shortURL;
			return shortenedURL;
		}
		else
		{
			throw Exception('Failed to get that custom shortened url for you! Another one maybe?');
		}
	}

	bool _isCustomURLSelected = false;

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async{
				return Future.value(false);
			},
			child: Scaffold(
				appBar: AppBar(title: Text("Enter URL that needs to be shrtnd!"),
				actions: <Widget>[
					FlatButton(
						onPressed: () async{
							storage.delete(key: "urlToken");
							Navigator.push(
								context,
								MaterialPageRoute(
									builder: (context) => LoginScreen()
								)
							);
						},
						child: Text('Logout'),
					),
				],),
				body: Padding(
					padding: const EdgeInsets.all(15.0),
					child: Column(
						children: <Widget>[
							CheckboxListTile(
								title: Text("I want to set a custom URL!"),
								value: _isCustomURLSelected,
								controlAffinity: ListTileControlAffinity.leading,
								onChanged: (value){
									setState(() {
										_shortURLController.clear();
										_isCustomURLSelected = !_isCustomURLSelected;
									});
								},
							),
							TextField(
								enableSuggestions: false,
								autocorrect: false,
								controller: _longURLController,
								decoration: InputDecoration(
									hintText: 'Paste the link you want shrtnd!'
								),
							),
							FocusScope(
								canRequestFocus: _isCustomURLSelected ? true : false,
								node: FocusScopeNode(),
								child: TextField(
									enableSuggestions: false,
									autocorrect: false,
									readOnly: !_isCustomURLSelected,
									controller: _shortURLController,
									decoration: InputDecoration(
										hintText: _isCustomURLSelected ? 'Enter your <custom_url> for rdrct.pw/<custom_url>' : 'Your shrtnd URL will magically appear here!'
									),
								),
							),
							FlatButton(
								onPressed: () => selectDate(context),
								child: Text('Expiration Date for shortened URL: ' + "${expirationDate.toLocal()}".split(' ')[0]),
							),
							FlatButton(
								onPressed: () => _isCustomURLSelected ?
									tryCustomShortenURL(token, _longURLController.text, _shortURLController.text) :
									tryShortenURL(token, _longURLController.text),
								child: Text('Get My Shorten URL!'),
							)
						],
					)
				)
			)

		);
	}
}