import 'dart:io';

String parseFixture(String name) =>
    File("test/fixtures/$name").readAsStringSync();
