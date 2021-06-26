import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openLink({@required String url}) => _launchUrl(url);

  static Future _launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  static void openEmail({String toEmail, String subject, String body}) async {
    final url =
        'mailto:$toEmail?subject=${Uri.encodeFull(subject)}&body=${Uri.encodeFull(body)}';
    await _launchUrl(url);
  }
}
