package com.utc.utrc.hermes.iml.encoding;

import java.util.List;

import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleFunDeclaration;
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleSmtFormula;
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleSort;

/**
 * This is a simple implementation of SmtModelProvider using simple SMT model
 *
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com)
 */
public class SimpleSmtModelProvider implements SmtModelProvider<SimpleSort, SimpleFunDeclaration, SimpleSmtFormula> {

	@Override
	public SimpleSort createSort(String sortName) {
		return new SimpleSort(sortName);
	}

	@Override
	public SimpleSort createHotSort(String sortName, SimpleSort domainSort, SimpleSort rangeSort) {
		return new SimpleSort(sortName, domainSort, rangeSort);
	}

	@Override
	public SimpleSort createTupleSort(String sortName, List<SimpleSort> sorts) {
		return new SimpleSort(sortName, sorts);
	}

	@Override
	public SimpleFunDeclaration createFuncDecl(String funName, List<SimpleSort> inputSorts, SimpleSort outputSort) {
		return new SimpleFunDeclaration(funName, inputSorts, outputSort);
	}

	@Override
	public SimpleFunDeclaration createConst(String funName, SimpleSort outputSort) {
		return new SimpleFunDeclaration(funName, null, outputSort);
	}

	@Override
	public SimpleSmtFormula createFormula(OperatorType op, List<SimpleSmtFormula> params) {
		return new SimpleSmtFormula(op, params);
	}

	@Override
	public SimpleSmtFormula createFormula(Object value) {
		return new SimpleSmtFormula(value);
	}

	@Override
	public SimpleSmtFormula createFormula(SimpleFunDeclaration funcDeclar, List<SimpleSmtFormula> params) {
		return new SimpleSmtFormula(funcDeclar, null, params, null);
	}

	@Override
	public SimpleSmtFormula createFormula(List<SimpleSmtFormula> params) {
		return new SimpleSmtFormula(null, params);
	}


}
