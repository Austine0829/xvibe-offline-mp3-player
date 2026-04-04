import 'package:uuid/uuid.dart';

class UuidGenerator {
  static final Uuid _uuid = Uuid();

  static String generate() => _uuid.v4();
}