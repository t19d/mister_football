import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class ConversorImagen {
  static Widget imageFromBase64String(String base64String, BuildContext context) {
    if (base64String.length != 0) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.memory(
              base64Decode(base64String),
              fit: BoxFit.fill,
              height: MediaQuery.of(context).size.width / 6,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ));
    } else {
      return Icon(
        Icons.person,
        color: Colors.black87,
        size: MediaQuery.of(context).size.width / 6,
      );
    }
  }

  static Uint8List dataFromBase64String(String base64String) {
    return base64Decode(base64String);
  }

  static String base64String(Uint8List data) {
    return base64Encode(data);
  }
}
