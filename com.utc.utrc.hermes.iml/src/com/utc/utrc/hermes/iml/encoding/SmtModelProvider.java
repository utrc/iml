package com.utc.utrc.hermes.iml.encoding;

import java.util.List;

/**
 * This interface abstract the creation of an SMT model
 *
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com)
 *
 * @param <SortT> the model class for SMT sort declaration
 * @param <FuncDeclT> the model class for SMT function declaration
 */
public interface SmtModelProvider <SortT, FuncDeclT, FormulaT> {
	
	public SortT createSort(String sortName);
	
	public SortT createHotSort(String sortName, SortT domainSort, SortT rangeSort);
	
	public SortT createTupleSort(String sortName, List<SortT> sorts);
	
	public FuncDeclT createFuncDecl(String funName, List<SortT> inputSorts, SortT outputSort);

	public FuncDeclT createConst(String symbolId, SortT symbolSort);

	public FormulaT createFormula(OperatorType op, List<FormulaT> params);

	public FormulaT createFormula(FuncDeclT funcDeclar, List<FormulaT> params);

	public FormulaT createFormula(Object value);

}
