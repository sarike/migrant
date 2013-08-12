/**
 * Main.java
 * 
 * @user comger
 * @mail comger@gmail.com 2013-7-9
 */
package com.comger.migrant.ui;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.TabHost.OnTabChangeListener;
import android.widget.Button;
import android.widget.TextView;

import com.comger.migrant.R;

/**
 * @author comger
 * 
 */
public class Main extends BaseTabActivity implements OnTabChangeListener, OnClickListener {
	
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {

		}
	};
	private TextView titletext;
	private Button imformation;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		_create(savedInstanceState, this);

		titletext = (TextView) findViewById(R.id.titletext);

		View homeTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabbottommini, null);
		TextView homeTabTextView = (TextView) homeTabView.findViewById(R.id.tab_label);
		homeTabTextView.setBackgroundResource(R.drawable.tabhome);
		AddActivity(homeTabView, InformationActivity.class);

		View reportTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabbottommini, null);
		TextView reportTabTextView = (TextView) reportTabView.findViewById(R.id.tab_label);
		reportTabTextView.setBackgroundResource(R.drawable.tabhome);
		AddActivity(reportTabView, ReportActivity.class);
		if (tabHost.getCurrentTab() == 0) {
			titletext.setText("资讯");
		}
		tabHost.setOnTabChangedListener(this);
		
		imformation = (Button) findViewById(R.id.imformation);
		imformation.setOnClickListener(this);
	}
	
	@Override
	protected void onResume() {
		
		super.onResume();
	}

	@Override
	public void onTabChanged(String tabId) {
		if (tabId.equals("com.comger.migrant.ui.InformationActivity")) {
			titletext.setText("资讯");
		}else if (tabId.equals("com.comger.migrant.ui.ReportActivity")) {
			titletext.setText("报告");
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.imformation:
			Intent intent = new Intent(this, EditInformation.class);
			startActivity(intent);
			break;

		default:
			break;
		}
	}

}
