package com.utc.utrc.hermes.iml.encoding.simplesmt;

import java.util.List;

public class SimpleFunDeclaration {
	
	String name;
	List<SimpleSort> inputSorts;
	SimpleSort outputSort;
	
	public SimpleFunDeclaration() {
	}

	public SimpleFunDeclaration(String name, List<SimpleSort> inputSorts, SimpleSort outputSort) {
		this.name = name;
		this.inputSorts = inputSorts;
		this.outputSort = outputSort;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public List<SimpleSort> getInputSorts() {
		return inputSorts;
	}
	public void setInputSorts(List<SimpleSort> inputSorts) {
		this.inputSorts = inputSorts;
	}
	public SimpleSort getOutputSort() {
		return outputSort;
	}
	public void setOutputSort(SimpleSort outputSort) {
		this.outputSort = outputSort;
	}
	
	@Override
	public String toString() {
		if (inputSorts == null || inputSorts.isEmpty()) {
			return String.format("(declare-const %s  %s)", getQuotedName(), outputSort.getQuotedName());
		} else {
			return String.format("(declare-fun %s (%s) %s)", getQuotedName(), 
					inputSorts.stream().map(it -> it.getQuotedName()).reduce((acc, curr) -> acc + " " + curr).get()
					, outputSort.getQuotedName());
		}
	}
	
	public String getQuotedName() {
		return SimpleSmtUtil.getQuotedName(name);
	}

}
