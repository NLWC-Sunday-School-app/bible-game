package com.nlwc.bible.game

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // The widget reads the frequency from the app's preferences itself.
        // The topics are a list, which shared_preferences stores in a format
        // of its own, so they are kept here as plain text for the widget. Then
        // the widget is redrawn now instead of at its next hourly update.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "bible_game/verse_widget")
            .setMethodCallHandler { call, result ->
                if (call.method != "update") {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                val topics = call.argument<List<String>>("topics") ?: emptyList()
                getSharedPreferences(VerseWidgetProvider.PREFS, MODE_PRIVATE).edit()
                    .putString(VerseWidgetProvider.TOPICS_KEY, topics.joinToString(","))
                    .apply()
                val manager = AppWidgetManager.getInstance(this)
                val ids = manager.getAppWidgetIds(ComponentName(this, VerseWidgetProvider::class.java))
                if (ids.isNotEmpty()) {
                    sendBroadcast(
                        Intent(this, VerseWidgetProvider::class.java)
                            .setAction(AppWidgetManager.ACTION_APPWIDGET_UPDATE)
                            .putExtra(AppWidgetManager.EXTRA_APPWIDGET_IDS, ids)
                    )
                }
                result.success(null)
            }
    }
}
