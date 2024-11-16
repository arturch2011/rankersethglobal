import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankersethglobal/providers/blockchain_provider.dart';

import 'package:web3auth_flutter/web3auth_flutter.dart';
import 'package:web3auth_flutter/enums.dart' as provid;
import 'package:web3auth_flutter/input.dart';
import 'package:web3auth_flutter/output.dart';

import 'dart:io';
import 'dart:collection';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as json;

class PhotoDate {
  final int index;
  final int date;

  PhotoDate(this.index, this.date);

  Map<String, dynamic> toJson() => {'index': index, 'date': date};
}

class UserProvider extends ChangeNotifier {
  Map<String, dynamic>? userInfos;
  bool isLoading = true;
  final List<PhotoDate> _photoList = [];

  List<PhotoDate> get photoList => _photoList;

  UserProvider() {
    initPlatformState();
  }

  void addItem(PhotoDate item) {
    _photoList.add(item);
    notifyListeners();
  }

  void removeItem(int num) {
    _photoList.removeWhere((element) => element.index == num);
    notifyListeners();
  }

  void firstLogin() {
    print("nao esta logado");
    notifyListeners();
  }

  void logout() {
    Web3AuthFlutter.logout();
    userInfos = null;
    notifyListeners();
  }

  Future<void> loadPhotoList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('photoList');

    if (data != null) {
      _photoList.clear();
      _photoList.addAll(
        (json.jsonDecode(data) as List<dynamic>).map(
          (item) => PhotoDate(item['index'], item['date'] as int),
        ),
      );
    }
    notifyListeners();
  }

  Future<void> savePhotoList() async {
    final prefs = await SharedPreferences.getInstance();
    final data =
        json.jsonEncode(_photoList.map((item) => item.toJson()).toList());
    prefs.setString('photoList', data);
  }

  Future<void> initPlatformState() async {
    final themeMap = HashMap<String, String>();
    themeMap['primary'] = "#000000";

    Uri redirectUrl;
    if (Platform.isAndroid) {
      redirectUrl = Uri.parse('rankers://com.example.rankers/auth');
      // w3a://com.example.w3aflutter/auth
    } else if (Platform.isIOS) {
      redirectUrl = Uri.parse('{bundleId}://openlogin');
      // com.example.w3aflutter://openlogin
    } else {
      throw UnKnownException('Unknown platform');
    }

    await loadPhotoList();

    await Web3AuthFlutter.init(Web3AuthOptions(
        clientId:
            "BBUuPUNEV75vGBVCu56qB3-4jjZNYEW9PNHl4kSJOt6sr8_dgC6G5MUpgSDen8EijeBxQvfJlvPd56p-VDokMl8",
        network: provid.Network.testnet,
        sessionTime: 604800,
        redirectUrl: redirectUrl,
        whiteLabel: WhiteLabelData(
            mode: provid.ThemeModes.dark,
            appName: "Web3Auth Flutter App",
            theme: themeMap)));

    try {
      await Web3AuthFlutter.initialize();
      final String privKey = await Web3AuthFlutter.getPrivKey();
      final String ed255199PrivKey = await Web3AuthFlutter.getEd25519PrivKey();
      final TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
      userInfos = {
        'privKey': privKey,
        'ed25519PrivKey': ed255199PrivKey,
        'userInfo': userInfo.toJson(),
      };

      // getPrivKey(privKey);
      // User is logged in, execute desired function
    } on Exception {
      // Handle exception, likely indicating no active session
      firstLogin();
      // Execute function for unlogged users
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> loginGoogle() async {
    await Web3AuthFlutter.login(
        LoginParams(loginProvider: provid.Provider.google));
    await Web3AuthFlutter.initialize();
    final String privKey = await Web3AuthFlutter.getPrivKey();
    final String ed255199PrivKey = await Web3AuthFlutter.getEd25519PrivKey();
    final TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
    userInfos = {
      'privKey': privKey,
      'ed25519PrivKey': ed255199PrivKey,
      'userInfo': userInfo.toJson(),
    };
    // getPrivKey(privKey);

    notifyListeners();
  }

  Future<void> loginFacebook() async {
    await Web3AuthFlutter.login(
        LoginParams(loginProvider: provid.Provider.facebook));
    await Web3AuthFlutter.initialize();
    final String privKey = await Web3AuthFlutter.getPrivKey();
    final String ed255199PrivKey = await Web3AuthFlutter.getEd25519PrivKey();
    final TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
    userInfos = {
      'privKey': privKey,
      'ed25519PrivKey': ed255199PrivKey,
      'userInfo': userInfo.toJson(),
    };
    // getPrivKey(privKey);

    notifyListeners();
  }

  Future<void> loginTwitter() async {
    await Web3AuthFlutter.login(
        LoginParams(loginProvider: provid.Provider.twitter));
    await Web3AuthFlutter.initialize();
    final String privKey = await Web3AuthFlutter.getPrivKey();
    final String ed255199PrivKey = await Web3AuthFlutter.getEd25519PrivKey();
    final TorusUserInfo userInfo = await Web3AuthFlutter.getUserInfo();
    userInfos = {
      'privKey': privKey,
      'ed25519PrivKey': ed255199PrivKey,
      'userInfo': userInfo.toJson(),
    };
    // getPrivKey(privKey);

    notifyListeners();
  }

  // void addUserInfo(Map<String, dynamic> product) {
  //   userInfos.add(product);
  //   notifyListeners();
  // }

  // void removeUserInfo(Map<String, dynamic> product) {
  //   userInfos.remove(product);
  //   notifyListeners();
  // }
}

//  Provider.of<UserProvider>(context, listen: false).addUserInfo(
//       {
//         'privKey': privKey,
//         'ed25519PrivKey': ed255199PrivKey,
//         'userInfo': userInfo.toJson(),
//       },
//     );