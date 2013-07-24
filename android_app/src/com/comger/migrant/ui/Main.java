/**
 * Main.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-9
 */
package com.comger.migrant.ui;

import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.comger.migrant.R;

/**
 * @author comger
 * 
 */
public class Main extends BaseActivity  {
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {

			
		}
	};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);

	}

	
}
