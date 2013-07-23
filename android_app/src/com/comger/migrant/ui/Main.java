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
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.comger.migrant.AppContext;
import com.comger.migrant.AppException;
import com.comger.migrant.R;
import com.comger.migrant.api.MigrantApi;
import com.comger.migrant.common.AsyncRunner;
import com.comger.migrant.common.BaseRequestListener;

/**
 * @author comger
 * 
 */
public class Main extends Activity  {
	LinearLayout citylist = null;
	JSONArray array = null;
	
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (msg.arg1 == 1) {
				loadcity();
			}else if(msg.arg1 ==2){
				for(int i=0;i<array.length();i++){
					try{
						String name = array.getJSONObject(i).getString("name");
						TextView tv = new TextView(AppContext.mContext);
						tv.setText(name);
						citylist.addView(tv);
					}catch (Exception e) {
						// TODO: handle exception
					}

				}
			}
			
		}
	};
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		citylist = (LinearLayout)findViewById(R.id.citylist);
		
		AsyncRunner.run(new BaseRequestListener(){
			@Override
			public void onRequesting() throws AppException, JSONException {
				super.onRequesting();
				JSONObject jsonObject= MigrantApi.accountLogin("comger", "comgerpwd");
				Message msg = handler.obtainMessage();
				msg.arg1 = 1;
				handler.sendMessage(msg);
			}
			
			@Override
			public void onAppError(AppException e) {
				super.onAppError(e);
			}
		});
		

		
	}

	private void loadcity(){
		AsyncRunner.run(new BaseRequestListener(){
			@Override
			public void onRequesting() throws AppException, JSONException {
				super.onRequesting();
				array = MigrantApi.getCityList(null);
				Log.i("citys", array.toString());
				Message msg = handler.obtainMessage();
				msg.arg1 = 2;
				handler.sendMessage(msg);
			}
			
			@Override
			public void onAppError(AppException e) {
				super.onAppError(e);
			}
		});
	}
	
}
