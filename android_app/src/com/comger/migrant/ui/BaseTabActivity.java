/**
 * Copyright 2013 Barfoo
 * 
 * All right reserved
 * 
 * Created on 2013-7-26 下午2:48:19
 * 
 * @author zxy
 */
package com.comger.migrant.ui;

import android.app.TabActivity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.view.View;
import android.widget.TabHost;

public class BaseTabActivity extends TabActivity {

	public TabHost tabHost;
	Context mContext;

	protected void _create(Bundle savedInstanceState, Context context) {
		mContext = context;
	}

	@SuppressWarnings("rawtypes")
	public void AddActivity(View view, Class t) {
		AddActivity(view, t, null);
	}

	@SuppressWarnings("rawtypes")
	public void AddActivity(View view, Class t, Bundle params) {
		tabHost = getTabHost();
		Intent intent = new Intent(this, t);
		if (params != null) {
			for (String key : params.keySet()) {
				if (params.getString(key) != null) {
					intent.putExtra(key, params.getString(key));
				}
			}
		}
		tabHost.addTab(tabHost.newTabSpec(t.getName()).setIndicator(view).setContent(intent));
		
		getTabGetCurrent(tabHost.getCurrentTab());
	}

	public void getTabGetCurrent(int currentTab) {
		
	}
}
