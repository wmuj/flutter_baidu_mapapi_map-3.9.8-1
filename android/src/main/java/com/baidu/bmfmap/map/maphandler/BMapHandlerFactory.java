package com.baidu.bmfmap.map.maphandler;

import java.util.HashMap;
import java.util.Iterator;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.CustomMapProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.HeatMapProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.MapStateProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.ProjectionMethodId;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.TileMapProtocol;
import com.baidu.bmfmap.utils.Env;

import android.content.Context;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class BMapHandlerFactory {

    private HashMap<Integer, BMapHandler> mMapHandlerHashMap;

    public BMapHandlerFactory(BMFMapController bmfMapController) {
        init(bmfMapController);
    }

    private void init(BMFMapController bmfMapController) {
        if (mMapHandlerHashMap == null) {
            mMapHandlerHashMap = new HashMap<>();
        }
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.CUSTOM_MAP, new CustomMapHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.PROJECTION, new ProjectionHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.MAP_STATE, new MapStateHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.INDOOR_MAP, new IndoorMapHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.MAP_UPDATE, new MapUpdateHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.HEAT_MAP, new HeatMapHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.TILE_MAP, new TileMapHandler(bmfMapController));
        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.PARTICLE, new ParticleMapHandler(bmfMapController));

        mMapHandlerHashMap
                .put(Constants.BMapHandlerType.LOCATION_LAYER,
                        new LocationLayerHandler(bmfMapController));
    }

    public void dispatchMethodHandler(Context context, MethodCall call,
                                      MethodChannel.Result result) {
        if (null == call) {
            return;
        }

        String methodId = call.method;
        if (Env.DEBUG) {
            Log.d("BMapHandlerFactory", "dispatchMethodHandler: " + methodId);
        }
        BMapHandler bMapHandler = null;
        switch (methodId) {
            case CustomMapProtocol.sMapSetCustomMapStyleEnableMethod:
            case CustomMapProtocol.sMapSetCustomMapStylePathMethod:
            case CustomMapProtocol.sMapSetCustomMapStyleWithOptionMethod:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.CUSTOM_MAP);
                break;
            case Constants.MethodProtocol.IndoorMapProtocol.sShowBaseIndoorMapMethod:
            case Constants.MethodProtocol.IndoorMapProtocol.sShowBaseIndoorMapPoiMethod:
            case Constants.MethodProtocol.IndoorMapProtocol.sSwitchBaseIndoorMapFloorMethod:
            case Constants.MethodProtocol.IndoorMapProtocol.sGetFocusedBaseIndoorMapInfoMethod:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.INDOOR_MAP);
                break;
            case MapStateProtocol.sMapUpdateMethod:
            case MapStateProtocol.sMapSetVisibleMapBoundsMethod:
            case MapStateProtocol.sMapSetVisibleMapBoundsWithPaddingMethod:
            case MapStateProtocol.sMapSetCompassImageMethod:
            case MapStateProtocol.sMapSetCustomTrafficColorMethod:
            case MapStateProtocol.sMapTakeSnapshotMethod:
            case MapStateProtocol.sMapTakeSnapshotWithRectMethod:
            case MapStateProtocol.sMapDidUpdateWidget:
            case MapStateProtocol.sMapReassemble:
            case MapStateProtocol.MAP_COPYRINGHT_INFO:
            case MapStateProtocol.MAP_MAPPING_QUALIFICATION:
            case MapStateProtocol.MAP_APPROVAL_NUMBER:
            case MapStateProtocol.MAP_REFRESH:
            case MapStateProtocol.MAP_OVERLAY_UPGRADE:
            case MapStateProtocol.MAP_IS_OVERLAY_UPGRADE:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.MAP_STATE);
                break;
            case MapStateProtocol.sMapZoomInMethod:
            case MapStateProtocol.sMapZoomOutMethod:
            case MapStateProtocol.sMapSetCenterCoordinateMethod:
            case MapStateProtocol.sMapSetCenterZoomMethod:
            case MapStateProtocol.sMapSetMapStatusMethod:
            case MapStateProtocol.sMapSetScrollByMethod:
            case MapStateProtocol.sMapSetZoomByMethod:
            case MapStateProtocol.sMapSetZoomPointByMethod:
            case MapStateProtocol.sMapSetZoomToMethod:
            case MapStateProtocol.sMapGetMapStatusMethod:
            case MapStateProtocol.SWITCH_OVERLAY_LAYER_AND_POI_LAYER:
            case MapStateProtocol.SWITCH_OVERLAY_LAYER_AND_POI_TAG_TYPE:
            case MapStateProtocol.SWITCH_LAYER_ORDER:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.MAP_UPDATE);
                break;
            case HeatMapProtocol.sMapAddHeatMapMethod:
            case HeatMapProtocol.sMapRemoveHeatMapMethod:
            case HeatMapProtocol.sShowHeatMapMethod:
            case HeatMapProtocol.sStartHeatFrameAnimationMethod:
            case HeatMapProtocol.sStopHeatFrameAnimationMethod:
            case HeatMapProtocol.sSetHeatFrameAnimationIndexMethod:
            case HeatMapProtocol.MAP_UPDATE_HEATMAP_METHOD:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.HEAT_MAP);
                break;
            case TileMapProtocol.sAddTileMapMethod:
            case TileMapProtocol.sRemoveTileMapMethod:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.TILE_MAP);
                break;
            case Constants.LocationLayerMethodId.sMapShowUserLocationMethod:
            case Constants.LocationLayerMethodId.sMapUpdateLocationDataMethod:
            case Constants.LocationLayerMethodId.sMapUserTrackingModeMethod:
            case Constants.LocationLayerMethodId.sMapUpdateLocationDisplayParamMethod:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.LOCATION_LAYER);
                break;
            case ProjectionMethodId.sFromScreenLocation:
            case ProjectionMethodId.sToScreenLocation:
            case ProjectionMethodId.SCREEN_POINT_FROM_MAP_POINT_3METHOD:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.PROJECTION);
                break;
            case Constants.MethodProtocol.ParticleMethodId.SHOW_MAP_PARTICLE_METHOD:
            case Constants.MethodProtocol.ParticleMethodId.CLOSE_MAP_PARTICLE_METHOD:
            case Constants.MethodProtocol.ParticleMethodId.CUSTOM_MAP_PARTICLE_METHOD:
                bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.PARTICLE);
                break;
            default:
                if (methodId.startsWith("flutter_bmfmap/map/get")) {
                    bMapHandler = mMapHandlerHashMap.get(Constants.BMapHandlerType.MAP_UPDATE);
                }
                break;
        }

        if (null == bMapHandler) {
            return;
        }

        bMapHandler.handlerMethodCallResult(context, call, result);
    }

    public void release() {
        if (null == mMapHandlerHashMap || mMapHandlerHashMap.size() == 0) {
            return;
        }

        BMapHandler bMapHandler = null;
        Iterator iterator = mMapHandlerHashMap.values().iterator();
        while (iterator.hasNext()) {
            bMapHandler = (BMapHandler) iterator.next();
            if (null == bMapHandler) {
                continue;
            }

            bMapHandler.clean();
        }
    }
}
