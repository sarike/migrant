/**
 * BaseActivity.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-24
 */
package com.comger.migrant.ui;

import com.comger.migrant.AppManager;

import android.app.Activity;
import android.os.Bundle;

/**
 * @author comger
 *
 */
public class BaseActivity extends Activity {
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		// 添加Activity到堆栈
		AppManager.getAppManager().addActivity(this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();

		// 结束Activity&从堆栈中移除
		AppManager.getAppManager().finishActivity(this);
	}
}
