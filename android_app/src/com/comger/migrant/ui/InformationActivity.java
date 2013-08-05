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
		homeTabTextView.setText("综合信息");
		AddActivity(homeTabView, HomeInformation.class);
		
		View myTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabtopmini, null);
		TextView myTabTextView = (TextView) myTabView.findViewById(R.id.tab_label);
		myTabTextView.setText("我的信息");
		AddActivity(myTabView, NewMyInformation.class);

		View newTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabtopmini, null);
		TextView newTabTextView = (TextView) newTabView.findViewById(R.id.tab_label);
		newTabTextView.setText("最新动态");
		AddActivity(newTabView, CityInformation.class);
	}
}
