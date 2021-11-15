import 'package:puppeteer/puppeteer.dart';

import '../utils/d_print.dart';


class DiscordBloc {
  final Page page;

  DiscordBloc({required this.page});

  Future<void> init(Page page) async {
    await page.waitForSelector(
      '.scroller-1Bvpku.none-2Eo-qx.scrollerBase-289Jih',
      timeout: const Duration(minutes: 15),
    );
    await Future.delayed(const Duration(seconds: 15));
    Dprint.info('discord channel should be set');
  }

  Future<String> getLatestMessage() async {
    final List<dynamic> data = await page.evaluate('''() => {
        const list = Array.from(document.querySelectorAll('.scrollerInner-2YIMLh'));
        return list.map((li)=>li.textContent);
    }''');

    return data.last as String;
  }

  Future<void> sendMessage(String message, Page page) async {
    // todo make duration random
    try {
      await page.type(
        'div > span > span > span',
        message,
        delay: const Duration(milliseconds: 25),
      );
      await page.keyboard.press(Key.enter);
    } catch (e) {
      throw Exception('Error in sending discord message');
    }
  }
}
