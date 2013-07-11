/**
 * Main.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-9
 */
package com.comger.migrant.ui;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;

import com.comger.migrant.AppContext;
import com.comger.migrant.AppException;
import com.comger.migrant.R;
import com.comger.migrant.api.ApiClient;
import com.comger.migrant.common.AsyncRunner;
import com.comger.migrant.common.AsyncRunner.RequestListener;

/**
 * @author comger
 * 
 */
public class Main extends Activity {
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		AsyncRunner.run(new RequestListener() {
			
			@Override
			public void onRequesting() throws AppException, JSONException {
				// TODO Auto-generated method stub
				JSONObject json= ApiClient.login(AppContext.mContext);
				JSONArray array =  ApiClient.accountPage(AppContext.mContext);
				Log.i("login", ":"+json);
				Log.i("account", ":"+array);
			}
			
			@Override
			public void onReading() {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void onDone() {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void onAppError(AppException e) {
				Log.i("AppError", ":"+e.getMessage());
				
			}
		});
	}
}
