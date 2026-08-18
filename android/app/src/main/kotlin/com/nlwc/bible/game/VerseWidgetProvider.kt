package com.nlwc.bible.game

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import org.json.JSONObject
import java.util.Calendar

/**
 * Home screen widget showing a rotating Bible verse. The verse changes every
 * hour via updatePeriodMillis-driven onUpdate calls; verses are read from the
 * same bundled JSON asset the Flutter app and iOS widget use, so no Flutter
 * engine is needed while the app is closed.
 */
class VerseWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val (reference, text) = currentVerse(context)
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.verse_widget)
            views.setTextViewText(R.id.verse_text, "“$text”")
            views.setTextViewText(R.id.verse_reference, reference)

            val launchIntent = Intent(context, MainActivity::class.java)
            val pendingIntent = PendingIntent.getActivity(
                context,
                0,
                launchIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    private fun currentVerse(context: Context): Pair<String, String> {
        return try {
            val json = context.assets
                .open("flutter_assets/assets/data/memory_verses.json")
                .bufferedReader()
                .use { it.readText() }
            val topics = JSONObject(json).getJSONArray("topics")
            val verses = mutableListOf<Pair<String, String>>()
            for (i in 0 until topics.length()) {
                val topicVerses = topics.getJSONObject(i).getJSONArray("verses")
                for (j in 0 until topicVerses.length()) {
                    val v = topicVerses.getJSONObject(j)
                    verses.add(v.getString("reference") to v.getString("text"))
                }
            }
            val cal = Calendar.getInstance()
            val index = (cal.get(Calendar.DAY_OF_YEAR) * 24 +
                cal.get(Calendar.HOUR_OF_DAY)) % verses.size
            verses[index]
        } catch (e: Exception) {
            "Psalm 119:105" to
                "Thy word is a lamp unto my feet, and a light unto my path."
        }
    }
}
