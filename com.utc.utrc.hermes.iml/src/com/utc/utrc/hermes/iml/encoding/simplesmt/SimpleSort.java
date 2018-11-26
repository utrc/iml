package com.utc.utrc.hermes.iml.encoding.simplesmt;

import java.util.List;

import com.utc.utrc.hermes.iml.encoding.AbstractSort;

public class SimpleSort extends AbstractSort {
	SimpleSort domain;
	SimpleSort range;
	
	List<SimpleSort> tupleElements;
	
	public SimpleSort() {
	}

	public SimpleSort(String name) {
		super();
		this.name = name;
	}
	
	public SimpleSort(String name, SimpleSort domain, SimpleSort range) {
		super();
		this.name = name;
		this.domain = domain;
		this.range = range;
	}
	
	public SimpleSort(String name, List<SimpleSort> tupleElements) {
		super();
		this.name = name;
		this.tupleElements = tupleElements;
	}
	
	public SimpleSort getDomain() {
		return domain;
	}

	public void setDomain(SimpleSort domain) {
		this.domain = domain;
	}

	public SimpleSort getRange() {
		return range;
	}

	public void setRange(SimpleSort range) {
		this.range = range;
	}
	
	public List<SimpleSort> getTupleElements() {
		return tupleElements;
	}

	public void setTupleElements(List<SimpleSort> tupleElements) {
		this.tupleElements = tupleElements;
	}

	@Override
	public String toString() {
		if (domain != null) {
			return "(define-sort " + getQuotedName() + " () (Array " + domain.getQuotedName() + " " + range.getQuotedName() + ")" ;
		} else if (tupleElements != null && !tupleElements.isEmpty()) {
			return String.format("(declare-datatypes () ((%s (|mk_%s| %s))))", getQuotedName(), getName(), getTupleListTypes());
		} else {
			return "(declare-sort " + getQuotedName() + " 0)";
		}
	}
	
	private String getTupleListTypes() {
		StringBuilder sb = new StringBuilder();
		for (int i=0 ; i < getTupleElements().size() ; i++) {
			sb.append("(__index_" + i + " " + getTupleElements().get(i).getQuotedName() + ") ");
		}
		return sb.toString();
	}

	public String getQuotedName() {
		return SimpleSmtUtil.getQuotedName(getName());
	}
}
