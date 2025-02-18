import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class MultiavatarGenerator {
  late JavascriptRuntime jsRuntime;

  MultiavatarGenerator() {
    // Initialize JavaScript runtime
    jsRuntime = getJavascriptRuntime();
  }

  Future<void> loadJs() async {
    try {
      String jsCode = await rootBundle.loadString('assets/js/multiavatar.js');
      await jsRuntime.evaluateAsync(jsCode);
    } catch (e) {
      debugPrint("Error loading JavaScript: $e");
    }
  }


  Future<String> generateAvatar(String seed) async {
    // Ensure JavaScript is loaded before calling the function
    await loadJs();

    // Execute the Multiavatar function
    String script = "multiavatar('$seed');";
    JsEvalResult result = await jsRuntime.evaluateAsync(script);

    return result.stringResult;
  }
}
