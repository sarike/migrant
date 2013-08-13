/**
 * Copyright 2013 Barfoo
 *
 * All right reserved
 *
 * Created on 2013-8-7 上午10:54:52
 *
 * @author zxy
 */
package com.comger.migrant.ui;

import org.json.JSONArray;
import org.json.JSONException;

import com.comger.migrant.AppException;
import com.comger.migrant.R;
import com.comger.migrant.adapter.InformationAdapter;
import com.comger.migrant.api.MigrantApi;
import com.comger.migrant.common.AsyncRunner;
import com.comger.migrant.common.BaseRequestListener;
import com.comger.migrant.view.PullListView;
import com.comger.migrant.view.PullListView.OnRefreshListener;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;

public class CityReportActivity extends BaseActivity implements OnItemClickListener{


	private PullListView mDownpulllist;
	private JSONArray mJsonArray;
	private InformationAdapter informationAdapter;

	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			mDownpulllist.setAdapter(informationAdapter);
		};
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.informationlist);

		initView();
		initLoadDate();
	}

	private void initView() {
		mDownpulllist = (PullListView) findViewById(R.id.downpulllist);
		mDownpulllist.setOnItemClickListener(this);
	}

	private void initLoadDate() {
		mDownpulllist.setonRefreshListener(new OnRefreshListener() {

			@Override
			public void onRefresh(int page_index, int page_size) {
				AsyncRunner.run(new BaseRequestListener() {

					@Override
					public void onReading() {
						// TODO Auto-generated method stub
						super.onReading();
					}

					@Override
					public void onRequesting() throws AppException, JSONException {
						mJsonArray = MigrantApi.getCityReportList();
						informationAdapter = new InformationAdapter(CityReportActivity.this, mJsonArray);
						Message msg = handler.obtainMessage();
						handler.sendMessage(msg);
					}

					@Override
					public void onAppError(AppException e) {
						// TODO Auto-generated method stub
						super.onAppError(e);
					}
				});
			}
		});
		mDownpulllist.onRefresh();
	}

	@Override
	public void onItemClick(AdapterView<?> arg0, View arg1, int arg2, long arg3) {
		try {
			Intent intent = new Intent(this, ShowTabInformation.class);
			intent.putExtra("jsonDate", String.format("%s", mJsonArray.getJSONObject(arg2-1)));
			startActivity(intent);
		} catch (JSONException e) {
			e.printStackTrace();
		}		
	}

}
