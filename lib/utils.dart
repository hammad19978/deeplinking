import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

class AppUtils {
  ///Build a dynamic link firebase
  static Future<String> buildDynamicLink() async {
    String url = "https://routedeeplink.page.link";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: url,
      link: Uri.parse('$url/deeplink/Hey_Zalim_its_a_deep_linking_exp!'),
      androidParameters: AndroidParameters(
        packageName: "com.example.deeplinking",
        minimumVersion: 0,
      ),
      iosParameters: IosParameters(
        bundleId: "com.example.deeplinking",
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
          description: "Deep linking example MEOW",
          imageUrl:
              Uri.parse("https://flutter.dev/images/flutter-logo-sharing.png"),
          title: "DEEP LINKING"),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
}
