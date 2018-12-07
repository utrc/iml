package com.utc.utrc.hermes.iml.gen.nusmv.model;

import java.util.ArrayList;
import java.util.List;

public class NuSmvType {
	
	private String name ;
	private boolean is_enum ;
	private List<String> literals ;

	public static NuSmvType Bool = new NuSmvType("boolean") ;
	public static NuSmvType Int = new NuSmvType("integer") ;
	
	public NuSmvType(String name) {
		this.name = name ;
		literals = new ArrayList<String>();
		is_enum = false;
	}
	
	public boolean isEnum() {
		return is_enum;
	}

	public void setEnum(boolean is_enum) {
		this.is_enum = is_enum;
	}

	public List<String> getLiterals() {
		return literals;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public StringBuffer serialize() {
		return new StringBuffer("MODULE " + name) ;
	}
	
	
	
}
