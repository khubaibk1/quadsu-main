import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';
import '../constants/global_data.dart';
import '../functions/common_function.dart';
import '../services/custom_navigation_services.dart';
import '../constants/global_keys.dart';

// ---------------------------------------------------------------------------
// PayPal v2 Orders API — creates a PROPER orderID (e.g. 6XO123...)
// that Laravel can verify via /v2/checkout/orders/{orderID}.
// ---------------------------------------------------------------------------

const String _returnUrl = 'https://samplesite.com/return';
const String _cancelUrl = 'https://samplesite.com/cancel';

String get _baseUrl {
  final live = myAppSettings?.isPaymentLive == true;
  final configured = myAppSettings?.payPalBaseUrl;
  String base;
  if (configured != null && configured.isNotEmpty) {
    base = configured;
  } else {
    base = live
        ? 'https://api.paypal.com/'
        : 'https://api.sandbox.paypal.com/';
  }
  // Always ensure trailing slash to avoid "api.paypal.comv1" URL corruption
  return base.endsWith('/') ? base : '$base/';
}

/// Step 1 — Get an OAuth2 access token.
Future<String?> _getAccessToken() async {
  final clientId = myAppSettings?.paypalClientId ?? '';
  final secret = myAppSettings?.paypalClientSecret ?? '';
  final credentials = base64Encode(utf8.encode('$clientId:$secret'));

  try {
    final response = await http.post(
      Uri.parse('${_baseUrl}v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic $credentials',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['access_token'] as String?;
    }
    print('PayPal v2: Token error ${response.statusCode}: ${response.body}');
  } catch (e) {
    print('PayPal v2: Token exception: $e');
  }
  return null;
}

/// Step 2 — Create a v2 Order with CAPTURE intent.
/// Returns [orderId, approveUrl].
Future<Map<String, String>?> _createOrder(
    String accessToken, double amount) async {
  try {
    final response = await http.post(
      Uri.parse('${_baseUrl}v2/checkout/orders'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'intent': 'CAPTURE',
        'purchase_units': [
          {
            'amount': {
              'currency_code': 'USD',
              'value': formatToTwoDecimalPlaces(amount).toString(),
            }
          }
        ],
        'application_context': {
          'return_url': _returnUrl,
          'cancel_url': _cancelUrl,
          'user_action': 'PAY_NOW',
        }
      }),
    );

    if (response.statusCode == 201) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final orderId = body['id'] as String? ?? '';
      final links = body['links'] as List<dynamic>? ?? [];
      final approveLink = links.firstWhere(
        (l) => l['rel'] == 'approve',
        orElse: () => null,
      );
      final approveUrl = approveLink?['href'] as String? ?? '';

      if (orderId.isNotEmpty && approveUrl.isNotEmpty) {
        print('PayPal v2: Order created — ID: $orderId');
        return {'orderId': orderId, 'approveUrl': approveUrl};
      }
    }
    print('PayPal v2: Create order error ${response.statusCode}: ${response.body}');
  } catch (e) {
    print('PayPal v2: Create order exception: $e');
  }
  return null;
}

// ---------------------------------------------------------------------------
// Public entry point — mirrors the old usePayPal() signature.
// ---------------------------------------------------------------------------

/// Opens a PayPal v2 checkout WebView.
/// [onSuccess] is called with a map containing [orderId] (a real v2 Order ID).
Future<void> usePayPalV2({
  required String message,
  required double payAmount,
  required Function(String orderId) onSuccess,
  Function(String error)? onError,
  Function()? onCancel,
}) async {
  final context = MyGlobalKeys.navigatorKey.currentContext!;

  // Show a loading indicator while we set up the order.
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  final accessToken = await _getAccessToken();
  Navigator.of(context, rootNavigator: true).pop(); // dismiss loader

  if (accessToken == null) {
    onError?.call('Failed to authenticate with PayPal. Check credentials.');
    return;
  }

  final order = await _createOrder(accessToken, payAmount);
  if (order == null) {
    onError?.call('Failed to create PayPal order. Please try again.');
    return;
  }

  final orderId = order['orderId']!;
  final approveUrl = order['approveUrl']!;

  CustomNavigation.push(
    context: context,
    screen: _PaypalV2WebView(
      approveUrl: approveUrl,
      orderId: orderId,
      onSuccess: onSuccess,
      onError: onError,
      onCancel: onCancel,
    ),
  );
}

// ---------------------------------------------------------------------------
// Internal WebView widget
// ---------------------------------------------------------------------------
class _PaypalV2WebView extends StatefulWidget {
  final String approveUrl;
  final String orderId;
  final Function(String orderId) onSuccess;
  final Function(String error)? onError;
  final Function()? onCancel;

  const _PaypalV2WebView({
    required this.approveUrl,
    required this.orderId,
    required this.onSuccess,
    this.onError,
    this.onCancel,
  });

  @override
  State<_PaypalV2WebView> createState() => _PaypalV2WebViewState();
}

class _PaypalV2WebViewState extends State<_PaypalV2WebView> {
  late final WebViewController _controller;
  bool _pageLoading = true;
  int _backPressCount = 0;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final controller = WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => _pageLoading = true),
          onPageFinished: (_) => setState(() => _pageLoading = false),
          onNavigationRequest: (request) {
            final url = request.url;
            print('PayPal v2 WebView nav: $url');

            // User approved → return URL contains the order token
            if (url.startsWith(_returnUrl)) {
              final uri = Uri.parse(url);
              // PayPal puts the order ID in the 'token' query param
              final token = uri.queryParameters['token'] ?? widget.orderId;
              print('PayPal v2: Approved — orderId: $token');
              Navigator.of(context).pop();
              widget.onSuccess(token);
              return NavigationDecision.prevent;
            }

            // User cancelled
            if (url.startsWith(_cancelUrl)) {
              Navigator.of(context).pop();
              widget.onCancel?.call();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.approveUrl));

    if (controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(false);
      (controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _backPressCount++;
        if (_backPressCount < 3) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                'Press back ${3 - _backPressCount} more time(s) to cancel'),
          ));
          return false;
        }
        widget.onCancel?.call();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF272727),
          title: const Text('PayPal Checkout',
              style: TextStyle(color: Colors.white, fontSize: 15)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.of(context).pop();
              widget.onCancel?.call();
            },
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_pageLoading)
              const Center(child: CircularProgressIndicator()),
          ],
        ),
      ),
    );
  }
}
