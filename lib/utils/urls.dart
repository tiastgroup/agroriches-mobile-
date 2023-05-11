import 'package:url_launcher/url_launcher.dart';

Future<void> launchTelegram(String telegramUsername) async {
  final Uri telegramUrl = Uri.parse("https://t.me/$telegramUsername");
  if (await canLaunchUrl(telegramUrl)) {
    await launchUrl(telegramUrl,
        mode: LaunchMode.externalNonBrowserApplication);
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri phoneNumberUri = Uri(
    scheme: 'tel',
    path: phoneNumber,
  );
  if (await canLaunchUrl(phoneNumberUri)) {
    await launchUrl(phoneNumberUri);
  }
}

Future<void> openUrl(String url) async {
  final Uri _url = Uri.parse(url);

  if (await canLaunchUrl(_url)) {
    await launchUrl(_url, mode: LaunchMode.externalApplication);
  }
}
