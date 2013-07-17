/**
 * Main.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-9
 */
package com.comger.migrant.ui;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.comger.migrant.R;

/**
 * @author comger
 * 
 */
public class Main extends Activity implements  android.view.View.OnClickListener {
	
	TextView tv1 = null;
	TextView tv2 = null;
	LinearLayout ll1 = null;
	EditText et1 = null;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		tv1 = (TextView)findViewById(R.id.tv1);
		tv1.setOnClickListener(this);
		tv2 = (TextView)findViewById(R.id.tv2);
		tv2.setOnClickListener(this);
		
		ll1 = (LinearLayout)findViewById(R.id.ll1);
		ll1.setOnClickListener(this);
		ll1.setVisibility(View.GONE);
		
		et1 = (EditText)findViewById(R.id.ed1);
	}


	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.tv1:
			Log.i("tv1", "done");
			break;
		case R.id.tv2:
			Log.i("tv2", "done");
			break;
		case R.id.ll1:
			Log.i("ll1", "done");
			break;
		case R.id.ed1:
			Log.i("et1", "done");
			break;
			
		default:
			break;
		}
	}
}
