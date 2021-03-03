library bts_webview;

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BTSWebView extends StatefulWidget {
  const BTSWebView({
    Key key,
    @required this.src,
    this.height,
    this.width,
    this.webAllowFullScreen = true,
    this.isHtml = false,
    this.widgetsTextSelectable = false,
  }) : super(key: key);

  @override
  _BTSWebViewState createState() => _BTSWebViewState();

  final double height;

  final String src;

  final double width;

  final bool webAllowFullScreen;

  final bool isHtml;

  final bool widgetsTextSelectable;
}

class _BTSWebViewState extends State<BTSWebView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didUpdateWidget(BTSWebView oldWidget) {
    if (oldWidget.height != widget.height) {
      if (mounted) {
        setState(() {});
      }
    }
    if (oldWidget.width != widget.width) {
      if (mounted) {
        setState(() {});
      }
    }
    if (oldWidget.src != widget.src) {
      if (mounted) {
        setState(() {});
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return OptionalSizedChild(
      width: widget?.width,
      height: widget?.height,
      builder: (w, h) {
        final String src = widget.src;
        _setup(src, w, h);
        return AbsorbPointer(
          child: RepaintBoundary(
            child: HtmlElementView(
              key: widget?.key,
              viewType: 'iframe-$src',
            ),
          ),
        );
      },
    );
  }

  static final _iframeElementMap = Map<Key, html.IFrameElement>();

  void _setup(String src, double width, double height) {
    final src = widget.src;
    final key = widget.key ?? const ValueKey('');
    ui.platformViewRegistry.registerViewFactory('iframe-$src', (int viewId) {
      if (_iframeElementMap[key] == null) {
        _iframeElementMap[key] = html.IFrameElement();
      }
      final element = _iframeElementMap[key]
        ..style.border = '0'
        ..allowFullscreen = widget.webAllowFullScreen
        ..height = height?.toInt().toString()
        ..width = width?.toInt().toString();
      if (src != null) {
        if (widget.isHtml) {
          element.srcdoc = src;
        } else {
          element.src = src;
        }
      }
      return element;
    });
  }
}

class OptionalSizedChild extends StatelessWidget {
  final double width, height;
  final Widget Function(double, double) builder;

  const OptionalSizedChild({
    @required this.width,
    @required this.height,
    @required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (width != null && height != null) {
      return SizedBox(
        width: width,
        height: height,
        child: builder(width, height),
      );
    }
    return LayoutBuilder(
      builder: (context, dimens) {
        final w = width ?? dimens.maxWidth;
        final h = height ?? dimens.maxHeight;
        return SizedBox(
          width: w,
          height: h,
          child: builder(w, h),
        );
      },
    );
  }
}
