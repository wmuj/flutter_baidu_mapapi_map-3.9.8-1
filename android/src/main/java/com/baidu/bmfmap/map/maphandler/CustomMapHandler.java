package com.baidu.bmfmap.map.maphandler;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.mapapi.map.CustomMapStyleCallBack;
import com.baidu.mapapi.map.MapCustomStyleOptions;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import io.flutter.FlutterInjector;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class CustomMapHandler extends BMapHandler {
    
    public CustomMapHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }
    
    @Override
    public void handlerMethodCallResult(Context context, MethodCall call,
                                        MethodChannel.Result result) {

        if (null == call) {
            result.success(false);
            return;
        }

        String methodId = call.method;
        if (TextUtils.isEmpty(methodId)) {
            result.success(false);
            return;
        }

        switch (methodId) {
            case Constants.MethodProtocol.CustomMapProtocol.sMapSetCustomMapStyleEnableMethod:
                setCustomMapStyleEnable(call, result);
                break;
            case Constants.MethodProtocol.CustomMapProtocol.sMapSetCustomMapStylePathMethod:
                setCustomMapStylePath(context, call, result);
                break;
            case Constants.MethodProtocol.CustomMapProtocol.sMapSetCustomMapStyleWithOptionMethod:
                setMapCustomStyle(call, result);
                break;
            default:
                break;
        }
    }

    /**
     * 个性化地图开关
     */
    private void setCustomMapStyleEnable(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("enable")) {
            result.success(false);
            return;
        }
        boolean enable = (boolean) argument.get("enable");
        if (mMapController != null && mMapController.getFlutterMapViewWrapper() != null) {
            mMapController.getFlutterMapViewWrapper().setCustomMapStyleEnable(enable);
            result.success(true);
        }
    }

    /**
     * 设置个性化地图样式文件的路径
     */
    private void setCustomMapStylePath(Context context, MethodCall call,
                                       MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || context == null) {
            result.success(false);
            return;
        }

        if (!argument.containsKey("path") || !argument.containsKey("mode")) {
            result.success(false);
            return;
        }

        String path = (String) argument.get("path");
        if (path.isEmpty()) {
            result.success(false);
            return;
        }

        String customStyleFilePath = getCustomStyleFilePath(context, path);
        if (TextUtils.isEmpty(customStyleFilePath)) {
            result.success(false);
            return;
        }
        if (mMapController != null && mMapController.getFlutterMapViewWrapper() != null) {
            mMapController.getFlutterMapViewWrapper().setCustomMapStylePath(customStyleFilePath);
            result.success(true);
        }
    }

    private String getCustomStyleFilePath(Context context, String customStyleFilePath) {
        if (customStyleFilePath.isEmpty()) {
            return null;
        }

        FileOutputStream outputStream = null;
        InputStream inputStream = null;
        String parentPath = null;
        String customStyleFileName = null;
        try {
            customStyleFileName = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(customStyleFilePath);
            inputStream = context.getAssets().open(customStyleFileName);
            byte[] buffer = new byte[inputStream.available()];
            inputStream.read(buffer);

            parentPath = context.getCacheDir().getAbsolutePath();
            String substr =
                    customStyleFileName.substring(0, customStyleFileName.lastIndexOf("/"));
            File customStyleFile = new File(parentPath + "/" + customStyleFileName);
            if (customStyleFile.exists()) {
                customStyleFile.delete();
            }
            File dirFile = new File(parentPath + "/" + substr);
            if (!dirFile.exists()) {
                dirFile.mkdirs();
            }
            customStyleFile.createNewFile();
            outputStream = new FileOutputStream(customStyleFile);
            outputStream.write(buffer);
        } catch (IOException e) {
            Log.e("TAG", "Copy file failed", e);
        } finally {
            try {
                if (inputStream != null) {
                    inputStream.close();
                }
                if (outputStream != null) {
                    outputStream.close();
                }
            } catch (IOException e) {
                Log.e("TAG", "Close stream failed", e);
            }
        }
        return parentPath + "/" + customStyleFileName;
    }

    /**
     * 在线个性化样式加载状态回调接口
     */
    private void setMapCustomStyle(MethodCall call, final MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("customMapStyleOption")) {
            return;
        }
        Map<String, Object> customMapStyleOption =
                (Map<String, Object>) argument.get("customMapStyleOption");
        if (!customMapStyleOption.containsKey("customMapStyleID")
                || !customMapStyleOption.containsKey("customMapStyleFilePath")) {
            return;
        }

        String customMapStyleID = (String) customMapStyleOption.get("customMapStyleID");
        String customMapStyleFilePath =
                (String) customMapStyleOption.get("customMapStyleFilePath");
        if (customMapStyleID.isEmpty() && customMapStyleFilePath.isEmpty()) {
            return;
        }
        MapCustomStyleOptions mapCustomStyleOptions = new MapCustomStyleOptions();
        mapCustomStyleOptions.customStyleId(customMapStyleID);
        mapCustomStyleOptions.localCustomStylePath(customMapStyleFilePath);
        final HashMap<String, String> reslutMap = new HashMap<>();
        if (mMapController != null && mMapController.getFlutterMapViewWrapper() != null) {
            mMapController.getFlutterMapViewWrapper().setMapCustomStyle(mapCustomStyleOptions,
                    new CustomMapStyleCallBack() {
                        boolean isPreloaded = false;
                        String preloadPath = null;
                @Override
                public boolean onPreLoadLastCustomMapStyle(String path) {
                    isPreloaded = true;
                    preloadPath = path;
                    return false;
                }

                @Override
                public boolean onCustomMapStyleLoadSuccess(boolean b, String path) {
                    reslutMap.put("styHasUpdate", String.valueOf(b));
                    reslutMap.put("successPath", path);
                    if (isPreloaded) {
                        reslutMap.put("preloadPath", path);
                    }
                    result.success(reslutMap);
                    // 防止在线加载后Flutter不刷新地图
                    if (mMapController.getBaiduMap() != null) {
                        mMapController.getBaiduMap().mapRefresh(300);
                    }
                    return false;
                }

                @Override
                public boolean onCustomMapStyleLoadFailed(int status, String message, String path) {
                    String sStatus = String.valueOf(status);
                    reslutMap.put("errorCode", sStatus);
                    reslutMap.put("errorPath", path);
                    if (isPreloaded) {
                        reslutMap.put("preloadPath", path);
                    }
                    result.success(reslutMap);
                    return false;
                }
            });
        }
    }
}
