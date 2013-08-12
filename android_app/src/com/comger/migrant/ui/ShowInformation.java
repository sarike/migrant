/**
 * Copyright 2013 Barfoo
 * 
 * All right reserved
 * 
 * Created on 2013-8-5 上午11:01:25
 * 
 * @author zxy
 */
package com.comger.migrant.ui;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ListView;
import android.widget.TextView;

import com.comger.migrant.AppException;
import com.comger.migrant.R;
import com.comger.migrant.adapter.InformationAdapter;
import com.comger.migrant.api.MigrantApi;
import com.comger.migrant.common.AsyncRunner;
import com.comger.migrant.common.BaseRequestListener;

public class ShowInformation extends BaseActivity implements OnClickListener {

	private TextView mImContent;
	private TextView mDateTime;
	private ListView commentList;
	private JSONObject jsonObject;
	private JSONArray mJsonArray;
	private String informationID;
	private InformationAdapter informationAdapter;
	
	
	Handler handler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			commentList.setAdapter(informationAdapter);
		};
	};
	private EditText commedit;
	private String body;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.showinformation);

		findIntent();
		getCommentList();
		initFindView();
	}

	private void findIntent() {
		Intent intent = getIntent();
		String stringExtra = intent.getStringExtra("jsonDate");
		try {
			jsonObject = new JSONObject(stringExtra);
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void initFindView() {
		mImContent = (TextView) findViewById(R.id.imContent);
		mDateTime = (TextView) findViewById(R.id.datetime);
		commentList = (ListView) findViewById(R.id.commentList);
		Button sendcomm = (Button) findViewById(R.id.sendcomm);
		sendcomm.setOnClickListener(this);
		
		commedit = (EditText) findViewById(R.id.commedit);

		try {
			mImContent.setText(jsonObject.getString("body"));
			mDateTime.setText(jsonObject.getString("addon"));
			informationID = jsonObject.getString("_id");
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	private void getCommentList() {
		AsyncRunner.run(new BaseRequestListener() {

			@Override
			public void onReading() {
				super.onReading();
			}

			@Override
			public void onRequesting() throws AppException, JSONException {
				mJsonArray = MigrantApi.getCommentList(informationID);
				informationAdapter = new InformationAdapter(ShowInformation.this, mJsonArray);
				Message msg = handler.obtainMessage();
				handler.sendMessage(msg);
				super.onRequesting();
			}
			
			@Override
			public void onAppError(AppException e) {
				super.onAppError(e);
			}
		});
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.sendcomm:
			sendComment();
			break;

		default:
			break;
		}
	}

	private void sendComment() {
		body = commedit.getText().toString().trim();
		
		AsyncRunner.run(new BaseRequestListener() {

			@Override
			public void onReading() {
				super.onReading();
			}

			@Override
			public void onRequesting() throws AppException, JSONException {
				//mJsonArray = MigrantApi.setCommentEdit(body, pid);

				super.onRequesting();
			}
			
			@Override
			public void onAppError(AppException e) {
				super.onAppError(e);
			}
		});
	
		
	}

}
