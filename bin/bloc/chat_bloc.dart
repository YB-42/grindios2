import 'package:puppeteer/puppeteer.dart';

class ChatBloc {
  final Page page;

  ChatBloc({required this.page});

  Future<void> init() async {
    await page.$eval('[class="understood"]', 'form => form.click()');
    await Future.delayed(const Duration(seconds: 5));
  }

  Future<String> sendToBot(String input) async {
    try {
      await page.type(
        '[name="stimulus"]',
        input,
        delay: const Duration(milliseconds: 0),
      );
      await page.keyboard.press(Key.enter);
      String output = input;
      while (output == input || output.isEmpty) {
        await Future.delayed(const Duration(seconds: 7));
        output = await page.evaluate('''() => {
          const answer = (document.querySelector('#line1'));
          return answer.textContent;
      }''');
      }
      return output;
    } catch (e) {
      throw Exception('Error in reading bot answer ');
    }
  }
}
