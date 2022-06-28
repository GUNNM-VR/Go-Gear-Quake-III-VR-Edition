package com.GUNNM_VR.Quake3eVR;

import android.Manifest;
import android.content.pm.PackageManager;
import android.content.res.AssetManager;
import android.os.Bundle;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.view.View;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

public class MainActivity extends android.app.NativeActivity implements ActivityCompat.OnRequestPermissionsResultCallback {

    static {
        // Load jni .so on initialization
        System.loadLibrary( "vrapi" );
        System.loadLibrary( "Quake3eVR" );
    }

    public static native void StoragePermissionsGranted( int permissionsGranted );

    //
    // Android immersive mode for games
    // cf. https://developer.android.com/training/system-ui/immersive.html
    //
    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        super.onWindowFocusChanged(hasFocus);
        if (hasFocus) {
            hideSystemUI();
        }
    }

    private void hideSystemUI() {
        // Enables regular immersive mode.
        // For "lean back" mode, remove SYSTEM_UI_FLAG_IMMERSIVE.
        // Or for "sticky immersive," replace it with SYSTEM_UI_FLAG_IMMERSIVE_STICKY
        View decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_IMMERSIVE
                        // Set the content to appear under the system bars so that the
                        // content doesn't resize when the system bars hide and show.
                        | View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        // Hide the nav bar and status bar
                        | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_FULLSCREEN);
    }

    private void showSystemUI() {
        // Shows the system bars by removing all the flags
        // except for the ones that make the content appear under the system bars.
        View decorView = getWindow().getDecorView();
        decorView.setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
                        | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN);
    }
    //
    // end of Android immersive mode
    //

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // Request permission before launching the game
        super.onCreate(savedInstanceState);

        int read_perm  = ContextCompat.checkSelfPermission( this, Manifest.permission.READ_EXTERNAL_STORAGE);
        int write_perm = ContextCompat.checkSelfPermission( this, Manifest.permission.WRITE_EXTERNAL_STORAGE);

        if ( read_perm != PackageManager.PERMISSION_GRANTED || write_perm != PackageManager.PERMISSION_GRANTED)
        {
            //Log.d("onCreate" , "requesting necessary permissions ... ");
            ActivityCompat.requestPermissions( this, new String[]{ Manifest.permission.READ_EXTERNAL_STORAGE }, 0 );
            ActivityCompat.requestPermissions( this, new String[]{ Manifest.permission.WRITE_EXTERNAL_STORAGE }, 0 );
        }
        else
        {
            if (!alreadyInstall()) {
                new File("/sdcard/quake3/baseq3").mkdirs();
                // copy demo only if no pak0 found
                if (!fileExist("/sdcard/quake3/baseq3/pak0.pk3")) {
                    copy_asset("/sdcard/quake3/baseq3", "pak0.pk3");
                }
                copy_asset("/sdcard/quake3/baseq3", "autoexec.cfg");
                copy_asset("/sdcard/quake3/baseq3", "pak8aVR.pk3");
            }
            StoragePermissionsGranted( 1 );
        }
    }

    private boolean fileExist(String pathname) {
        File fileToCheck = new File( pathname );
        return fileToCheck.exists();
    }

    private boolean alreadyInstall() {
        return fileExist("/sdcard/quake3/baseq3/pak8aVR.pk3");
    }

    private void copy_asset(String path, String name) {
        File f = new File(path + "/" + name);
        if (!f.exists()) {

            //Ensure we have an appropriate folder
            String fullname = path + "/" + name;
            String directory = fullname.substring(0, fullname.lastIndexOf("/"));
            new File(directory).mkdirs();
            _copy_asset(name, path + "/" + name);
        }
    }

    private void _copy_asset(String name_in, String name_out) {
        AssetManager assets = this.getAssets();
        try {
            InputStream in = assets.open(name_in);
            OutputStream out = new FileOutputStream(name_out);
            copy_stream(in, out);
            out.close();
            in.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private static void copy_stream(InputStream in, OutputStream out)
            throws IOException {
        byte[] buf = new byte[1024];
        while (true) {
            int count = in.read(buf);
            if (count <= 0)
                break;
            out.write(buf, 0, count);
        }
    }

    // ActivityCompat.OnRequestPermissionsResultCallback
    @Override
    public void onRequestPermissionsResult( int requestCode, String[] permissions, int[] grantResults ) {
        for (int i = 0; i < permissions.length; i++)
        {
            switch (permissions[i])
            {
                case Manifest.permission.READ_EXTERNAL_STORAGE:
                {
                    if (grantResults[i] == PackageManager.PERMISSION_GRANTED)
                    {
                        //Log.d( "onRequestPermissionsResult", "Permission GRANTED" );
                        runOnUiThread( new Thread() {
                            @Override
                            public void run() {
                                StoragePermissionsGranted( 1 );
                            }
                        });
                    }
                    else
                    {
                        //Log.d( "onRequestPermissionsResult", "Permission DENIED" );
                        StoragePermissionsGranted( 0 );
                    }
                    return;
                }

                default:
                    break;
            }
        }
    }
}
