/**
 * BaseRequestListener.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-23
 */
package com.comger.migrant.common;

import org.json.JSONException;

import android.widget.Toast;

import com.comger.migrant.AppContext;
import com.comger.migrant.AppException;
import com.comger.migrant.common.AsyncRunner.RequestListener;

/**
 * @author comger
 *
 */
public class BaseRequestListener implements RequestListener {


	@Override
	public void onReading() {
		// TODO Auto-generated method stub

	}


	@Override
	public void onRequesting() throws AppException, JSONException {
		// TODO Auto-generated method stub

	}


	@Override
	public void onDone() {
		// TODO Auto-generated method stub

	}


	@Override
	public void onAppError(AppException e) {
		e.makeToast(AppContext.mContext);
		//Toast.makeText(AppContext.mContext, "Error:"+e.getMessage(), Toast.LENGTH_SHORT).show();
	}

}
