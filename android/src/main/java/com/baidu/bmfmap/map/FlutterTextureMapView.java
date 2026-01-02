package com.baidu.bmfmap.map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.LifecycleProxy;
import com.baidu.bmfmap.utils.Env;
import com.baidu.mapapi.map.TextureMapView;

import android.content.Context;
import android.util.Log;
import android.view.View;
import androidx.annotation.NonNull;
import androidx.lifecycle.DefaultLifecycleObserver;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import io.flutter.plugin.platform.PlatformView;

public class FlutterTextureMapView implements PlatformView, DefaultLifecycleObserver {
    
    private static final String TAG = "FlutterMapView";

    private TextureMapView mTextureMapView;

    private Context mContext;

    private BMFMapController mMapController;

    private LifecycleProxy mLifecycleProxy;
    
    
    private boolean mIsDisposed;

    public FlutterTextureMapView(Context context, BMFMapController bmfMapController,
                                 LifecycleProxy lifecycleProxy) {
        this.mContext = context;
        this.mMapController = bmfMapController;
        mTextureMapView = mMapController.getFlutterMapViewWrapper().getTextureMapView();
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

        return mTextureMapView;
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

        Lifecycle lifecycle = mLifecycleProxy.getLifecycle();
        if (lifecycle != null) {
            lifecycle.removeObserver(this);
        }

        if (null != mTextureMapView) {
            mTextureMapView.onDestroy();
            mTextureMapView = null;
        }
    }

    @Override
    public void onCreate(@NonNull LifecycleOwner owner) {
        
    }

    @Override
    public void onStart(@NonNull LifecycleOwner owner) {
        
    }

    @Override
    public void onResume(@NonNull LifecycleOwner owner) {
        if (!mIsDisposed && null != mTextureMapView) {
            mTextureMapView.onResume();
        }
    }

    @Override
    public void onPause(@NonNull LifecycleOwner owner) {
        if (!mIsDisposed && null != mTextureMapView) {
            mTextureMapView.onPause();
        }
    }

    @Override
    public void onStop(@NonNull LifecycleOwner owner) {
        
    }

    @Override
    public void onDestroy(@NonNull LifecycleOwner owner) {
        owner.getLifecycle().removeObserver(this);
        if (!mIsDisposed && null != mTextureMapView) {
            mTextureMapView.onDestroy();
            mTextureMapView = null;
        }
    }
    
}
