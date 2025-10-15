import 'package:get/get.dart';

class OcrController extends GetxController {
  var scannedText = "".obs;

  void scanText() async {
    // TODO: Implement ML Kit OCR logic
    scannedText.value = "Sample medicine info scanned";
  }
}
