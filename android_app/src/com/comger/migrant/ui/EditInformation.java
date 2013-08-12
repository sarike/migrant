/**
 * Copyright 2013 Barfoo
 * 
 * All right reserved
 * 
 * Created on 2013-8-8 下午5:54:44
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

import android.os.Bundle;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;

public class EditInformation extends BaseActivity implements OnClickListener {
	private EditText mEditTitle;
	private EditText mEditContent;
	private Button back;
	private Button send;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.editinfomation);

		back = (Button) findViewById(R.id.back);
		send = (Button) findViewById(R.id.send);
		back.setOnClickListener(this);
		send.setOnClickListener(this);

		mEditTitle = (EditText) findViewById(R.id.editTitle);
		mEditContent = (EditText) findViewById(R.id.editContent);

	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.back:
			this.finish();
			break;

		case R.id.send:
			sendInformationDate();
			break;

		default:
			break;
		}
	}

	String city;
	String body;

	private void sendInformationDate() {
		city = mEditTitle.getText().toString().trim();
		body = mEditContent.getText().toString().trim();
		AsyncRunner.run(new BaseRequestListener() {

			@Override
			public void onReading() {
				super.onReading();
			}

			@Override
			public void onRequesting() throws AppException, JSONException {
				JSONArray mJsonArray = MigrantApi.setInformation(city, body);

			}

			@Override
			public void onAppError(AppException e) {
				// TODO Auto-generated method stub
				super.onAppError(e);
			}
		});
	}
}
