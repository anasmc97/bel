package com.example.bel


import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.ServiceConnection
import android.os.IBinder
import android.os.Messenger
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    val CHANNEL = "backgroundServices.channel"
    val KEY_NATIVE = "BackGroundService"
    private var mServices: Messenger? = null
    private lateinit var mBoundServicesIntent: Intent
    private var mServicesBound = false
    private val mServicesConnection = object: ServiceConnection{
        override fun onServiceDisconnected(p0: ComponentName?) {
            TODO("Not yet implemented")
            mServices = null
            mServicesBound = false
        }

        override fun onServiceConnected(p0: ComponentName?, p1: IBinder?) {
            TODO("Not yet implemented")
            mServices = Messenger(p1)
            mServicesBound = true
        }

    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler{
            call, result ->
            if (call.method == KEY_NATIVE){
                mBoundServicesIntent = Intent(this@MainActivity,BackGroundServices::class.java)
                mBoundServicesIntent.action = BackGroundServices.ACTION_CREATED
                startService(mBoundServicesIntent)
                bindService(mBoundServicesIntent,mServicesConnection,Context.BIND_AUTO_CREATE)
                result.success("berhasil")
            }
        }

    }

    override fun onDestroy() {
        super.onDestroy()
        unbindService(mServicesConnection)
        mBoundServicesIntent.action = BackGroundServices.ACTION_DESTROY
        startService(mBoundServicesIntent)
    }
}
