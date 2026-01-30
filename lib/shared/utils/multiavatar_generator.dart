import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_js/flutter_js.dart';

class MultiavatarGenerator {
  JavascriptRuntime? jsRuntime;
  bool _isInitialized = false;
  bool _initializationFailed = false;

  MultiavatarGenerator() {
    // Initialize JavaScript runtime with error handling
    try {
      jsRuntime = getJavascriptRuntime();
      _isInitialized = true;
    } catch (e) {
      debugPrint("Error initializing JavaScript runtime: $e");
      _initializationFailed = true;
    }
  }

  Future<void> loadJs() async {
    if (_initializationFailed || jsRuntime == null) {
      debugPrint("JavaScript runtime not available, skipping JS load");
      return;
    }
    
    try {
      String jsCode = await rootBundle.loadString('assets/js/multiavatar.js');
      await jsRuntime!.evaluateAsync(jsCode);
    } catch (e) {
      debugPrint("Error loading JavaScript: $e");
      _initializationFailed = true;
    }
  }


  Future<String> generateAvatar(String seed) async {
    if (_initializationFailed || jsRuntime == null) {
      debugPrint("JavaScript runtime not available, returning fallback avatar");
      // Return a simple SVG fallback
      return '<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="#${seed.hashCode.toRadixString(16).substring(0, 6)}"/></svg>';
    }
    
    try {
      // Ensure JavaScript is loaded before calling the function
      await loadJs();

      // Execute the Multiavatar function
      String script = "multiavatar('$seed');";
      JsEvalResult result = await jsRuntime!.evaluateAsync(script);

      return result.stringResult;
    } catch (e) {
      debugPrint("Error generating avatar: $e");
      // Return fallback SVG on error
      return '<svg viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="#${seed.hashCode.toRadixString(16).substring(0, 6)}"/></svg>';
    }
  }
}
