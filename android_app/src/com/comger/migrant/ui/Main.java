/**
 * Main.java
 * 
 * @user comger
 * @mail comger@gmail.com 2013-7-9
 */
package com.comger.migrant.ui;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.comger.migrant.AppStart;
import com.comger.migrant.R;

/**
 * @author comger
 * 
 */
public class Main extends BaseTabActivity {
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {

		}
	};

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		_create(savedInstanceState, this);

		View homeTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabbottommini, null);
		TextView homeTabTextView = (TextView) homeTabView.findViewById(R.id.tab_label);
		homeTabTextView.setBackgroundResource(R.drawable.tabhome);
		AddActivity(homeTabView, InformationActivity.class);
		
		View reportTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabbottommini, null);
		TextView reportTabTextView = (TextView) reportTabView.findViewById(R.id.tab_label);
		reportTabTextView.setBackgroundResource(R.drawable.tabhome);
		AddActivity(reportTabView, ReportActivity.class);

	}

}
