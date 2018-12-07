package com.utc.utrc.hermes.iml.gen.nusmv.model;

import java.util.HashMap;
import java.util.Map;

public class NuSmvModel {
	private Map<String,NuSmvModule> modules;
	private static int last_id = 0 ;
	public static NuSmvModule Bool = new NuSmvModule("iml.lang.Bool");
	public static NuSmvModule Int = new NuSmvModule("iml.lang.Int");
	
	public NuSmvModel() {
		modules = new HashMap<>();
		modules.put(Bool.getName(), Bool);
		modules.put(Int.getName(), Int);
	}
	public Map<String, NuSmvModule> getModules() {
		return modules;
	}
	public void setModules(Map<String, NuSmvModule> modules) {
		this.modules = modules;
	}
	
	public boolean hasType(String s) {
		return modules.containsKey(s);
	}
	public NuSmvModule getType(String s) {
		return modules.get(s);
	}

	public void addModule(NuSmvModule m) {
		modules.put(m.getName(), m);
		m.setContainer(this);
	}
	
	public String newSymbolName() {
		last_id ++ ;
		return "symbol___" + last_id ;
	}

	
}
