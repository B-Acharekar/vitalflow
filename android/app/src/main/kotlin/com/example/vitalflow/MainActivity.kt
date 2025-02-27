package com.example.vitalflow

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class MainActivity : FlutterActivity(), CoroutineScope {
    private val CHANNEL = "vitalflow/health"
    private val job = Job()
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val healthConnectManager = HealthConnectManager(this)

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStepCount" -> {
                    launch {
                        try {
                            val steps = healthConnectManager.readStepCount()
                            result.success(steps) // Return actual step count
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to get step count", e.message)
                        }
                    }
                }
                "getHeartRate" -> {
                    launch {
                        try {
                            val heartRate = healthConnectManager.readHeartRate()
                            result.success(heartRate)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to get heart rate", e.message)
                        }
                    }
                }
//                "getHeight" -> {
//                    launch {
//                        try{
//                            val height = healthConnectManager.readHeight()
//                            result.success(height)
//                        } catch(e: Exception) {
//                            result.error("ERROR","Failed to get Height", e.message)
//                        }
//                    }
//                }
                "getWeight" -> {
                    launch {
                        try{
                            val weight = healthConnectManager.readWeight()
                            result.success(weight)
                        } catch(e: Exception) {
                            result.error("ERROR","Failed to get weight", e.message)
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        job.cancel()
    }
}
