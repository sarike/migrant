/**
 * Copyright 2013 Barfoo
 *
 * All right reserved
 *
 * Created on 2013-8-7 上午10:50:10
 *
 * @author zxy
 */
package com.comger.migrant.ui;

import com.comger.migrant.R;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

public class ReportActivity extends BaseTabActivity{
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.toptabmain);
		_create(savedInstanceState, this);
		
		View homeTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabtopmini, null);
		TextView homeTabTextView = (TextView) homeTabView.findViewById(R.id.tab_label);
		homeTabTextView.setText("城市报告");
		AddActivity(homeTabView, CityReportActivity.class);
		
		View myTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabtopmini, null);
		TextView myTabTextView = (TextView) myTabView.findViewById(R.id.tab_label);
		myTabTextView.setText("我的报告");
		AddActivity(myTabView, NewMyInformation.class);
		
	}
}
