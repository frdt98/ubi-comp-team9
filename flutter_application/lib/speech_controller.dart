import 'package:bus_stop_app/notification_controller.dart';
import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechController extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool available = false;
  String? _stationName;
  bool detected = false;
  bool listening = false;

  set station(String value) {
    _stationName = value;
    notifyListeners();
  }

  initSpeech() async {
    available = await _speech.initialize();

    notifyListeners();
  }

  listen() async {
    listening = true;

    notifyListeners();
    _speech.listen(
        localeId: "ko_KR",
        onResult: (val) {
          if (val.hasConfidenceRating && val.confidence > 0) {
            final text = val.recognizedWords;
            print(text.replaceAll(" ", ""));
            final name = _stationName!.replaceAll(" ", "");
            if (RegExp(r'.*이.*' + name + r'.*다음.*')
                .hasMatch(text.replaceAll(" ", ""))) {
              stop();
              detected = true;
              NotificationService().showNotification(
                1,
                "Go out",
                "You reached your destination!",
              );
              notifyListeners();
            }
          }
        });
  }

  stop() async {
    _speech.stop();
  }
}
