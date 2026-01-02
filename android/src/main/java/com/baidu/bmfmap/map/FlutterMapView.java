package com.baidu.bmfmap.map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.LifecycleProxy;
import com.baidu.bmfmap.utils.Env;
import com.baidu.mapapi.map.MapView;

import android.content.Context;
import android.util.Log;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import io.flutter.plugin.platform.PlatformView;

public class FlutterMapView implements PlatformView, DefaultLifecycleObserver {

    private static final String TAG = "FlutterMapView";

    private MapView mMapView;

    private Context mContext;

    private BMFMapController mMapController;

    private LifecycleProxy mLifecycleProxy;
    
    private boolean mIsDisposed = false;

    public FlutterMapView(Context context, BMFMapController bmfMapController, LifecycleProxy lifecycleProxy) {
        this.mContext = context;
        this.mMapController = bmfMapController;
        mMapView  = mMapController.getFlutterMapViewWrapper().getMapView();
        this.mLifecycleProxy = lifecycleProxy;
        Lifecycle lifecycle = mLifecycleProxy.getLifecycle();
        if (lifecycle != null) {
            lifecycle.addObserver(this);
        }
    }

    @Override
    public View getView() {
        if (Env.DEBUG) {
            Log.d(TAG, "getView");
        }

        return mMapView;
    }

    @Override
    public void dispose() {
        if (Env.DEBUG) {
            Log.d(TAG, "dispose");
        }
        
        if (mIsDisposed) {
            return;
        }

        mIsDisposed = true;
        
        if (mMapController != null) {
            mMapController.release();
        }

        if (null != mMapView) {
            mMapView.onDestroy();
            mMapView = null;
        }

        Lifecycle lifecycle = mLifecycleProxy.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this);
        }

    }

    public MapView getMapView() {
        return mMapView;
    }

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        if (!mIsDisposed && null != mMapView) {
            mMapView.onResume();
        }
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        if (!mIsDisposed && null != mMapView) {
            mMapView.onPause();
        }
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        if (!mIsDisposed && null != mMapView) {
            mMapView.onDestroy();
            mMapView = null;
        }
    }
}
