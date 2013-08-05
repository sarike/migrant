/**
 * MigrantApi.java
 * 
 * @user comger
 * @mail comger@gmail.com 2013-7-17
 */
package com.comger.migrant.api;

import java.io.InputStream;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.comger.migrant.AppContext;
import com.comger.migrant.AppException;

/**
 * @author comger
 *
 */
public class MigrantApi extends ApiClient {

	static JSONObject _post(String api, Map<String, Object> params) throws AppException {
		InputStream is = _post(AppContext.mContext, ApiUrls.Host + api, params, null);
		return parseResult(is);
	}

	static JSONObject _get(String api, Map<String, Object> params) throws AppException {
		InputStream is = http_get(AppContext.mContext, ApiUrls.Host + api);
		return parseResult(is);
	}

	/**
	 * 用户登录
	 * @param username
	 * @param password
	 * @return
	 * @throws AppException
	 * @throws JSONException 
	 */
	public static JSONObject accountLogin(String username, String password) throws AppException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("username", username);
		params.put("password", password);

		return _post(ApiUrls.Login, params).getJSONObject("data");
	}

	public static JSONObject authLogin(String site, String otherid, String name) throws AppException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("site", site);
		params.put("otherid", otherid);
		params.put("name", name);

		return _post(ApiUrls.authLogin, params).getJSONObject("data");
	}

	public static JSONArray getCityList(String parent) throws AppException, JSONException {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("parent", parent);
		return _get(ApiUrls.cityList, params).getJSONArray("data");
	}

	public static JSONArray getHomeInformation() throws JSONException, AppException {
		return _get(ApiUrls.HomeList, null).getJSONArray("data");
	}
	
	public static JSONArray getMyInformation() throws JSONException, AppException {
		return _get(ApiUrls.MyList, null).getJSONArray("data");
	}
	
	public static JSONArray getCityInformation() throws JSONException, AppException {
		return _get(ApiUrls.CityList, null).getJSONArray("data");
	}
	
	public static JSONArray getCommentList(String informationID) throws JSONException, AppException {
		return _get(String.format("%s/%s", ApiUrls.CommentList,informationID), null).getJSONArray("data");
	}
	
	public static JSONArray getMyCommentList() throws JSONException, AppException {
		return _get(ApiUrls.MyCommentList, null).getJSONArray("data");
	}
}
