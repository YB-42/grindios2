import 'dart:convert';
import 'dart:io';

import 'package:puppeteer/puppeteer.dart';

class Cookies {
  final file = File('./cookies.txt');

  Future<List<CookieParam>> getCookies() async {
    if (await file.exists()) {
      final String cookiesString = file.readAsStringSync().toString();
      return (jsonDecode(cookiesString) as List)
          .map((e) => CookieParam.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Error();
    }
  }

  void saveCookies(Page page) async {
    var cookies = await page.cookies();
    file.writeAsStringSync(jsonEncode(cookies), flush: true);
  }
}
