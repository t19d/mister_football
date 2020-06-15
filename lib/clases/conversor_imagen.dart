import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:mister_football/main.dart';

class ConversorImagen {
  static Widget imageFromBase64String(String base64String, BuildContext context) {
    if (base64String.length != 0) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.memory(
              base64Decode(base64String),
              fit: BoxFit.scaleDown,
              height: MediaQuery.of(context).size.width / 6,
              width: MediaQuery.of(context).size.width / 6,
            ),
          ));
    } else {
      return Icon(
        Icons.person,
        color: MisterFootball.primario,
        size: MediaQuery.of(context).size.width / 6,
      );
    }
  }

  static Widget devolverEscudoImageFromBase64String(String base64String, BuildContext context) {
    if (base64String.length != 0) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.memory(
              base64Decode(base64String),
              height: MediaQuery
                  .of(context)
                  .size
                  .width / 6,
            ),
          ));
    } else {
      return Icon(
        Icons.security,
        color: MisterFootball.primario,
        size: MediaQuery
            .of(context)
            .size
            .width / 6,
      );
    }
  }

  static Widget devolverEscudoPartidosImageFromBase64String(String base64String, BuildContext context) {
    if (base64String.length != 0) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.memory(
              base64Decode(base64String),
              height: MediaQuery
                  .of(context)
                  .size
                  .width / 10,
            ),
          ));
    } else {
      return Icon(
        Icons.security,
        color: MisterFootball.primario,
        size: MediaQuery
            .of(context)
            .size
            .width / 10,
      );
    }
  }

  static Widget imageEntrenamientoFromBase64String(String base64String, BuildContext context) {
    if (base64String.length != 0) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.memory(
              base64Decode(base64String),
              fit: BoxFit.fill,
            ),
          ));
    } else {
      return Icon(
        Icons.fitness_center,
        color: MisterFootball.primario,
        size: MediaQuery.of(context).size.width / 6,
      );
    }
  }

  static Widget devolverEscudoNavegadorImageFromBase64String(String base64String, BuildContext context) {
    if (base64String.length != 0) {
      return Padding(
          padding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: Image.memory(
              base64Decode(base64String),
              height: MediaQuery
                  .of(context)
                  .size
                  .width / 6,
            ),
          ));
    } else {
      return Icon(
        Icons.security,
        color: Colors.white70,
        size: MediaQuery
            .of(context)
            .size
            .width / 6,
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
