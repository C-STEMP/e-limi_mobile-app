import 'package:elimiafrica/widgets/app_bar_two.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreenIframe extends StatelessWidget {
  static const routeName = '/webview-iframe';

  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  WebViewScreenIframe({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedUrl = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: CustomAppBarTwo(),
      body: WebView(
        initialUrl: Uri.dataFromString(
                '<html><body><iframe style="height: 100%;width:100%" src="$selectedUrl" allowfullscreen></iframe></body></html>',
                mimeType: 'text/html')
            .toString(),
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
      ),
    );
  }
}
