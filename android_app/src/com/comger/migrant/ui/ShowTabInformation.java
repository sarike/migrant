/**
 * Copyright 2013 Barfoo
 * 
 * All right reserved
 * 
 * Created on 2013-8-5 下午2:07:04
 * 
 * @author zxy
 */
package com.comger.migrant.ui;

import android.content.Intent;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.TextView;

import com.comger.migrant.R;

public class ShowTabInformation extends BaseTabActivity {

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		_create(savedInstanceState, this);
		Intent intent;
		intent = getIntent();
		String stringExtra = intent.getStringExtra("jsonDate");
		
		intent = new Intent();
		intent.putExtra("jsonDate", stringExtra);
		
		View homeTabView = (View) LayoutInflater.from(this).inflate(R.layout.tabbottommini, null);
		TextView homeTabTextView = (TextView) homeTabView.findViewById(R.id.tab_label);
		homeTabTextView.setCompoundDrawablesWithIntrinsicBounds(null, getResources().getDrawable(R.drawable.tabhome), null, null);
		homeTabTextView.setText("内容");
		AddActivity(homeTabView, ShowInformation.class,intent.getExtras());
		
		View homeTabView1 = (View) LayoutInflater.from(this).inflate(R.layout.tabbottommini, null);
		TextView homeTabTextView1 = (TextView) homeTabView1.findViewById(R.id.tab_label);
		homeTabTextView1.setCompoundDrawablesWithIntrinsicBounds(null, getResources().getDrawable(R.drawable.tabhome), null, null);
		homeTabTextView1.setText("评论");
		AddActivity(homeTabView1, ShowCommentAct.class,intent.getExtras());
	}
}
