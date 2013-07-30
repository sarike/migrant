/**
 * Copyright 2013 Barfoo
 * 
 * All right reserved
 * 
 * Created on 2013-7-26 下午3:47:55
 * 
 * @author zxy
 */
package com.comger.migrant.ui;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.comger.migrant.AppStart;
import com.comger.migrant.R;

public class InformationActivity extends BaseTabActivity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.toptabmain);
		_create(savedInstanceState, this);

		View homeTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabtopmini, null);
		TextView homeTabTextView = (TextView) homeTabView.findViewById(R.id.tab_label);
		homeTabTextView.setText("最新动态");
		AddActivity(homeTabView, NewInformation.class);

		View homeTabView1 = (View) LayoutInflater.from(this).inflate(R.layout.tabtopmini, null);
		TextView homeTabTextView1 = (TextView) homeTabView1.findViewById(R.id.tab_label);
		homeTabTextView1.setText("最新动态");
		AddActivity(homeTabView1, NewInformation.class);
	}
}
