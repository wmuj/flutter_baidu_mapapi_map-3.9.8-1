package com.baidu.bmfmap.utils;


import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.ScheduledFuture;
import java.util.concurrent.ScheduledThreadPoolExecutor;
import java.util.concurrent.ThreadFactory;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

public class ThreadPoolUtil {
    private ThreadFactory mThreadFactory = new ThreadFactory() {
        @Override
        public Thread newThread(Runnable r) {
            Thread t = new Thread(r,"mapThread"+mAtomicInteger.getAndIncrement());
            return t;
        }
    };

    private AtomicInteger mAtomicInteger = new AtomicInteger(0);

    private final int CORE_POOL_SIZE = Runtime.getRuntime().availableProcessors();

    private final int MAX_POLL_SIZE = CORE_POOL_SIZE*2;

    private final int KEEP_ALIVE = 3; //空线程alive时间

    private ExecutorService mExecutorService;

    private ScheduledExecutorService mScheduleExecutorService;

    private static volatile ThreadPoolUtil sInstance;

    public static ThreadPoolUtil getInstance(){
        if(null == sInstance){
            synchronized (ThreadPoolUtil.class){
                if(null == sInstance){
                    sInstance = new ThreadPoolUtil();
                }
            }
        }

        return sInstance;
    }

    public ThreadPoolUtil(){
        mExecutorService = new ThreadPoolExecutor(CORE_POOL_SIZE, MAX_POLL_SIZE, KEEP_ALIVE,
                TimeUnit.SECONDS,
                new ArrayBlockingQueue<Runnable>(1000),
                mThreadFactory, new ThreadPoolExecutor.DiscardOldestPolicy());

        mScheduleExecutorService = new ScheduledThreadPoolExecutor(CORE_POOL_SIZE, mThreadFactory);
    }

    public void execute(Runnable runnable){
        if(null == mExecutorService){
            return;
        }

        mExecutorService.execute(runnable);
    }

    public ScheduledFuture execute(Runnable runnable, int delayTime){
        if(null == mScheduleExecutorService){
            return null;
        }

        return mScheduleExecutorService.schedule(runnable, delayTime, TimeUnit.MILLISECONDS);
    }

}
