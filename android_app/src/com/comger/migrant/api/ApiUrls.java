/**
 * ApiUrls.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-11
 */
package com.comger.migrant.api;

/**
 * @author comgeru
 *
 */
public class ApiUrls {
	
	//public static String Host = "http://172.16.20.3:8888";
	public static String Host = "http://112.124.38.112:8888";

	public static String Login = "/m/account/login";
	public static String authLogin = "/m/auth/login";
	public static String accountInfo = "/m/account/info";
	public static String cityList = "/m/city/list";
	
	public static String SendInformation="/m/post/create";//发送资讯
	public static String HomeList = "/m/post/home";//综合信息
	public static String MyList = "/m/post/my";//我的信息
	public static String CityList = "/m/post/city";//城市信息
	
	public static String SendComment="/m/comment/create";
	public static String CommentList="/m/comment/postlist";
	public static String MyCommentList="/m/comment/userlist";
	
	public static String cityReport="/m/report/city";
	public static String cityReporthome="/m/report/city";
	
	
}
