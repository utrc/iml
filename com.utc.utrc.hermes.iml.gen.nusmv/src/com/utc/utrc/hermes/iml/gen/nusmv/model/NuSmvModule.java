package com.utc.utrc.hermes.iml.gen.nusmv.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class NuSmvModule  {
	
	private String name ;
	private Map<String,NuSmvSymbol> variables ;
	private List<NuSmvSymbol> parameters;
	private Map<String,NuSmvSymbol> definitions;
	private Map<String,NuSmvSymbol> inits;
	private Map<String,NuSmvSymbol> trans ;
	private Map<String,NuSmvSymbol> invar ;
	private NuSmvModel container ;

	private boolean is_enum ;
	private List<String> literals ;

	
	public NuSmvModule(String name) {	
		variables = new HashMap<String,NuSmvSymbol>();
		parameters = new ArrayList<NuSmvSymbol>();
		definitions = new HashMap<>() ;
		inits = new HashMap<String,NuSmvSymbol>();
		trans = new HashMap<String,NuSmvSymbol>();
		invar = new HashMap<String,NuSmvSymbol>(); 
		this.container = null;
		literals = new ArrayList<>();
		this.name = name ;
	}
	
	public NuSmvModule(NuSmvModel m, String name) {	
		variables = new HashMap<String,NuSmvSymbol>();
		parameters = new ArrayList<NuSmvSymbol>();
		definitions = new HashMap<>() ;
		inits = new HashMap<String,NuSmvSymbol>();
		trans = new HashMap<String,NuSmvSymbol>();
		invar = new HashMap<String,NuSmvSymbol>(); 
		this.container = m;
		literals = new ArrayList<>();
	}

	public Map<String,NuSmvSymbol> getVariables() {
		return variables;
	}

	public List<NuSmvSymbol> getParameters() {
		return parameters;
	}

	public Map<String, NuSmvSymbol> getDefinitions() {
		return definitions;
	}

	public Map<String, NuSmvSymbol> getInits() {
		return inits;
	}

	public Map<String, NuSmvSymbol> getTrans() {
		return trans;
	}
	
	public Map<String, NuSmvSymbol> getInvar() {
		return invar;
	}

	

	public void setContainer(NuSmvModel container) {
		this.container = container ;
	}
	
	public NuSmvModel getContainer() {
		return container;
	}
	
	public boolean hasType(String s) {
		return container.getModules().containsKey(s);
	}
	public NuSmvModule getType(String s) {
		return container.getModules().get(s);
	}
	
	public void addSymbol(NuSmvSymbol s) {
		switch (s.getElementType()) {
			case DEFINE : definitions.put(s.getName(), s); s.setContainer(this); break;			
			case INIT : inits.put(s.getName(), s); s.setContainer(this);break;
			case PARAMETER : parameters.add(s); s.setContainer(this);break;
			case TRANSITION : trans.put(s.getName(), s); s.setContainer(this);break;
			case VAR : variables.put(s.getName(), s); s.setContainer(this);break;
			case INVAR : invar.put(s.getName(), s) ; s.setContainer(this);break;
			default : break;
		} 
	}

	public boolean isEnum() {
		return is_enum;
	}
	
	public void setEnum(boolean e) {
		is_enum = e ;
	}
	
	public List<String> getLiterals(){
		return literals;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public boolean hasParameter(String name) {
		for(NuSmvSymbol  v : parameters) {
			if (v.getName().equals(name)) {
				return true;
			}
		}
		return false;
	}
	
	public int paramIndex(String name) {
		for(int index = 0 ; index < parameters.size() ; index++) {
			if (parameters.get(index).getName().equals(name)) {
				return index;
			}
		}
		return -1 ;
	}	
	
	
	
}
