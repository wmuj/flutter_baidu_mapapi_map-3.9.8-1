package com.baidu.bmfmap.utils;

import android.os.Handler;
import android.os.Looper;

/**
 * Copyright (C) 2019 Baidu, Inc. All Rights Reserved.
 */
public class MapTaskManager {

    private static Handler mMainHandler = new Handler(Looper.getMainLooper());

    // 向主线程投递任务, delayMillis延时毫秒数
    public static void postToMainThread(Runnable runnable, long delayMillis) {
        mMainHandler.postDelayed(runnable, delayMillis);
    }

}
