import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_chat_types/flutter_chat_types.dart';

class Helper {
  static late bool connected = false;
  static Uint8List stringToBytes(String str) {
    final List<int> codeUnits = str.codeUnits;
    final Uint8List unit8List = Uint8List.fromList(codeUnits);

    return unit8List;
  }

  static String bytesToString(Uint8List bytes) {
    return String.fromCharCodes(bytes);
  }

  static TextMessage messageFromBytes(Uint8List bytes) {
    String str = bytesToString(bytes);
    Map<String, dynamic> json = jsonDecode(str);
    return TextMessage.fromJson(json);
  }
}
