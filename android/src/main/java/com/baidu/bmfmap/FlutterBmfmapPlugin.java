package com.baidu.bmfmap;

import java.util.HashMap;
import java.util.Map;

import com.baidu.bmfmap.map.OfflineHandler;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.mapapi.VersionInfo;

import android.app.Activity;
import android.app.Application;
import android.os.Bundle;
import android.util.Log;
import androidx.annotation.NonNull;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.LifecycleRegistry;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.plugins.lifecycle.FlutterLifecycleAdapter;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * FlutterBmfmapPlugin
 */
public class FlutterBmfmapPlugin implements FlutterPlugin, ActivityAware,
        MethodChannel.MethodCallHandler {
    private static final String TAG = FlutterBmfmapPlugin.class.getSimpleName();

    private Lifecycle mLifecycle;

    private OfflineHandler mOfflineHandler;

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {

        BinaryMessenger mMessenger = flutterPluginBinding.getBinaryMessenger();

        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(
                Constants.ViewType.sMapView,
                new MapViewFactory(flutterPluginBinding.getBinaryMessenger(), new LifecycleProxy() {
                    @Override
                    public Lifecycle getLifecycle() {
                        return mLifecycle;
                    }
                }));

        flutterPluginBinding.getPlatformViewRegistry().registerViewFactory(
                Constants.ViewType.sTextureMapView,
                new TextureMapViewFactory(flutterPluginBinding.getBinaryMessenger(),
                        new LifecycleProxy() {
                            @Override
                            public Lifecycle getLifecycle() {
                                return mLifecycle;
                            }
                        }));

        // 单独配置获取版本的消息通道,和地图实例的消息通道无关
        MethodChannel methodChannel = new MethodChannel(mMessenger,
                Constants.NATIVE_SDK_VERSION_CHANNEL);
        methodChannel.setMethodCallHandler(this);

        mOfflineHandler = new OfflineHandler();
        mOfflineHandler.init(mMessenger);
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {

        BinaryMessenger binaryMessenger = binding.getBinaryMessenger();

        mOfflineHandler.unInit(binaryMessenger);
    }

    @Override
    public void onAttachedToActivity(ActivityPluginBinding binding) {
        mLifecycle = FlutterLifecycleAdapter.getActivityLifecycle(binding);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        Log.d(TAG, "onDetachedFromActivityForConfigChanges");
        onDetachedFromActivity();
    }

    @Override
    public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
        Log.d(TAG, "onReattachedToActivityForConfigChanges");
        onAttachedToActivity(binding);
    }

    @Override
    public void onDetachedFromActivity() {
        Log.d(TAG, "onDetachedFromActivity");
        mLifecycle = null;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        if (call.method.equals(Constants.NATIVE_SDK_VERSION)) {
            Map<String, String> versionMap = new HashMap<>();
            versionMap.put("version", VersionInfo.getApiVersion());
            versionMap.put("platform", "Android");
            result.success(versionMap);
        }
    }

    private static class ActivityLifecycleProxy implements LifecycleProxy,
            Application.ActivityLifecycleCallbacks, LifecycleOwner {

        private final LifecycleRegistry mLifecycle = new LifecycleRegistry(this);
        private final int mRegistrarActivityHashCode;

        private ActivityLifecycleProxy(Activity activity) {
            this.mRegistrarActivityHashCode = activity.hashCode();
            activity.getApplication().registerActivityLifecycleCallbacks(this);
        }

        @Override
        public Lifecycle getLifecycle() {
            return mLifecycle;
        }

        @Override
        public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
            if (activity.hashCode() != mRegistrarActivityHashCode) {
                return;
            }
            mLifecycle.handleLifecycleEvent(Lifecycle.Event.ON_CREATE);
        }

        @Override
        public void onActivityStarted(Activity activity) {
            if (activity.hashCode() != mRegistrarActivityHashCode) {
                return;
            }
            mLifecycle.handleLifecycleEvent(Lifecycle.Event.ON_CREATE);
        }

        @Override
        public void onActivityResumed(Activity activity) {
            if (activity.hashCode() != mRegistrarActivityHashCode) {
                return;
            }
            mLifecycle.handleLifecycleEvent(Lifecycle.Event.ON_RESUME);
        }

        @Override
        public void onActivityPaused(Activity activity) {
            if (activity.hashCode() != mRegistrarActivityHashCode) {
                return;
            }
            mLifecycle.handleLifecycleEvent(Lifecycle.Event.ON_PAUSE);
        }

        @Override
        public void onActivityStopped(Activity activity) {
            if (activity.hashCode() != mRegistrarActivityHashCode) {
                return;
            }
            mLifecycle.handleLifecycleEvent(Lifecycle.Event.ON_STOP);
        }

        @Override
        public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
        }

        @Override
        public void onActivityDestroyed(Activity activity) {
            if (activity.hashCode() != mRegistrarActivityHashCode) {
                return;
            }
            mLifecycle.handleLifecycleEvent(Lifecycle.Event.ON_DESTROY);
        }
    }

}
