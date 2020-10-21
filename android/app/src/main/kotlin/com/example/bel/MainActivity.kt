package com.example.bel


import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.*
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private var service: Messenger? = null
    private lateinit var boundServiceIntent: Intent
    private var serviceBound = false
    private val serviceConnection = object : ServiceConnection {
        override fun onServiceConnected(p0: ComponentName, p1: IBinder) {
            service = Messenger(p1)
            serviceBound = true
        }

        override fun onServiceDisconnected(p0: ComponentName) {
            service = null
            serviceBound = false
        }
    }

    companion object{
        private const val CHANNEL = "com.embundev.bel/bgServiceWithNotif"
        private const val METHOD = "getBgServiceWithNotif"
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        boundServiceIntent = Intent(this@MainActivity, NativeService::class.java)
        boundServiceIntent.action = NativeService.ACTION_CREATE

        startService(boundServiceIntent)
        bindService(boundServiceIntent, serviceConnection, Context.BIND_AUTO_CREATE)
    }

    //TODO pilih cara servis di stop

    // cara 1
//    override fun onResume() {
//        super.onResume()
//        boundServiceIntent.action = NativeService.ACTION_DESTROY
//        startService(boundServiceIntent)
//    }
    //cara 2
//    override fun onResume() {
//        super.onResume()
//        if (!serviceBound) return
//        try {
//            service?.send(Message.obtain(null, NativeService.STOP, 0, 0))
//        } catch (e: RemoteException) {
//            e.printStackTrace()
//        }
//    }

    override fun onDestroy() {
        super.onDestroy()
        unbindService(serviceConnection)
        boundServiceIntent.action = NativeService.ACTION_DESTROY
        startService(boundServiceIntent)
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->

            if (call.method == METHOD) {
                //
                if (!serviceBound) return@setMethodCallHandler
                try {
                    service?.send(Message.obtain(null, NativeService.START, 0, 0))
                    result.success("background service")
                } catch (e: RemoteException) {
                    e.printStackTrace()
                }
            }
        }
    }
}

