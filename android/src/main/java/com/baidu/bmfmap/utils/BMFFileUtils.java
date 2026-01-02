package com.baidu.bmfmap.utils;

import android.content.Context;
import android.text.TextUtils;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import io.flutter.FlutterInjector;


public class BMFFileUtils {

    private static BMFFileUtils mInstance;

    private Context mContext;

    private BMFFileUtils() {}

    public static BMFFileUtils getInstance() {
        if (mInstance == null) {
            synchronized (BMFFileUtils.class) {
                mInstance = new BMFFileUtils();
            }
        }

        return mInstance;
    }

    public void setContext(Context context) {
        mContext = context;
    }

    /**
     * 获取模型拷贝位置
     * @param path
     * @return
     */
    public String getDirPath(String path) {
        if (TextUtils.isEmpty(path) || mContext == null) {
            return null;
        }

        String parentPath = mContext.getCacheDir().getAbsolutePath();
        String resPath = FlutterInjector.instance().flutterLoader().getLookupKeyForAsset(path);
        String copyPath = parentPath + File.separator + resPath;

        copyFilesAssets(resPath, copyPath);
        return copyPath;
    }

    public String getCustomStyleFilePath(String customStyleFilePath) {
        if (mContext == null) {
            return null;
        }

        if (customStyleFilePath.isEmpty()) {
            return null;
        }

        FileOutputStream outputStream = null;
        InputStream inputStream = null;
        String parentPath = null;
        String customStyleFileName = customStyleFilePath;
        try {
            inputStream = mContext.getAssets().open(customStyleFileName);
            byte[] buffer = new byte[inputStream.available()];
            inputStream.read(buffer);

            parentPath = mContext.getCacheDir().getAbsolutePath();
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
     * 从assets目录中复制整个文件夹内容
     */
    public void copyFilesAssets(String path, String newPath) {
        if (TextUtils.isEmpty(path) || TextUtils.isEmpty(newPath) || mContext == null) {
            return;
        }

        try {
            // 获取assets目录下的所有文件及目录名
            String[] fileNames = mContext.getAssets().list(path);
            if (fileNames.length > 0) {  // 如果是目录
                for (int i = 0; i < fileNames.length; i++) {
                    String newAssetsPath = "";
                    // 确保assets后没有斜杠分隔
                    if ((path == null) || "".equals(path) || "/".equals(path)) {
                        newAssetsPath = fileNames[i];
                    } else {
                        if (path.endsWith("/")) {
                            newAssetsPath = path + fileNames[i];
                        } else {
                            newAssetsPath = path + File.separator + fileNames[i];
                        }
                    }

                    copyFilesAssets(newAssetsPath, newPath + File.separator + fileNames[i]);
                }
            } else {
                // 如果是文件
                getCustomStyleFilePath(path);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
