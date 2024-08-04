class SeedTest {
  String name;
  StatusSeed status;

  SeedTest({this.name = "", this.status = StatusSeed.none});
}

enum StatusSeed { none, test, success, fail }
