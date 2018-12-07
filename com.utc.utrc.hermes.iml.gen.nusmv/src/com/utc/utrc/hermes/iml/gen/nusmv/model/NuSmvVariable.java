package com.utc.utrc.hermes.iml.gen.nusmv.model;

import com.utc.utrc.hermes.iml.iml.FolFormula;

public class NuSmvVariable extends NuSmvElement{
	
	private String name ;
	private NuSmvTypeInstance type ;
	private FolFormula definition;
	
	private static int id = 0;

	public NuSmvVariable() {
		this.name = "unnamed___" + id;
		id ++ ;
	}
	public NuSmvVariable(NuSmvVariable other) {
		this.type = other.type;
		this.definition = other.definition;
	}

	public NuSmvVariable(String name) {
		this.name = name;
	}
	
	
	public NuSmvVariable(String name, NuSmvTypeInstance ti) {
		this.name = name;
		this.type = ti;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public NuSmvTypeInstance getType() {
		return type;
	}

	public void setType(NuSmvTypeInstance type) {
		this.type = type;
	}

	public void setDefinition(FolFormula f) {
		definition = f;
	}
	public FolFormula getDefinition() {
		return definition;
	}
	
	
	
}
