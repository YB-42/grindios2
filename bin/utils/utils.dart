class Utils {
  static String cleanBotAnswer(String answer) {
    if (answer.endsWith('.')) {
      return answer.substring(0, answer.length - 1);
    } else {
      return answer;
    }
  }
}
