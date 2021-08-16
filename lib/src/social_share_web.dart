library social_share_web;

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

enum SocialMediaType {
  Facebook,
  Twitter,
  WhatsApp,
  Copy,
}

class SocialShareWeb extends StatefulWidget {
  final String url;
  final SocialMediaType socialMediaType;
  final String buttonTitles;
  final Widget icon;
  final Color? buttonColor;
  final OutlinedBorder? shape;
  final double? elevation;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;
  SocialShareWeb(
    this.url,
    this.socialMediaType,
    this.buttonTitles,
    this.icon, {
    this.buttonColor,
    this.shape,
    this.elevation,
    this.textStyle,
    this.padding,
  });

  @override
  _SocialShareWebState createState() => _SocialShareWebState();
}

class _SocialShareWebState extends State<SocialShareWeb> {
  final ShareFunction fun = ShareFunction();
  String finalSocialMedaUrl = '';
  @override
  void initState() {
    switch (widget.socialMediaType) {
      case SocialMediaType.Facebook:
        {
          finalSocialMedaUrl = fun.getFacebookUrl(widget.url);
          log('Facebook');
        }
        break;

      case SocialMediaType.Twitter:
        {
          finalSocialMedaUrl = fun.getTwitterUrl(widget.url);
          log('Twitter');
        }
        break;
      case SocialMediaType.WhatsApp:
        {
          finalSocialMedaUrl = fun.getWhatsAppUrl(widget.url);
          log('WhatsApp');
        }
        break;
      case SocialMediaType.Copy:
        {
          finalSocialMedaUrl = widget.url;
          log('Copy to clipbord');
        }
        break;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        fun.getSocialButtone(
          widget.buttonTitles,
          widget.buttonColor ?? Colors.white,
          widget.shape ?? StadiumBorder(),
          widget.elevation ?? 0.0,
          widget.textStyle ?? TextStyle(color: Colors.black, fontSize: 16),
          widget.padding ??
              const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          widget.icon,
          () async {
            widget.socialMediaType == SocialMediaType.Copy
                ? Clipboard.setData(ClipboardData(text: finalSocialMedaUrl))
                    .then(
                    (_) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("copied to clipboard")));
                    },
                  )
                : fun.launchURL(finalSocialMedaUrl);
          },
        ),
      ],
    );
  }
}

class ShareFunction implements Share {
  @override
  String getFacebookUrl(String url) {
    String currentUrl =
        "https://www.facebook.com/sharer/sharer.php?u=**url&amp;src=sdkpreparse"
            .replaceAll('**url', url);
    String facebookUrl = Uri.parse(currentUrl).toString();
    return facebookUrl;
  }

  @override
  void launchURL(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  @override
  String getWhatsAppUrl(String url) {
    String currentUrl =
        "https://api.whatsapp.com/send?text=**url".replaceAll('**url', url);
    String whatsAppUrl = Uri.parse(currentUrl).toString();
    return whatsAppUrl;
  }

  @override
  String getTwitterUrl(String url) {
    String currentUrl =
        "https://twitter.com/intent/tweet?text=**url".replaceAll('**url', url);
    String twitterUrl = Uri.parse(currentUrl).toString();
    return twitterUrl;
  }

  @override
  Widget getSocialButtone(
    String title,
    Color buttonColor,
    OutlinedBorder shape,
    double elevation,
    TextStyle textStyle,
    EdgeInsetsGeometry padding,
    Widget icon,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: padding,
        shape: shape,
        textStyle: textStyle,
        primary: buttonColor,
        elevation: elevation,
      ),
      onPressed: onPressed,
      label: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      icon: icon,
    );
  }
}

abstract class Share {
  String getFacebookUrl(String url);
  String getWhatsAppUrl(String url);
  String getTwitterUrl(String url);
  void launchURL(String url);
  Widget getSocialButtone(
      String title,
      Color buttonColor,
      OutlinedBorder shape,
      double elevation,
      TextStyle textStyle,
      EdgeInsetsGeometry padding,
      Widget icon,
      VoidCallback onPressed);
}
