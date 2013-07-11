/**
 * AppError.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-11
 */
package com.comger.migrant;

import java.lang.Thread.UncaughtExceptionHandler;

import android.util.Log;

/**
 * @author comger
 *
 */
public class AppError extends Throwable implements UncaughtExceptionHandler {

	private final static boolean Debug = false;//是否保存错误日志
	
	private static final long serialVersionUID = 1L;
    private String mFailingUrl;
    private Exception e = null;
    @SuppressWarnings("rawtypes")
	private Class cls = null;
    
	/** 系统默认的UncaughtException处理类 */
	private Thread.UncaughtExceptionHandler mDefaultHandler;
	
    
    /**
     * 简单异常信息提示
     * @param message
     */
    public AppError(String message){
    	super(message);
    	this.mDefaultHandler = Thread.getDefaultUncaughtExceptionHandler();
    }
    
    /**
     * 请求服务失败，无法接连网络
     * @param message
     * @param e
     * @param failingUrl
     */
    public AppError(String message, Exception e, String failingUrl){
    	 super(message);
    	 this.e = e;
    	 this.cls = e.getClass();
    	 
    	 mFailingUrl = failingUrl;
    	 Log.i("AppError", "when open url "+failingUrl + " error is:"+ message);
    }
    
    /**
     * 请求服务出错
     * @param message
     * @param failingUrl 接口地址
     */
    public AppError(String message, String failingUrl) {
        super(message);
        mFailingUrl = failingUrl;
        Log.i("AppError", "when open url "+failingUrl + " error is:"+ message);
    }
    
	@Override
	public void uncaughtException(Thread thread, Throwable ex) {
		// TODO Auto-generated method stub

	}
	
    public Exception getException(){
    	return this.e;
    }
    
    @SuppressWarnings("rawtypes")
	public Class getExceptionClass(){
    	return this.cls;
    }
    
    public String getFailingUrl(){
    	return mFailingUrl;
    }

}
