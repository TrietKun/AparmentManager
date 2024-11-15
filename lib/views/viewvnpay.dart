import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ViewVnPay extends StatefulWidget {
  const ViewVnPay({super.key});

  @override
  _ViewVnPayState createState() => _ViewVnPayState();
}

class _ViewVnPayState extends State<ViewVnPay> {

  @override
  void initState() {
    super.initState();
    // Chỉ khởi tạo khi đã có binding
    if (WebView.platform == SurfaceAndroidWebView()) {
      // Các cài đặt cần thiết nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('VNPAY')),
      body: WebView(
        initialUrl: 'https://sandbox.vnpayment.vn/paymentv2/vpcpay.html',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
        },
      ),
    );
  }
}
