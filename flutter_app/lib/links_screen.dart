import 'package:app/create_screen.dart';
import 'package:app/login_screen.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'constants.dart';

import 'shortened_urls_of_user.dart';

class LinksScreen extends StatefulWidget {
	LinksScreen(this.token);

	final String token;

	@override
	LinksScreenState createState() => new LinksScreenState(token);
}

class LinksScreenState extends State<LinksScreen> {
	LinksScreenState(this.token);

	final String token;

	Future<List<Content>> getShortenURLs(String token) async {
		try {
			var tempToken = token.substring(17, token.length - 2);

			var httpResponse =
			await http.get(
				"$SERVER_ADDRESS_MANAGER/$SHORTEN_URL_PATH", headers: {
				"Authorization": tempToken,
				"Accept": "application/json",
				"content-type": "application/json"
			});
			if (httpResponse.statusCode == 200) //login success
				{
				List<Content> shortenedURLs =
					shortenedUrlsOfUserFromJson(httpResponse.body).content;

				return shortenedURLs;
			} else {
				return List<Content>();
			}
		} catch (e) {
			return List<Content>();
		}
	}

	List<Content> _futureShortenedURLList;
	bool loading;

	@override
	void initState() {
		super.initState();
		loading = true;
		getShortenURLs(token).then((futureShortenedURLList) {
			setState(() {
				_futureShortenedURLList = futureShortenedURLList;
				loading = false;
			});
		});
	}

	@override
	Widget build(BuildContext context) {
		return WillPopScope(
			onWillPop: () async {
				return Future.value(false);
			},
			child: Scaffold(
				appBar: AppBar(
					title: Text("URL Shortener (Tap to copy)"),
					automaticallyImplyLeading: false,
					actions: <Widget>[
						FlatButton(
							onPressed: () async {
								Navigator.push(
									context,
									MaterialPageRoute(
										builder: (context) =>
											CreateScreen.fromBase64(token)));
							},
							child: Text('Create Links'),
						),
						FlatButton(
							onPressed: () async {
								storage.delete(key: "urlToken");
								Navigator.push(context,
									MaterialPageRoute(
										builder: (context) => LoginScreen()));
							},
							child: Text('Logout'),
						),
					],
				),
				body: Padding(
					padding: const EdgeInsets.all(15.0),
					child: ListView.builder(
						itemCount: null == _futureShortenedURLList
							? 0
							: _futureShortenedURLList.length,
						itemBuilder: (context, index) {
							Content content = _futureShortenedURLList[index];
							return ListTile(
								title: Text(content.shortUrlWithPrefix),
								subtitle: Text(content.targetUrl),
								onTap: () => Clipboard.setData(new ClipboardData(text: content.shortUrlWithPrefix)),
							);
						},
					))));
	}
}
