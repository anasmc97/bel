package com.example.bel

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.os.*
import androidx.core.app.NotificationCompat
import java.lang.ref.WeakReference

class NativeService : Service(), NativeServiceCallback {

    companion object {
        const val ACTION_CREATE = "nativeService.create"
        const val ACTION_DESTROY = "nativeService.destroy"
        const val START = 1
        const val STOP = 0
        const val CHANNEL_NAME = "channel bel"
        const val NOTIFICATION_ID = 95
    }

    override fun onStartCommand(intent: Intent, flags: Int, startId: Int): Int {
        val action = intent.action
        if (action != null) {
            when (action) {
                ACTION_CREATE -> {
                }
                ACTION_DESTROY -> {
                    stopNotif()
                    stopSelf()
                }
                else -> {
                }
            }
        }
        return flags
    }

    override fun onBind(p0: Intent?): IBinder? {
        return messenger.binder
    }

    override fun onStart() {
        showNotif()
    }

    override fun onStop() {
        stopNotif()
    }

    private fun mCreateChannel(CHANNEL_ID: String) {
        val notificationManager = applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(CHANNEL_ID, CHANNEL_ID, NotificationManager.IMPORTANCE_DEFAULT)
            channel.setShowBadge(false)
            channel.setSound(null, null)

            notificationManager.createNotificationChannel(channel)
        }
    }

    private fun showNotif() {


        val notificationIntent = Intent(this, MainActivity::class.java)
        notificationIntent.flags = Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT

        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, 0)

        val notification = NotificationCompat.Builder(this, CHANNEL_NAME)
                .setContentTitle("Bel Sekolah")
                .setContentText("Sedang berjalan...")
                .setContentIntent(pendingIntent)
                .setSmallIcon(R.drawable.ic_access_alarm)
                .build()

        mCreateChannel(CHANNEL_NAME)

        startForeground(NOTIFICATION_ID, notification)
    }

    private fun stopNotif() {
        stopForeground(false)
    }

    private val messenger = Messenger(IncomingHandler(this))

    internal class IncomingHandler(nativeServiceCallback: NativeServiceCallback) : Handler() {
        private val nativeServiceCallbackWeakReference: WeakReference<NativeServiceCallback> = WeakReference(nativeServiceCallback)

        override fun handleMessage(msg: Message) {
            when (msg.what) {
                START -> nativeServiceCallbackWeakReference.get()?.onStart()
                STOP -> nativeServiceCallbackWeakReference.get()?.onStop()
                else -> super.handleMessage(msg)
            }
        }
    }
}