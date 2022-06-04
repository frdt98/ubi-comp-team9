import 'dart:io';
import 'package:bus_stop_app/location_controller.dart';
import 'package:bus_stop_app/speech_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewController? webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
      ),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  double progress = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SpeechController, LocationController>(
        builder: (context, speechController, locationController, child) {
      if (speechController.detected) {
        locationController.locationSubscription.cancel();
      }
      return Scaffold(
        backgroundColor: const Color.fromRGBO(85, 182, 215, 1),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  speechController.detected
                      ? const Center(
                          child: Text(
                          "Destination Reached!",
                          style: TextStyle(fontSize: 32.0, color: Colors.white),
                        ))
                      : ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 500),
                          child: Column(
                            children: [
                              Expanded(
                                child: Material(
                                  borderRadius: BorderRadius.circular(16.0),
                                  elevation: 5,
                                  child: Container(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Stack(
                                      children: [
                                        InAppWebView(
                                          key: webViewKey,
                                          initialUrlRequest: URLRequest(
                                              url: Uri.parse(
                                                  'https://m.map.naver.com/bus/lane.naver?busID=1103#/map')),
                                          initialOptions: options,
                                          onWebViewCreated: (controller) {
                                            webViewController = controller;
                                          },
                                          androidOnPermissionRequest:
                                              (controller, origin,
                                                  resources) async {
                                            return PermissionRequestResponse(
                                                resources: resources,
                                                action:
                                                    PermissionRequestResponseAction
                                                        .GRANT);
                                          },
                                          shouldOverrideUrlLoading: (controller,
                                              navigationAction) async {
                                            var uri =
                                                navigationAction.request.url!;

                                            if (![
                                              "http",
                                              "https",
                                              "file",
                                              "chrome",
                                              "data",
                                              "javascript",
                                              "about"
                                            ].contains(uri.scheme)) {
                                              if (await canLaunch(
                                                  'https://m.map.naver.com/bus/lane.naver?busID=1103#/map')) {
                                                // Launch the App
                                                await launch(
                                                  'https://m.map.naver.com/bus/lane.naver?busID=1103#/map',
                                                );
                                                // and cancel the request
                                                return NavigationActionPolicy
                                                    .CANCEL;
                                              }
                                            }

                                            return NavigationActionPolicy.ALLOW;
                                          },
                                        ),
                                        progress < 1.0
                                            ? LinearProgressIndicator(
                                                value: progress)
                                            : Container(),
                                        speechController.listening
                                            ? const Center(
                                                child: FaIcon(
                                                  FontAwesomeIcons.earListen,
                                                  color: Colors.black,
                                                  size: 200,
                                                ),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              (speechController.listening &&
                                      !speechController.detected)
                                  ? const Text(
                                      "Now listening",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 32.0),
                                    )
                                  : Container(
                                      height: 32.0,
                                    ),
                            ],
                          ),
                        ),
                ]),
          ),
        ),
      );
    });
  }
}
