package com.utc.utrc.hermes.iml.encoding;

import java.util.List;

public interface SmtModelProvider <SortT, FuncDeclT> {
	
	public SortT createSort(String sortName);
	
	public SortT createHotSort(String sortName, SortT domainSort, SortT rangeSort);
	
	public SortT createTupleSort(String sortName, List<SortT> sorts);
	
	public FuncDeclT createFuncDecl(String funName, List<SortT> inputSorts, SortT outputSort);

	public FuncDeclT createConst(String symbolId, SortT symbolSort);

}
