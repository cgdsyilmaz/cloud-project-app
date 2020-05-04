import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const SERVER_ADDRESS_MANAGER = 'http://manager.rdrct.pw';
const SERVER_ADDRESS_AUTH = 'http://auth.rdrct.pw';
const AUTH_LOGIN_PATH = 'login';
const AUTH_SIGN_UP_PATH = 'signup';
const SHORTEN_URL_PATH = 'api/url';
const CUSTOM_SHORTEN_PATH = 'api/url/custom';
final storage = FlutterSecureStorage();
