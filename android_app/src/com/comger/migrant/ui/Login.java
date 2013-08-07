/**
 * Login.java
 * @user comger
 * @mail comger@gmail.com
 * 2013-7-24
 */
package com.comger.migrant.ui;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.comger.migrant.AppContext;
import com.comger.migrant.AppException;
import com.comger.migrant.R;
import com.comger.migrant.api.MigrantApi;
import com.comger.migrant.common.AsyncRunner;
import com.comger.migrant.common.BaseRequestListener;



/**
 * @author comger
 *
 */
public class Login extends Activity {
	
	EditText etusername;
	EditText etpassword;
	Button btnLogin;
	
	Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if(msg.arg1==1){
				Intent intent = new Intent(Login.this, Main.class);
				startActivity(intent);
				finish();
			}
		}
	};
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.login);
		
		if (!AppContext.mLoginUser.getString("name", "").equals("")&&!AppContext.mLoginUser.getString("pwd", "").equals("")) {
			Intent intent = new Intent(Login.this, Main.class);
			startActivity(intent);
			finish();
		}
		
		etusername = (EditText)findViewById(R.id.et_username);
		etpassword = (EditText)findViewById(R.id.et_password);
		etusername.setText(AppContext.mLoginUser.getString("name", "comger"));
		etpassword.setText("comgerpwd");
		
		btnLogin = (Button)findViewById(R.id.btn_login);
		
		btnLogin.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				login();
			}
		});
	}
	
	private void login(){
		final String username = etusername.getText().toString().trim();
		final String password = etpassword.getText().toString().trim();
		if(username.length()==0 || password.length()==0){
			Toast.makeText(AppContext.mContext, "用户名或密码不能为空", Toast.LENGTH_SHORT).show();
			return ;
		}
		
		AsyncRunner.run(new BaseRequestListener(){
			@Override
			public void onRequesting() throws AppException, JSONException {
				super.onRequesting();
				JSONObject obj= MigrantApi.accountLogin(username,password);
				Editor editor = AppContext.mLoginUser.edit();
				editor.putString("uid", obj.getString("_id"));
				editor.putString("name", obj.getString("username"));
				editor.putString("pwd", String.format("%s", password));
				editor.commit();
				Message msg = handler.obtainMessage();
				msg.arg1 = 1;
				handler.sendMessage(msg);
			}
			
			@Override
			public void onAppError(AppException e) {
				super.onAppError(e);
			}
		});
	}
}
