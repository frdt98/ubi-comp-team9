import 'package:flutter/widgets.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechController extends ChangeNotifier {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool available = false;
  String? _stationName;
  bool detected = false;

  set station(String value) {
    _stationName = value;
    notifyListeners();
  }

  initSpeech() async {
    available = await _speech.initialize();

    notifyListeners();
  }

  listen() async {
    _speech.listen(
        localeId: "ko_KR",
        onResult: (val) {
          if (val.hasConfidenceRating && val.confidence > 0) {
            final text = val.recognizedWords;
            if (text == "이번 정류장은 서울대입구역입니다" || text == "이번 정류장은 서울대입구역입니다") {
              stop();
              detected = true;
              notifyListeners();
            }
            ;
          }
        });
  }

  stop() async {
    _speech.stop();
  }
}
