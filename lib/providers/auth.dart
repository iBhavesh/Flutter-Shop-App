import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token, _userId, _refreshToken;
  DateTime _expiryDate;
  Timer _refreshTimer;
  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) return _token;
    return null;
  }

  String get userId {
    return _userId;
  }

  Future<void> _autheticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyBsSG9gX2gKNpmBwRcGvZRG-_EV3k0D49U';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        }),
      );
      final extractedResponse = json.decode(response.body);
      if (extractedResponse['error'] != null) {
        if ((extractedResponse['error']['message'] as String)
            .contains('EMAIL_EXISTS')) {
          throw HttpException('This email address is already in use');
        } else if ((extractedResponse['error']['message'] as String)
            .contains('TOO_MANY_ATTEMPTS_TRY_LATER')) {
          throw HttpException('Too many attempts! Try again later.');
        } else if ((extractedResponse['error']['message'] as String)
            .contains('EMAIL_NOT_FOUND')) {
          throw HttpException('Inavlid email/password');
        } else if ((extractedResponse['error']['message'] as String)
            .contains('USER_DISABLED')) {
          throw HttpException(
              'Your account has been disabled by the administartor');
        } else {
          debugPrint(extractedResponse);
          throw HttpException(extractedResponse['error']['message']);
        }
      }
      _token = extractedResponse['idToken'];
      _userId = extractedResponse['localId'];
      _refreshToken = extractedResponse['refreshToken'];
      debugPrint('$_refreshToken');
      _expiryDate = DateTime.now()
          .add(Duration(seconds: int.tryParse(extractedResponse['expiresIn'])));
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setString(
          'userData',
          json.encode({
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
            'token': _token,
            'email': email,
            'password': password,
            'refreshToken': _refreshToken,
          }));
    } on SocketException catch (error) {
      debugPrint(error.toString());
      throw HttpException('No Internet! Please check your network connection.');
    } on HttpException catch (error) {
      throw error;
    } catch (error) {
      debugPrint('$error');
      throw HttpException('Error Occured!');
    }
  }

  Future<void> signup(String email, String password) async {
    return _autheticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return _autheticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = null;
    if (_refreshTimer != null) {
      _refreshTimer.cancel();
      _refreshTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.decode(prefs.getString('userData'));
    _expiryDate = DateTime.tryParse(userData['expiryDate']);

    if (_expiryDate.isBefore(DateTime.now())) {
      return login(userData['email'], userData['password']);
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _refreshToken = userData['refreshToken'];
    notifyListeners();
  }
}
