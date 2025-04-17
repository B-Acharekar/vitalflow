package com.example.vitalflow

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.*
import kotlin.coroutines.CoroutineContext

class MainActivity : FlutterActivity(), CoroutineScope {
    private val CHANNEL = "vitalflow/health"
    private val job = Job()
    private val PERMISSIONS_REQUEST_CODE = 123
    override val coroutineContext: CoroutineContext
        get() = Dispatchers.Main + job

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Step 1: Request necessary permissions
        checkPermissions()

        val healthConnectManager = HealthConnectManager(this)

        // Step 2: Setup method channel to talk to Flutter
        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getStepCount" -> {
                    launch {
                        try {
                            val steps = healthConnectManager.readStepCount()
                            result.success(steps)
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
                "getWeight" -> {
                    launch {
                        try {
                            val weight = healthConnectManager.readWeight()
                            result.success(weight)
                        } catch (e: Exception) {
                            result.error("ERROR", "Failed to get weight", e.message)
                        }
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    // Function to check and request permissions
    private fun checkPermissions() {
        if (ContextCompat.checkSelfPermission(this, Manifest.permission.BODY_SENSORS) != PackageManager.PERMISSION_GRANTED
            || ContextCompat.checkSelfPermission(this, Manifest.permission.ACTIVITY_RECOGNITION) != PackageManager.PERMISSION_GRANTED) {

            ActivityCompat.requestPermissions(
                this,
                arrayOf(
                    Manifest.permission.BODY_SENSORS,
                    Manifest.permission.ACTIVITY_RECOGNITION
                ),
                PERMISSIONS_REQUEST_CODE
            )
        }
    }

    // Function to handle result of permission request
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == PERMISSIONS_REQUEST_CODE) {
            if (grantResults.isNotEmpty() && grantResults.all { it == PackageManager.PERMISSION_GRANTED }) {
                // All permissions granted
                Toast.makeText(this, "Permissions granted", Toast.LENGTH_SHORT).show()
            } else {
                Toast.makeText(this, "Permissions denied. App may not work properly.", Toast.LENGTH_LONG).show()
            }
        }
    }

    override fun onDestroy() {
        super.onDestroy()
        job.cancel()
    }
}
