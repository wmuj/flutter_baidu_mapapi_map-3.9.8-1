package com.baidu.bmfmap.utils;

import android.os.Build;

import androidx.annotation.RequiresApi;

import java.io.Closeable;
import java.io.IOException;

/**
 * 用于安全的关闭closeable对象
 */
public class IOStreamUtils{
    public static void closeSilently(Closeable o){
        if(null == o){
            return;
        }

        try {
            o.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    public static void closeSilently(AutoCloseable o){
        if(null == o){
            return;
        }

        try {
            o.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}