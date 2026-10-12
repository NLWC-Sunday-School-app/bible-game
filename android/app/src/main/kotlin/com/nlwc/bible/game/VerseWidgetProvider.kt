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
 * Home screen widget showing a rotating Bible verse. It redraws every hour via
 * updatePeriodMillis-driven onUpdate calls (and straight away when the app's
 * verse frequency changes), showing the verse for the current slot of that
 * frequency; verses are read from the
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

    /**
     * The gap between verses chosen in the app, from the preferences file
     * Flutter's shared_preferences writes (it prefixes keys with "flutter.").
     */
    private fun verseFrequencyHours(context: Context): Int {
        val supported = setOf(1, 2, 3, 4, 6, 8, 12, 24)
        val stored = try {
            context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
                .getLong("flutter.verseFrequencyHours", 1L).toInt()
        } catch (e: ClassCastException) {
            1
        }
        return if (stored in supported) stored else 1
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
            // Same verse as the lock screen notification for this slot: with
            // every 4 hours, 9:30 shows the 8:00 verse. The notifications count
            // the day of the year from 0, so DAY_OF_YEAR is taken down by one.
            val cal = Calendar.getInstance()
            val every = verseFrequencyHours(context)
            val hour = cal.get(Calendar.HOUR_OF_DAY)
            val slotHour = hour - hour % every
            val dayOfYear = cal.get(Calendar.DAY_OF_YEAR) - 1
            verses[(dayOfYear * 24 + slotHour) % verses.size]
        } catch (e: Exception) {
            "Psalm 119:105" to
                "Thy word is a lamp unto my feet, and a light unto my path."
        }
    }
}
