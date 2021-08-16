import 'package:flutter_test/flutter_test.dart';
import 'package:social_share_web/social_share_web.dart';

void main() {
  ShareFunction fun = ShareFunction();
  String testUrl =
      "https://www.thehindu.com/news/national/google-doodle-honours-poet-subhadra-kumari-chauhan-on-her-117th-birth-anniversary/article35933552.ece";
  test('testing facebook', () {
    String facebook = fun.getFacebookUrl(testUrl);
    expect(facebook,
        "https://www.facebook.com/sharer/sharer.php?u=https://www.thehindu.com/news/national/google-doodle-honours-poet-subhadra-kumari-chauhan-on-her-117th-birth-anniversary/article35933552.ece&amp;src=sdkpreparse");
  });
  test('testing twitter', () {
    String twitter = fun.getTwitterUrl(testUrl);
    expect(twitter,
        "https://twitter.com/intent/tweet?text=https://www.thehindu.com/news/national/google-doodle-honours-poet-subhadra-kumari-chauhan-on-her-117th-birth-anniversary/article35933552.ece");
  });
  test('testing WhatsApp', () {
    String whatsApp = fun.getWhatsAppUrl(testUrl);
    expect(whatsApp,
        "https://api.whatsapp.com/send?text=https://www.thehindu.com/news/national/google-doodle-honours-poet-subhadra-kumari-chauhan-on-her-117th-birth-anniversary/article35933552.ece");
  });
}
