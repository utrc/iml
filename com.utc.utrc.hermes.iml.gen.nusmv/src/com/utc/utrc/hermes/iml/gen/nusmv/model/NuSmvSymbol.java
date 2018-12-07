package com.utc.utrc.hermes.iml.gen.nusmv.model;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.FolFormula;

public class NuSmvSymbol {
	private NuSmvElementType elementType ;
	private String name ;
	private NuSmvTypeInstance type ;
	private String definition;
	private List<NuSmvVariable> parameters ;
	
	
	private static int id = 0;
	
	private NuSmvModule container ;
	
	public NuSmvSymbol(String name) {
		this.name = name;
		container = null ;
		parameters = new ArrayList<NuSmvVariable>() ;
		elementType = NuSmvElementType.VAR ;
	}
	
	public NuSmvSymbol(NuSmvSymbol other) {
		elementType = other.elementType;
		name = other.name;
		type = new NuSmvTypeInstance(other.type);
		definition = other.definition;
		parameters = new ArrayList<NuSmvVariable>() ;
		for(NuSmvVariable v : parameters) {
			parameters.add(new NuSmvVariable(v));
		}
		
	}
	
	public NuSmvElementType getElementType() {
		return elementType;
	}

	public void setElementType(NuSmvElementType elementType) {
		this.elementType = elementType;
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

	public String getDefinition() {
		return definition;
	}

	public void setDefinition(String definition) {
		this.definition = definition;
	}

	public NuSmvModule getContainer() {
		return container;
	}

	public void setContainer(NuSmvModule container) {
		this.container = container;
	}
	
	public List<NuSmvVariable> getParameters(){
		return parameters;
	}
	public void addParameter(NuSmvVariable v) {
		parameters.add(v);
	}
	
	public int indexOf(String pname) {
		for(int index = 0 ; index < parameters.size() ; index++) {
			if (parameters.get(index).getName().equals(pname)) {
				return index ;
			}
		}
		return -1;
	}
	
	
	
	
}
