package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.FlutterDataConveter;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.BaiduMap;
import com.baidu.mapapi.map.Overlay;
import com.baidu.mapapi.map.Text;
import com.baidu.mapapi.map.TextOptions;
import com.baidu.mapapi.model.LatLng;

import android.graphics.Typeface;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class TextHandler extends OverlayHandler {
    private static final String TAG = "TextHandler";

    public TextHandler(BMFMapController bmfMapController) {
        super(bmfMapController);
    }

    @Override
    public void handlerMethodCall(MethodCall call, MethodChannel.Result result) {
        if (Env.DEBUG) {
            Log.d(TAG, "handlerMethodCall enter");
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument is null");
            }
            return;
        }

        String methodId = call.method;
        boolean ret = false;
        switch (methodId) {
            case Constants.MethodProtocol.TextProtocol.sMapAddTextMethod:
                ret = addText(argument);
                break;
            case Constants.MethodProtocol.TextProtocol.sMapUpdateTextMemberMethod:
                ret = updateMember(argument);
                break;
            default:
                break;
        }

        result.success(ret);
    }

    public boolean addText(Map<String, Object> argument) {
        if (null == argument) {
            return false;
        }

        if (mBaiduMap == null) {
            return false;
        }

        BaiduMap baiduMap = mMapController.getBaiduMap();
        if (baiduMap == null) {
            return false;
        }

        if (!argument.containsKey("id")
                || !argument.containsKey("text")
                || !argument.containsKey("position")) {
            if (Env.DEBUG) {
                Log.d(TAG, "argument does not contain" + argument.toString());

            }
            return false;
        }

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap.containsKey(id)) {
            return false;
        }

        TextOptions textOptions = new TextOptions();

        Object posObj = (argument.get("position"));
        if (null != posObj) {
            Map<String, Object> posMap = (Map<String, Object>) posObj;
            LatLng pos = FlutterDataConveter.mapToLatlng(posMap);
            if (null != pos) {
                if (Env.DEBUG) {
                    Log.d(TAG, "pos");
                }
                textOptions.position(pos);
            }
        }

        String text = new TypeConverter<String>().getValue(argument, "text");
        if (TextUtils.isEmpty(text)) {
            return false;
        }
        textOptions.text(text);

        setTextOptions(argument, textOptions);

        HashMap<String,Object> customMap = null;
        if (argument.containsKey("customMap")) {
            customMap = (HashMap<String, Object>) argument.get("customMap");
        }

        final Overlay overlay = baiduMap.addOverlay(textOptions);
        if (null != overlay) {
            Bundle bundle = new Bundle();
            if (customMap != null && customMap.size() > 0) {
                bundle.putSerializable("customMap", customMap);
            }
            overlay.setExtraInfo(bundle);
            mOverlayMap.put(id, overlay);
            mMapController.mOverlayIdMap.put(id, overlay);
            
            return true;
        }

        return false;
    }

    private void setTextOptions(Map<String, Object> textOptionsMap, TextOptions textOptions) {
        if (null == textOptionsMap || null == textOptions) {
            return;
        }

        String bgColorStr = new TypeConverter<String>().getValue(textOptionsMap, "bgColor");
        if (!TextUtils.isEmpty(bgColorStr)) {
            int bgColor = FlutterDataConveter.strColorToInteger(bgColorStr);
            textOptions.bgColor(bgColor);
        }

        String fongColorStr = new TypeConverter<String>().getValue(textOptionsMap, "fontColor");
        if (!TextUtils.isEmpty(fongColorStr)) {
            int fontColor = FlutterDataConveter.strColorToInteger(fongColorStr);
            textOptions.fontColor(fontColor);
        }

        Integer fontSize = new TypeConverter<Integer>().getValue(textOptionsMap, "fontSize");
        if (null != fontSize) {
            textOptions.fontSize(fontSize);
        }

        Integer alignx = new TypeConverter<Integer>().getValue(textOptionsMap, "alignX");
        Integer aligny = new TypeConverter<Integer>().getValue(textOptionsMap, "alignY");
        if (null != alignx && null != aligny) {
            textOptions.align(alignx, aligny);
        }

        Double roate = new TypeConverter<Double>().getValue(textOptionsMap, "rotate");
        if (null != roate) {
            textOptions.rotate(roate.floatValue());
        }

        Integer zIndex = new TypeConverter<Integer>().getValue(textOptionsMap, "zIndex");
        if (null != zIndex) {
            textOptions.zIndex(zIndex);
        }

        Boolean visible = new TypeConverter<Boolean>().getValue(textOptionsMap, "visible");
        if (null != visible) {
            textOptions.visible(visible);
        }

        Map<String, Object> typeFaceMap =
                new TypeConverter<Map<String, Object>>().getValue(textOptionsMap, "typeFace");
        if (null != typeFaceMap) {
            String familyName = new TypeConverter<String>().getValue(typeFaceMap, "familyName");
            Integer textStype = new TypeConverter<Integer>().getValue(typeFaceMap, "textStype");
            if (!TextUtils.isEmpty(familyName) && textStype >= 0 && textStype <= 4) {
                Typeface typeface = Typeface.create(familyName, textStype);
                textOptions.typeface(typeface);
            }
        }
    }

    @Override
    public void clean() {
        super.clean();
    }

    /**
     * 更新Text属性
     *
     * @param argument
     * @return
     */
    private boolean updateMember(Map<String, Object> argument) {
        if (null == argument) {
            return false;
        }

        final String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            return false;
        }

        if (mOverlayMap == null || !mOverlayMap.containsKey(id)) {
            return false;
        }

        Text text = (Text) mOverlayMap.get(id);
        if (null == text) {
            return false;
        }

        String member = new TypeConverter<String>().getValue(argument, "member");
        if (TextUtils.isEmpty(member)) {
            return false;
        }

        String colorStr;
        int color;
        boolean ret = false;
        switch (member) {
            case "visible":
                Boolean visible = (Boolean) argument.get("value");
                if (null == visible) {
                    break;
                }

                text.setVisible(visible);
                ret = true;
                break;
            case "text":
                String textStr = (String) argument.get("value");
                if (null == textStr) {
                    break;
                }

                text.setText(textStr);
                ret = true;
                break;
            case "position":
                Map<String, Object> positionMap = (Map<String, Object>) argument.get("value");
                LatLng position = FlutterDataConveter.mapToLatlng(positionMap);
                if (null == position) {
                    break;
                }

                text.setPosition(position);
                ret = true;
                break;
            case "bgColor":
                colorStr = (String) argument.get("value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                text.setBgColor(color);
                ret = true;
                break;
            case "fontColor":
                colorStr = (String) argument.get("value");
                if (TextUtils.isEmpty(colorStr)) {
                    break;
                }

                color = FlutterDataConveter.strColorToInteger(colorStr);
                text.setFontColor(color);
                ret = true;
                break;
            case "fontSize":
                Integer fontSize = (Integer) argument.get("value");
                if (null == fontSize) {
                    break;
                }

                text.setFontSize(fontSize);
                ret = true;
                break;
            case "typeFace":
                Map<String, Object> typeFaceMap = (Map<String, Object>) argument.get("value");
                if (null == typeFaceMap) {
                    break;
                }

                String familyName = (String) typeFaceMap.get("familyName");
                Integer textStype = (Integer) typeFaceMap.get("textStype");
                if (TextUtils.isEmpty(familyName) || textStype < 0 || textStype > 4) {
                    break;
                }

                Typeface typeface = Typeface.create(familyName, textStype);
                text.setTypeface(typeface);
                ret = true;
                break;
            case "align":
                Integer alignX = (Integer) argument.get("alignX");
                Integer alignY = (Integer) argument.get("alignY");
                if (null == alignX || null == alignY) {
                    break;
                }

                text.setAlign(alignX, alignY);
                ret = true;
                break;
            case "rotate":
                Double rotate = (Double) argument.get("value");
                if (null == rotate) {
                    break;
                }

                text.setRotate(rotate.floatValue());
                ret = true;
                break;
            default:
                break;
        }

        return ret;
    }
}
