package com.utc.utrc.hermes.iml.util;

import java.util.List;

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.FolFormula;

public class FormulaHelper {
	
	public final static String IMPLIES = "=>";

	public static FolFormula createBool(boolean value) {
		return ImlCustomFactory.INST.createTruthValue(value);
	}

	public static FolFormula AND(FolFormula left, FolFormula right) {
		return ImlCustomFactory.INST.createAndExpression(left, right);
	}

	public static FolFormula IMPLIES(FolFormula assumption, FolFormula guarantee) {
		return ImlCustomFactory.INST.createFolFormula(assumption, IMPLIES,guarantee);
	}
	
	public static FolFormula AND_ALL(List<FolFormula> formulas) {
		if (!formulas.isEmpty()) {
			FolFormula conjunction = formulas.get(0);
			for (int i=1 ; i<formulas.size() ; i++) {
				conjunction = AND(conjunction, formulas.get(i));
			}
			return conjunction;
		}
		return null;
	}
	

}
