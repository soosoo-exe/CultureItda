// lib/screens/address_search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AddressSearchScreen extends StatelessWidget {
  const AddressSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('주소 검색')),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
          // TODO: 실제 주소 검색 API URL로 변경하세요.
          // 예시: Postcode API 또는 도로명주소 API의 주소 검색 페이지 URL
          url: Uri.parse('https://postcode.map.daum.net/external/guide.html'),
        ),
        onWebViewCreated: (controller) {
          controller.addJavaScriptHandler(
              handlerName: 'onAddressSelected',
              callback: (args) {
                if (args.isNotEmpty) {
                  // 주소를 선택하면 이전 화면으로 돌아가면서 주소 값을 전달
                  Navigator.pop(context, args[0]);
                }
              });
        },
        // TODO: JavaScript 코드를 주입하여 주소를 선택했을 때 `onAddressSelected` 핸들러를 호출하도록 설정해야 합니다.
      ),
    );
  }
}