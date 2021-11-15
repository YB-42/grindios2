class Dprint {
  static void error(Object object) {
    print('\x1B[31m$object\x1B[0m');
  }

  static void warning(Object object) {
    print('\x1B[33m$object\x1B[0m');
  }

  static void info(Object object) {
    print('\x1B[32m$object\x1B[32m');
  }
}
