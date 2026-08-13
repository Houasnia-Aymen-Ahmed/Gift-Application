package com.gift.gift

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import android.app.PendingIntent
import com.gift.gift.R
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetLaunchIntent
import es.antonborri.home_widget.HomeWidgetProvider

class AppWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray, widgetData: SharedPreferences) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.widget_layout).apply {

                // Open App on Widget Click
                val launchIntent: PendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                        MainActivity::class.java)
                setOnClickPendingIntent(R.id.widget_root, launchIntent)

                val friendName = widgetData.getString("_friendName", "")
                var textContent = widgetData.getString("_textContent", "")
                var textColor = android.R.color.white

                if (textContent == "") {
                    textContent = "You can see your friend's text here"
                    textColor = android.R.color.darker_gray
                }

                setTextViewText(R.id.tv_friend_name, friendName)
                setTextViewText(R.id.tv_counter, textContent)
                setTextColor(R.id.tv_counter, context.resources.getColor(textColor))

                // Prev/next friend cycling — handled by the Dart interactivity
                // callback registered via HomeWidget.registerInteractivityCallback.
                val prevIntent = HomeWidgetBackgroundIntent.getBroadcast(context,
                        Uri.parse("gift://widget_prev"))
                setOnClickPendingIntent(R.id.btn_widget_prev, prevIntent)

                val nextIntent = HomeWidgetBackgroundIntent.getBroadcast(context,
                        Uri.parse("gift://widget_next"))
                setOnClickPendingIntent(R.id.btn_widget_next, nextIntent)
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}
