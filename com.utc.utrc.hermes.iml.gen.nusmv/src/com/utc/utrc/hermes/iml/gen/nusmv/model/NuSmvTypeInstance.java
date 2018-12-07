package com.utc.utrc.hermes.iml.gen.nusmv.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


public class NuSmvTypeInstance  {
	private NuSmvModule type ;
	private List<NuSmvVariable> params ;
	
	public NuSmvTypeInstance() {
		params = new ArrayList<NuSmvVariable>();
	}
	public NuSmvTypeInstance(NuSmvTypeInstance other) {
		this.type = other.type;
		params = new ArrayList<NuSmvVariable>();
		for(NuSmvVariable v : other.params) {
			params.add(new NuSmvVariable(v));
		}
		
	}
	
	
	public NuSmvTypeInstance(NuSmvModule t) {
		params = new ArrayList<NuSmvVariable>();
		type = t;
	}
	public NuSmvModule getType() {
		return type;
	}
	public void setType(NuSmvModule type) {
		this.type = type;
	}
	public List< NuSmvVariable> getParams() {
		return params;
	}
	
	public void setParam(int i , NuSmvVariable v) {
		int current_size = params.size();
		if (current_size <= i) {
			for(int index = 0 ; index <= i - current_size ; index++) {
				params.add(new NuSmvVariable("__NOT__SET__")) ;
			}
		}
		params.set(i,v);
	}
	
	
	
	
	
}
