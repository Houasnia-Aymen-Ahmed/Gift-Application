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
                
                val pendingIntent: PendingIntent = HomeWidgetLaunchIntent.getActivity(context,
                        MainActivity::class.java)

                setOnClickPendingIntent(R.id.widget_root, pendingIntent)

                var textContent = widgetData.getString("_textContent", "")
                var textColor = android.R.color.white

                if (textContent == "") {
                    textContent = "You can see your friend's text here"
                    textColor = android.R.color.darker_gray
                }

                setTextViewText(R.id.tv_counter, textContent)
                setTextColor(R.id.tv_counter, context.resources.getColor(textColor))

                // Pending intent to update counter on button click
                val backgroundIntent = HomeWidgetBackgroundIntent.getBroadcast(context,
                        Uri.parse("gift://updatecounter"))
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }
}