package com.shizuka.app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray

class MainActivity : FlutterActivity() {
    private val apiSettingsChannel = "com.shizuka.app/api_settings"
    private val apiSettingsName = "api_settings"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            apiSettingsChannel,
        ).setMethodCallHandler { call, result ->
            val preferences = getSharedPreferences(apiSettingsName, MODE_PRIVATE)

            when (call.method) {
                "load" -> {
                    val modelsJson = preferences.getString("models", null)
                    val models = mutableListOf<String>()
                    if (!modelsJson.isNullOrEmpty()) {
                        val array = JSONArray(modelsJson)
                        for (index in 0 until array.length()) {
                            models.add(array.getString(index))
                        }
                    }

                    result.success(
                        mapOf(
                            "url" to preferences.getString("url", null),
                            "apiKey" to preferences.getString("apiKey", null),
                            "model" to preferences.getString("model", null),
                            "models" to models,
                        ),
                    )
                }

                "save" -> {
                    val models = call.argument<List<String>>("models").orEmpty()
                    preferences
                        .edit()
                        .putString("url", call.argument<String>("url").orEmpty())
                        .putString("apiKey", call.argument<String>("apiKey").orEmpty())
                        .putString("model", call.argument<String>("model").orEmpty())
                        .putString("models", JSONArray(models).toString())
                        .apply()
                    result.success(null)
                }

                else -> result.notImplemented()
            }
        }
    }
}
