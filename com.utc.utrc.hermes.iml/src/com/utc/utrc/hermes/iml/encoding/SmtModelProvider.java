package com.utc.utrc.hermes.iml.encoding;

import java.util.List;

public interface SmtModelProvider <SortT> {
	
	public SortT createSort(String sortName);
	
	public SortT createHotSort(String sortName, SortT domainSort, SortT rangeSort);
	
	public SortT createTupleSort(String sortName, List<SortT> sorts);

}
