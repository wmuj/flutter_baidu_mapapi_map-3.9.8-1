package com.baidu.bmfmap.map.overlayhandler;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.baidu.bmfmap.BMFMapController;
import com.baidu.bmfmap.utils.Constants;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.ArclineProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.CirclelineProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.DotProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.GroundProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.OverlayProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.PolygonProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.PolylineProtocol;
import com.baidu.bmfmap.utils.Constants.MethodProtocol.TextProtocol;
import com.baidu.bmfmap.utils.Constants.OverlayHandlerType;
import com.baidu.bmfmap.utils.Env;
import com.baidu.bmfmap.utils.converter.TypeConverter;
import com.baidu.mapapi.map.Overlay;

import android.text.TextUtils;
import android.util.Log;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class OverlayHandlerFactory {
    private static final String TAG = "OverlayHandlerFactory";

    private HashMap<Integer, OverlayHandler> overlayHandlerHashMap;

    private BMFMapController mBmfMapController;
    
    public OverlayHandlerFactory(BMFMapController bmfMapController) {
        init(bmfMapController);
    }

    private void init(BMFMapController bmfMapController) {
        if (null == bmfMapController) {
            return;
        }

        mBmfMapController = bmfMapController;
        
        overlayHandlerHashMap = new HashMap<>();
//        overlayHandlerHashMap
//                .put(OverlayHandlerType.OVERLAY_COMMON_HANDLER, new OverlayHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.CIRCLE_HANDLER, new CircleHandler(bmfMapController));
        overlayHandlerHashMap.put(OverlayHandlerType.DOT_HANDLER, new DotHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.POLYGON_HANDLER, new PolygonHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.POLYLINE_HANDLER, new PolylineHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.TEXT_HANDLER, new TextHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.ARCLINE_HANDLER, new ArcLineHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.GROUND_HANDLER, new GroundHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.INFOWINDOW_HANDLER,
                        new InfoWindowHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.MARKER_HANDLER, new MarkerHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.PRISM_HANDLER, new BuildingHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.BM3DMODEL_HANDLER, new BM3DModelHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.MULTIPOINT_HANDLER, new MultiPointHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.TRACE_HANDLER, new TraceHandler(bmfMapController));
        overlayHandlerHashMap
                .put(OverlayHandlerType.CLUSTER_HANDLER, new MarkerClusterHandler(bmfMapController));
    }

    public boolean dispatchMethodHandler(MethodCall call, MethodChannel.Result result) {
        if (null == call) {
            if (Env.DEBUG) {
                Log.d(TAG, "dispatchMethodHandler: null == call");
            }
            return false;
        }

        String methodId = call.method;
        if (Env.DEBUG) {
            Log.d(TAG, "dispatchMethodHandler: " + methodId);
        }
        OverlayHandler overlayHandler = null;
        switch (methodId) {
            case Constants.MethodProtocol.MarkerProtocol.sMapAddMarkerMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapAddMarkersMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapRemoveMarkerMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapRemoveMarkersMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapDidSelectMarkerMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapDidDeselectMarkerMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapCleanAllMarkersMethod:
            case Constants.MethodProtocol.MarkerProtocol.sMapUpdateMarkerMemberMethod:
                overlayHandler =
                        overlayHandlerHashMap.get(OverlayHandlerType.MARKER_HANDLER);
                break;
            case Constants.MethodProtocol.InfoWindowProtocol.sAddInfoWindowMapMethod:
            case Constants.MethodProtocol.InfoWindowProtocol.sRemoveInfoWindowMapMethod:
            case Constants.MethodProtocol.InfoWindowProtocol.sAddInfoWindowsMapMethod:
                overlayHandler =
                        overlayHandlerHashMap.get(OverlayHandlerType.INFOWINDOW_HANDLER);
                break;
            case Constants.MethodProtocol.ClusterProtocol.SET_CLUSTER_MARKER_COORDINATE_METHOD:
            case Constants.MethodProtocol.ClusterProtocol.SET_MAX_DISTANCE_ZOOM_METHOD:
            case Constants.MethodProtocol.ClusterProtocol.CLEAN_CLUSTER_METHOD:
            case Constants.MethodProtocol.ClusterProtocol.UPDATE_CLUSTERS_METHOD:
            case Constants.MethodProtocol.ClusterProtocol.GET_CLUSTER_ON_ZOOM_LEVEL_METHOD:
            case Constants.MethodProtocol.ClusterProtocol.SET_CLUSTER_VISIBLE_METHOD:
            case Constants.MethodProtocol.ClusterProtocol.GET_CLUSTER_VISIBLE_METHOD:
                overlayHandler =
                        overlayHandlerHashMap.get(OverlayHandlerType.CLUSTER_HANDLER);
                break;
            case ArclineProtocol.sMapAddArclinelineMethod:
            case ArclineProtocol.sMapUpdateArclineMemberMethod:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.ARCLINE_HANDLER);
                break;
            case PolygonProtocol.sMapAddPolygonMethod:
            case PolygonProtocol.sMapUpdatePolygonMemberMethod:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.POLYGON_HANDLER);
                break;
            case CirclelineProtocol.sMapAddCirclelineMethod:
            case CirclelineProtocol.sMapUpdateCircleMemberMethod:
            case CirclelineProtocol.MAP_ADD_GRADIENT_CIRCLE_METHOD:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.CIRCLE_HANDLER);
                break;
            case PolylineProtocol.sMapAddPolylineMethod:
            case PolylineProtocol.sMapUpdatePolylineMemberMethod:
            case PolylineProtocol.MAP_ADD_GEODESIC_LINE_METHOD:
            case PolylineProtocol.MAP_ADD_GRADIENT_LINE_METHOD:
            case PolylineProtocol.MAP_UPDATE_GEODESIC_LINE_MEMBER_METHOD:
            case PolylineProtocol.MAP_UPDATE_GRADIENT_LINE_MEMBER_METHOD:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.POLYLINE_HANDLER);
                break;
            case DotProtocol.sMapAddDotMethod:
            case DotProtocol.sMapUpdateDotMemberMethod:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.DOT_HANDLER);
                break;
            case TextProtocol.sMapAddTextMethod:
            case TextProtocol.sMapUpdateTextMemberMethod:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.TEXT_HANDLER);
                break;
            case GroundProtocol.sMapAddGroundMethod:
            case GroundProtocol.sMapUpdateGroundMemberMethod:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.GROUND_HANDLER);
                break;
            case Constants.MethodProtocol.PrismProtocol.MAP_ADD_PRISM_OVERLAY_METHOD:
            case Constants.MethodProtocol.PrismProtocol.MAP_UPDATE_PRISM_OVERLAY_MEMBER_METHOD:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.PRISM_HANDLER);
                break;
            case Constants.MethodProtocol.BM3DModelProtocol.MAP_ADD_3DMODEL_OVERLAY_METHOD:
            case Constants.MethodProtocol.BM3DModelProtocol.MAP_UPDATE_3DMODEL_OVERLAY_MEMBER_METHOD:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.BM3DMODEL_HANDLER);
                break;
            case Constants.MethodProtocol.MultiPointProtocol.MAP_ADD_MULTIPOINT_OVERLAY_METHOD:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.MULTIPOINT_HANDLER);
                break;
            case Constants.MethodProtocol.TraceProtocol.MAP_ADD_TRACE_OVERLAY_METHOD:
            case Constants.MethodProtocol.TraceProtocol.MAP_REMOVE_TRACE_OVERLAY_METHOD:
            case Constants.MethodProtocol.TraceProtocol.MAP_PAUSE_TRACE_OVERLAY_METHOD:
            case Constants.MethodProtocol.TraceProtocol.MAP_RESUME_TRACE_OVERLAY_METHOD:
                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.TRACE_HANDLER);
                break;
            case OverlayProtocol.sMapRemoveOverlayMethod:
//                overlayHandler = overlayHandlerHashMap.get(OverlayHandlerType.OVERLAY_COMMON_HANDLER);
                removeOneOverLayById(call, result);
                break;
            case OverlayProtocol.MAP_REMOVE_ALL_OVERLAY_METHOD:
                if (mBmfMapController != null && mBmfMapController.getBaiduMap() != null) {
                    mBmfMapController.getBaiduMap().clear();
                }
                break;
            default:
                break;
        }

        if (null == overlayHandler) {
            return false;
        }

        overlayHandler.handlerMethodCall(call, result);
        return true;
    }

    public boolean removeOneOverLayById(MethodCall call, MethodChannel.Result result) {
        Map<String, Object> argument = call.arguments();

        if (argument == null) {
            result.success(false);
            return false;
        }
        String id = new TypeConverter<String>().getValue(argument, "id");
        if (TextUtils.isEmpty(id)) {
            result.success(false);
            return false;
        }

        Overlay overlay = mBmfMapController.mOverlayIdMap.get(id);
        if (null == overlay) {
            if (Env.DEBUG) {
                Log.d(TAG, "not found overlay with id:" + id);
            }
            result.success(false);
            return false;
        }

        overlay.remove();
        result.success(true);
        
        if (Env.DEBUG) {
            Log.d(TAG, "remove Overlay success");
        }
        
        return true;
    }

    public void release() {
        if (null == overlayHandlerHashMap || overlayHandlerHashMap.size() == 0) {
            return;
        }

        OverlayHandler overlayHandler = null;
        Iterator iterator = overlayHandlerHashMap.values().iterator();
        while (iterator.hasNext()) {
            overlayHandler = (OverlayHandler) iterator.next();
            if (null == overlayHandler) {
                continue;
            }

            overlayHandler.clean();
        }
    }

}