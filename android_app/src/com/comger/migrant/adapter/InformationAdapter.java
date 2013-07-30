/**
 * Copyright 2013 Barfoo
 *
 * All right reserved
 *
 * Created on 2013-7-29 上午10:49:56
 *
 * @author zxy
 */
package com.comger.migrant.adapter;

import org.json.JSONArray;
import org.json.JSONException;

import com.comger.migrant.R;
import com.comger.migrant.common.StringUtils;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

public class InformationAdapter extends BaseAdapter{

	JSONArray mJsonArray;
	private LayoutInflater mInflater;
	
	public InformationAdapter(Context context,JSONArray jsonArray) {
		this.mJsonArray=jsonArray;
		mInflater = LayoutInflater.from(context);
	}
	
	@Override
	public int getCount() {
		return mJsonArray.length();
	}

	@Override
	public Object getItem(int position) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public long getItemId(int position) {
		// TODO Auto-generated method stub
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder;
		
		if (convertView==null) {
			convertView =mInflater.inflate(R.layout.informationitem, null);
			holder = new ViewHolder();
			holder.mInfoContent = (TextView) convertView.findViewById(R.id.infocontent);
			holder.mDateTime = (TextView) convertView.findViewById(R.id.datetime);
		}else {
			holder = (ViewHolder)convertView.getTag();
		}
		
		try {
			holder.mInfoContent.setText(mJsonArray.getJSONObject(position).getString("body"));
			String date = mJsonArray.getJSONObject(position).getString("addon");
			holder.mDateTime.setText(date);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		return convertView;
	}
	
	public class ViewHolder{
		public TextView mInfoContent;
		public TextView mDateTime;
	}

}
