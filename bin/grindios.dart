import 'dart:convert';
import 'dart:io';

import 'package:puppeteer/puppeteer.dart';

import 'bloc/chat_bloc.dart';
import 'bloc/discord_bloc.dart';
import 'models/discord_message.dart';
import 'utils/d_print.dart';

Future<void> main(List<String> arguments) async {
  print(
      'Hello please make sure that your discord account is already in the server');
  print('Please enter your discord server channel link: ');

  final String discordChannelLink = stdin.readLineSync(encoding: utf8) ?? '';

  if (!Uri.parse(discordChannelLink).isAbsolute) {
    Dprint.error('disocrd server channel link is invalid');
    return;
  }

  print(
      'Please enter the delay in seconds you want after each message grindios sends: ');
  final String delayString = stdin.readLineSync(encoding: utf8) ?? '';
  if (int.tryParse(delayString) == null) {
    Dprint.error('Could not read delay in seconds');
    return;
  }

  final int delay = int.tryParse(delayString)!;

  Dprint.info(
      'launching the chrome browser this may take some time for the first run');

  final Browser browser =
      await puppeteer.launch(headless: false, defaultViewport: null);

  final Page chatbotPage = await browser.newPage();
  final Page discordPage = await browser.newPage();

  await Future.any([
    chatbotPage.goto('https://www.chimbot.com', wait: Until.networkIdle),
    discordPage.goto(discordChannelLink, wait: Until.networkIdle),
  ]);

  final ChatBloc chatBloc = ChatBloc(page: chatbotPage);
  final DiscordBloc discordBloc = DiscordBloc(page: discordPage);
  await chatBloc.init();
  await discordBloc.init(discordPage);

  DiscordMessage? oldMessage;
  String? answer;
  late DiscordMessage latestMessage;

  while (true) {
    try {
      latestMessage =
          DiscordMessage.fromString(await discordBloc.getLatestMessage());
      //
      if (latestMessage.messageContent != oldMessage?.messageContent &&
          latestMessage.messageContent != answer &&
          latestMessage.messageContent.trim() != '') {
        answer = await chatBloc.sendToBot(latestMessage.messageContent);
        Dprint.info('${latestMessage.messageContent} => $answer\n');

        await discordBloc.sendMessage(answer, discordPage);
        oldMessage = latestMessage;
        await Future.delayed(Duration(seconds: delay));
      }
    } catch (e) {
      Dprint.error(e);
    }
  }
}
