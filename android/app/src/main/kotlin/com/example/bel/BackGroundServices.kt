package com.example.bel

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat


class BackGroundServices : Service() {
    private val TAG = BackGroundServices::class.java.simpleName
    companion object {
        const val ACTION_CREATED = "BackServices.created"
        const val ACTION_DESTROY = "BackServices.destroy"
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val action = intent.action
        if (action != null){
            when(action){
                ACTION_CREATED -> {showNotif()}
                ACTION_DESTROY -> {}
                else -> {}
            }
        }
        return flags
    }
    override fun onBind(p0: Intent?): IBinder? {
        TODO("Not yet implemented")

    }

    private fun showNotif(){
        val channelId = "notif"
        val notificationId = 1
        val notificationIntent = Intent(this,MainActivity::class.java)
        notificationIntent.flags = Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT
        val pendingIntent = PendingIntent.getActivity(this,0,notificationIntent,0)
        val notification = NotificationCompat.Builder(this,channelId)
                .setContentTitle("Bel Sekolah")
                .setContentText("Sedang Berjalan...")
                //.setSmallIcon(R.drawable.unram)
                .setContentIntent(pendingIntent)
                .build()

        val mNotificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            val channel = NotificationChannel(channelId, "notifbel", NotificationManager.IMPORTANCE_DEFAULT)
            channel.setShowBadge(false)
            channel.setSound(null, null)
            mNotificationManager.createNotificationChannel(channel)
            startForeground(notificationId, notification)
        }
    }




}