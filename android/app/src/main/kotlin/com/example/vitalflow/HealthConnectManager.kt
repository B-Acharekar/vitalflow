package com.example.vitalflow

import android.content.Context
import androidx.health.connect.client.HealthConnectClient
import androidx.health.connect.client.records.StepsRecord
import androidx.health.connect.client.records.HeartRateRecord
import androidx.health.connect.client.records.HeightRecord
import androidx.health.connect.client.records.WeightRecord
import androidx.health.connect.client.request.ReadRecordsRequest
import androidx.health.connect.client.time.TimeRangeFilter
import java.time.temporal.ChronoUnit
import java.time.Instant
import java.time.ZonedDateTime
import java.time.ZoneOffset

class HealthConnectManager(context: Context) {
    private val healthConnectClient = HealthConnectClient.getOrCreate(context)

    suspend fun readStepCount(): Int {
        // Get the current date and start time from midnight of today
        val currentDate = ZonedDateTime.now().toLocalDate().atStartOfDay(ZonedDateTime.now().zone)
        val startTime: Instant = currentDate.toInstant()  // Midnight today
        val endTime: Instant = ZonedDateTime.now().toInstant()  // Current time

        // Log the times being used for the request (for debugging purposes)
        println("Fetching steps from: $startTime to $endTime")

        // Create a request to fetch step count data within the time range (today)
        val request = ReadRecordsRequest(
            recordType = StepsRecord::class, // Correct record type for step count
            timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
        )

        // Make the request to Health Connect API
        val response = healthConnectClient.readRecords(request)

        // Sum up and return the total steps counted today
        return response.records.sumOf { it.count.toInt() }
    }

    suspend fun readHeartRate(): Double {
        val endTime = ZonedDateTime.now().toInstant()
        val startTime = endTime.minusSeconds(86400) // 24 hours ago

        val request = ReadRecordsRequest(
            recordType = HeartRateRecord::class,
            timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
        )

        val response = healthConnectClient.readRecords(request)

        // Calculate average heart rate
        return if (response.records.isNotEmpty()) {
            response.records.flatMap { it.samples }.map { it.beatsPerMinute }.average()
        } else {
            0.0 // No data available
        }
    }

    suspend fun readWeight(): Double {
        val endTime = ZonedDateTime.now().toInstant()
        val startTime = endTime.minusSeconds(86400) // 24 hours ago

        val request = ReadRecordsRequest(
            recordType = WeightRecord::class,
            timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
        )

        val response = healthConnectClient.readRecords(request)
        return response.records.lastOrNull()?.weight?.inKilograms ?: 0.0 // Get latest weight
    }

//    suspend fun readHeight(): Double {
//        val endTime = ZonedDateTime.now().toInstant()
//        val startTime = endTime.minusSeconds(86400) // 24 hours ago
//
//        val request = ReadRecordsRequest(
//            recordType = HeightRecord::class,
//            timeRangeFilter = TimeRangeFilter.between(startTime, endTime)
//        )
//
//        val response = healthConnectClient.readRecords(request)
//        return response.records.lastOrNull()?.height?.inMeters ?: 0.0 // Get latest height
//    }
}
