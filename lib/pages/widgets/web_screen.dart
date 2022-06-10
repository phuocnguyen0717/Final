import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebScreen extends StatelessWidget {
  final String url;
  const WebScreen({Key key, @required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          initialUrlRequest:
          URLRequest(url: Uri.parse(url)),
          onLoadStart: (_, __) => Container(),
          onLoadStop: (_, __) => Container(),
        ),
      ),
    );
  }
}
