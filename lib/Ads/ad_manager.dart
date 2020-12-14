import 'dart:io';

class AdManager {

  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3988464410390393~4446843449";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544~2594085930";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3988464410390393/5425910869";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3988464410390393/3374462596";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3988464410390393/9058034114";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3988464410390393/1869809236";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
