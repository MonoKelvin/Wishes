import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../app/theme.dart';

class OAuthWebViewScreen extends StatefulWidget {
  final String authorizationUrl;

  const OAuthWebViewScreen({
    super.key,
    required this.authorizationUrl,
  });

  @override
  State<OAuthWebViewScreen> createState() => _OAuthWebViewScreenState();
}

class _OAuthWebViewScreenState extends State<OAuthWebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  void _initWebView() {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onNavigationRequest: (request) {
            final url = request.url;

            // 检查是否是回调URL
            if (url.startsWith('https://open.pinduoduo.com/oauth/callback') ||
                url.startsWith('wishes://oauth/callback')) {
              _handleCallback(url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
              _errorMessage = '页面加载失败: ${error.description}';
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.authorizationUrl));
  }

  void _handleCallback(String url) {
    try {
      final uri = Uri.parse(url);
      final code = uri.queryParameters['code'];

      if (code != null && code.isNotEmpty) {
        // 授权成功，返回code
        Navigator.pop(context, code);
      } else {
        // 授权失败
        final error = uri.queryParameters['error'] ?? '未知错误';
        setState(() {
          _errorMessage = '授权失败: $error';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = '解析回调URL失败: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拼多多授权'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          if (_errorMessage != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: AppTheme.errorColor,
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      _errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppTheme.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _errorMessage = null;
                        });
                        _controller.loadRequest(Uri.parse(widget.authorizationUrl));
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            )
          else
            WebViewWidget(controller: _controller),

          // 加载指示器
          if (_isLoading && _errorMessage == null)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
