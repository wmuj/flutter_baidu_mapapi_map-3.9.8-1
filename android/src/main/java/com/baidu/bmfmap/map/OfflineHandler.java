package com.baidu.bmfmap.map;


import android.text.TextUtils;

import com.baidu.bmfmap.utils.Constants;
import com.baidu.mapapi.map.offline.MKOLSearchRecord;
import com.baidu.mapapi.map.offline.MKOLUpdateElement;
import com.baidu.mapapi.map.offline.MKOfflineMap;
import com.baidu.mapapi.map.offline.MKOfflineMapListener;
import com.baidu.mapapi.model.LatLng;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

/**
 * 离线地图handler
 */
public class OfflineHandler implements MethodChannel.MethodCallHandler {
    private MKOfflineMap mMKOfflineMap;
    private MethodChannel channel;

    public void init(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "flutter_bmfmap/offlineMap");
        channel.setMethodCallHandler(this);
    }

    public void unInit(BinaryMessenger messenger) {

    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        if (null == call) {
            return;
        }
        String methodId = call.method;
        if (TextUtils.isEmpty(methodId)) {
            return;
        }

        switch (methodId) {
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapInitOfflineMethod:
                initOfflineMap(result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapStartOfflineMethod:
                statOfflineMap(call,result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapPauseOfflineMethod:
                pauseOfflineMap(call,result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapRemoveOfflineMethod:
                removeOfflineMap(call,result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapUpdateOfflineMethod:
                updateOffline(call,result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapDestroyOfflineMethod:
                destroyOffline(result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapGetHotCityListMethod:
                getHotCityList(result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapGetOfflineCityListMethod:
                getOfflineCityList(result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapSearchCityMethod:
                seachCityList(call, result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapGetAllUpdateInfoMethod:
                getAllUpdateInfo(result);
                break;
            case Constants.MethodProtocol.BMFOfflineMethodId.sMapGetUpdateInfoMethod:
                getUpdateInfo(call,result);
                break;
            default:
                break;
        }
    }

    /**
     * 初始化
     */
    private void initOfflineMap(MethodChannel.Result result) {
        mMKOfflineMap = new MKOfflineMap();

        mMKOfflineMap.init(new MKOfflineMapListener() {

            @Override
            public void onGetOfflineMapState(int type, int state) {
                HashMap hashMap = new HashMap();
                hashMap.put("type",type);
                hashMap.put("state",state);
                channel.invokeMethod(Constants.MethodProtocol.BMFOfflineMethodId.sMapOfflineCallBackMethod,hashMap);
            }
        });
        result.success(true);
    }

    /**
     * 销毁离线地图管理模块，不用时调用
     */
    private void destroyOffline(MethodChannel.Result result) {
        if (null == mMKOfflineMap) {
            result.success(false);
            return;
        }
        mMKOfflineMap.destroy();
        result.success(true);
    }

    /**
     * 启动更新指定城市ID的离线地图
     */
    private void updateOffline(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mMKOfflineMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("cityID")) {
            result.success(false);
            return;
        }
        Integer cityID = (Integer) argument.get("cityID");
        if (null != cityID) {
            boolean update = mMKOfflineMap.update(cityID);
            result.success(update);
        }
    }

    /**
     * 删除指定城市ID的离线地图
     */
    private void removeOfflineMap(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mMKOfflineMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("cityID")) {
            result.success(false);
            return;
        }

        Integer cityID = (Integer) argument.get("cityID");
        if (null != cityID) {
            boolean remove = mMKOfflineMap.remove(cityID);
            result.success(remove);
        }
    }

    /**
     * 暂停下载或更新指定城市ID的离线地图
     */
    private void pauseOfflineMap(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mMKOfflineMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("cityID")) {
            result.success(false);
            return;
        }

        Integer cityID = (Integer) argument.get("cityID");
        if (null != cityID) {
            boolean pause = mMKOfflineMap.pause(cityID);
            result.success(pause);
        }

    }

    /**
     * 启动下载指定城市ID的离线地图，或在暂停更新某城市后继续更新下载某城市离线地图
     */
    private void statOfflineMap(MethodCall call,MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mMKOfflineMap) {
            result.success(false);
            return;
        }
        if (!argument.containsKey("cityID")) {
            result.success(false);
            return;
        }

        Integer cityID = (Integer) argument.get("cityID");
        if (null != cityID) {
            boolean start = mMKOfflineMap.start(cityID);
            result.success(start);
        }
    }

    /**
     * 返回指定城市ID离线地图更新信息
     */
    private void getUpdateInfo(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mMKOfflineMap) {
            result.success(null);
            return;
        }

        if (!argument.containsKey("cityID")) {
            result.success(null);
            return;
        }

        Integer id = (Integer) argument.get("cityID");
        MKOLUpdateElement updateInfo = mMKOfflineMap.getUpdateInfo(id);
        if (null != id && null != updateInfo) {
            Map map = new HashMap();
            int cityID = updateInfo.cityID;
            int ratio = updateInfo.ratio;
            int status = updateInfo.status;
            String cityName = updateInfo.cityName;
            int size = updateInfo.size;
            int serversize = updateInfo.serversize;
            int level = updateInfo.level;
            boolean update = updateInfo.update;
            LatLng latLng = updateInfo.geoPt;
            HashMap<String, Double> geoPt = new HashMap<>();
            geoPt.put("latitude", latLng.latitude);
            geoPt.put("longitude", latLng.longitude);
            map.put("cityID", cityID);
            map.put("ratio", ratio);
            map.put("status", status);
            map.put("cityName", cityName);
            map.put("geoPt", geoPt);
            map.put("size", size);
            map.put("serversize", serversize);
            map.put("level", level);
            map.put("update", update);
            result.success(map);
        } else {
            result.success(null);
            return;
        }
    }

    /**
     * 返回各城市离线地图更新信息
     */
    private void getAllUpdateInfo(MethodChannel.Result result) {
        if (null == mMKOfflineMap) {
            result.success(null);
            return;
        }
        ArrayList<MKOLUpdateElement> allUpdateInfo = mMKOfflineMap.getAllUpdateInfo();
        if (null ==  allUpdateInfo || allUpdateInfo.size() == 0) {
            result.success(null);
            return;
        }
        ArrayList<Map> arrayMap = new ArrayList<>();

        HashMap<String, ArrayList> offlineCityMap = new HashMap<>();
        for (int i = 0; i < allUpdateInfo.size(); i++) {
            Map map = new HashMap();
            int cityID = allUpdateInfo.get(i).cityID;
            int ratio = allUpdateInfo.get(i).ratio;
            String cityName = allUpdateInfo.get(i).cityName;
            int size = allUpdateInfo.get(i).size;
            int serversize = allUpdateInfo.get(i).serversize;
            int level = allUpdateInfo.get(i).level;
            boolean update = allUpdateInfo.get(i).update;
            LatLng latLng = allUpdateInfo.get(i).geoPt;
            HashMap<String, Double> geoPt = new HashMap<>();
            geoPt.put("latitude",latLng.latitude);
            geoPt.put("longitude",latLng.longitude);
            map.put("cityID",cityID);
            map.put("ratio",ratio);
            map.put("cityName",cityName);
            map.put("geoPt",geoPt);
            map.put("size",size);
            map.put("serversize",serversize);
            map.put("level",level);
            map.put("update",update);
            arrayMap.add(map);
        }
        offlineCityMap.put("updateElements", arrayMap);
        result.success(offlineCityMap);
    }

    /**
     * 根据城市名搜索该城市离线地图记录
     */
    private void seachCityList(MethodCall call,MethodChannel.Result result) {
        if (null == mMKOfflineMap) {
            result.success(null);
            return;
        }
        Map<String, Object> argument = call.arguments();
        if (null == argument || null == mMKOfflineMap) {
            result.success(null);
            return;
        }

        if (!argument.containsKey("cityName")) {
            result.success(null);
            return;
        }

        String  sCityName = (String) argument.get("cityName");
        if (null == sCityName) {
            result.success(null);
            return;
        }
        ArrayList<MKOLSearchRecord> seachCityList = mMKOfflineMap.searchCity(sCityName);
        if (null == seachCityList){
            result.success(null);
            return;
        }
        ArrayList<Map> arrayMap = new ArrayList<>();
        HashMap<String, ArrayList> offlineCityMap = new HashMap<>();
        for (int i = 0; i < seachCityList.size(); i++) {
            Map map = new HashMap();
            int cityID = seachCityList.get(i).cityID;
            int cityType = seachCityList.get(i).cityType;
            int dataSize = (int) seachCityList.get(i).dataSize;
            String cityName = seachCityList.get(i).cityName;
            ArrayList<MKOLSearchRecord> childCities = seachCityList.get(i).childCities;
            ArrayList<Map> childArray = new ArrayList<>();
            if (null != childCities && childCities.size() > 0) {
                for (int j = 0; j < childCities.size(); j++) {
                    HashMap childMap = new HashMap();
                    int childCityID = childCities.get(j).cityID;
                    int childCityType = childCities.get(j).cityType;
                    int childDataSize = (int) childCities.get(j).dataSize;
                    String childCityName = childCities.get(j).cityName;
                    childMap.put("cityID",childCityID);
                    childMap.put("cityType",childCityType);
                    childMap.put("dataSize",childDataSize);
                    childMap.put("cityName",childCityName);
                    childArray.add(childMap);
                }
            }
            map.put("cityID",cityID);
            map.put("dataSize",dataSize);
            map.put("cityName",cityName);
            map.put("cityType",cityType);
            map.put("childCities",childArray);
            arrayMap.add(map);
        }
        offlineCityMap.put("searchCityRecord", arrayMap);
        result.success(offlineCityMap);
    }

    /**
     * 返回热门城市列表
     */
    private void getHotCityList(MethodChannel.Result result) {
        if (null == mMKOfflineMap) {
            result.success(null);
            return;
        }
        ArrayList<MKOLSearchRecord> hotCityList = mMKOfflineMap.getHotCityList();
        if (null == hotCityList){
            result.success(null);
            return;
        }
        ArrayList<Map> arrayMap = new ArrayList<>();
        HashMap<String, ArrayList> hotCityMap = new HashMap<>();
        for (int i = 0; i < hotCityList.size(); i++) {
            Map map = new HashMap();
            int cityID = hotCityList.get(i).cityID;
            int cityType = hotCityList.get(i).cityType;
            int dataSize = (int) hotCityList.get(i).dataSize;
            String cityName = hotCityList.get(i).cityName;
            ArrayList<MKOLSearchRecord> childCities = hotCityList.get(i).childCities;
            ArrayList<Map> childArray = new ArrayList<>();
            if (null != childCities && childCities.size() > 0) {
                for (int j = 0; j < childCities.size(); j++) {
                    HashMap childMap = new HashMap();
                    int childCityID = childCities.get(j).cityID;
                    int childCityType = childCities.get(j).cityType;
                    int childDataSize = (int) childCities.get(j).dataSize;
                    String childCityName = childCities.get(j).cityName;
                    childMap.put("cityID",childCityID);
                    childMap.put("cityType",childCityType);
                    childMap.put("dataSize",childDataSize);
                    childMap.put("cityName",childCityName);
                    childArray.add(childMap);
                }
            }
            map.put("cityID",cityID);
            map.put("dataSize",dataSize);
            map.put("cityName",cityName);
            map.put("cityType",cityType);
            map.put("childCities",childArray);
            arrayMap.add(map);
        }
        hotCityMap.put("searchCityRecord", arrayMap);
        result.success(hotCityMap);
    }

    /**
     * 返回支持离线地图城市列表
     */
    private void getOfflineCityList(MethodChannel.Result result) {
        if (null == mMKOfflineMap) {
            result.success(null);
            return;
        }
        ArrayList<MKOLSearchRecord> offlineCityList = mMKOfflineMap.getOfflineCityList();
        if (null == offlineCityList){
            result.success(null);
            return;
        }
        ArrayList<Map> arrayMap = new ArrayList<>();
        HashMap<String, ArrayList> offlineCityMap = new HashMap<>();
        for (int i = 0; i < offlineCityList.size(); i++) {
            Map map = new HashMap();
            int cityID = offlineCityList.get(i).cityID;
            int cityType = offlineCityList.get(i).cityType;
            int dataSize = (int) offlineCityList.get(i).dataSize;
            String cityName = offlineCityList.get(i).cityName;
            ArrayList<MKOLSearchRecord> childCities = offlineCityList.get(i).childCities;
            ArrayList<Map> childArray = new ArrayList<>();
            if (null != childCities && childCities.size() > 0) {
                for (int j = 0; j < childCities.size(); j++) {
                    HashMap childMap = new HashMap();
                    int childCityID = childCities.get(j).cityID;
                    int childCityType = childCities.get(j).cityType;
                    int childDataSize = (int) childCities.get(j).dataSize;
                    String childCityName = childCities.get(j).cityName;
                    childMap.put("cityID",childCityID);
                    childMap.put("cityType",childCityType);
                    childMap.put("dataSize",childDataSize);
                    childMap.put("cityName",childCityName);
                    childArray.add(childMap);
                }
            }
            map.put("cityID",cityID);
            map.put("dataSize",dataSize);
            map.put("cityName",cityName);
            map.put("cityType",cityType);
            map.put("childCities",childArray);
            arrayMap.add(map);
        }
        offlineCityMap.put("searchCityRecord", arrayMap);
        result.success(offlineCityMap);
    }
}
