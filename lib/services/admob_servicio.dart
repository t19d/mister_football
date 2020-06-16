import 'dart:io';

class ServicioAdMob {
  String getAdMobAppId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8505501288716754~2552531320';
    }
    /*else if (Platform.isIOS) {
      return 'ca-app-pub-2334510780816542~7385148076';
    }*/
    return null;
  }

  String getBannerAdId() {
    if (Platform.isAndroid) {
      return 'ca-app-pub-8505501288716754/8823369121';
    }
    /*else if (Platform.isIOS) {
      return 'ca-app-pub-2334510780816542/2993163849';
    }*/
    return null;
  }
}
