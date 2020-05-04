// To parse this JSON data, do
//
//     final shortenedUrlsOfUser = shortenedUrlsOfUserFromJson(jsonString);

import 'dart:convert';

ShortenedUrlsOfUser shortenedUrlsOfUserFromJson(String str) => ShortenedUrlsOfUser.fromJson(json.decode(str));

String shortenedUrlsOfUserToJson(ShortenedUrlsOfUser data) => json.encode(data.toJson());

class ShortenedUrlsOfUser {
	List<Content> content;
	int totalPages;
	int totalElements;
	bool last;
	Sort sort;
	int number;
	int numberOfElements;
	bool first;
	int size;
	bool empty;

	ShortenedUrlsOfUser({
		this.content,
		this.totalPages,
		this.totalElements,
		this.last,
		this.sort,
		this.number,
		this.numberOfElements,
		this.first,
		this.size,
		this.empty,
	});

	factory ShortenedUrlsOfUser.fromJson(Map<String, dynamic> json) => ShortenedUrlsOfUser(
		content: List<Content>.from(json["content"].map((x) => Content.fromJson(x))),
		totalPages: json["totalPages"],
		totalElements: json["totalElements"],
		last: json["last"],
		sort: Sort.fromJson(json["sort"]),
		number: json["number"],
		numberOfElements: json["numberOfElements"],
		first: json["first"],
		size: json["size"],
		empty: json["empty"],
	);

	Map<String, dynamic> toJson() => {
		"content": List<dynamic>.from(content.map((x) => x.toJson())),
		"totalPages": totalPages,
		"totalElements": totalElements,
		"last": last,
		"sort": sort.toJson(),
		"number": number,
		"numberOfElements": numberOfElements,
		"first": first,
		"size": size,
		"empty": empty,
	};
}

class Content {
	int id;
	int userId;
	String targetUrl;
	String shortUrl;
	DateTime expirationTime;
	bool isExpired;
	int hitCount;
	String shortUrlWithPrefix;

	Content({
		this.id,
		this.userId,
		this.targetUrl,
		this.shortUrl,
		this.expirationTime,
		this.isExpired,
		this.hitCount,
		this.shortUrlWithPrefix,
	});

	factory Content.fromJson(Map<String, dynamic> json) => Content(
		id: json["id"],
		userId: json["userId"],
		targetUrl: json["targetURL"],
		shortUrl: json["shortURL"],
		expirationTime: DateTime.parse(json["expirationTime"]),
		isExpired: json["isExpired"],
		hitCount: json["hitCount"],
		shortUrlWithPrefix: json["shortURLWithPrefix"],
	);

	Map<String, dynamic> toJson() => {
		"id": id,
		"userId": userId,
		"targetURL": targetUrl,
		"shortURL": shortUrl,
		"expirationTime": "${expirationTime.year.toString().padLeft(4, '0')}-${expirationTime.month.toString().padLeft(2, '0')}-${expirationTime.day.toString().padLeft(2, '0')}",
		"isExpired": isExpired,
		"hitCount": hitCount,
		"shortURLWithPrefix": shortUrlWithPrefix,
	};
}

class Sort {
	bool sorted;
	bool unsorted;
	bool empty;

	Sort({
		this.sorted,
		this.unsorted,
		this.empty,
	});

	factory Sort.fromJson(Map<String, dynamic> json) => Sort(
		sorted: json["sorted"],
		unsorted: json["unsorted"],
		empty: json["empty"],
	);

	Map<String, dynamic> toJson() => {
		"sorted": sorted,
		"unsorted": unsorted,
		"empty": empty,
	};
}
