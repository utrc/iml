/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;
import java.util.List;
import org.eclipse.emf.ecore.util.EcoreUtil;

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.FolFormula;

public class FormulaHelper {
	
	public final static String IMPLIES = "=>";
	public final static FolFormula TRUE = ImlCustomFactory.INST.createTruthValue(true);
	public final static FolFormula FALSE = ImlCustomFactory.INST.createTruthValue(false);

	public static FolFormula createBool(boolean value) {
		return ImlCustomFactory.INST.createTruthValue(value);
	}

	public static FolFormula AND(FolFormula left, FolFormula right) {
		return ImlCustomFactory.INST.createAndExpression(left, right);
	}
	
	public static FolFormula OR(FolFormula left, FolFormula right) {
		return ImlCustomFactory.INST.createAndExpression(left, right);
	}

	public static FolFormula IMPLIES(FolFormula assumption, FolFormula guarantee) {
		return ImlCustomFactory.INST.createFolFormula(assumption, IMPLIES, guarantee);
	}

	public static FolFormula AND_ALL(List<FolFormula> formulas) {
		if (!formulas.isEmpty()) {
			FolFormula conjunction = formulas.get(0);
			for (int i = 1; i < formulas.size(); i++) {
				conjunction = AND(conjunction, formulas.get(i));
			}
			return conjunction;
		}
		return EcoreUtil.copy(TRUE);
	}
	
	public static FolFormula orAll(List<FolFormula> formulas) {
		if (!formulas.isEmpty()) {
			FolFormula disjunction = formulas.get(0);
			for (int i = 1; i < formulas.size(); i++) {
				disjunction = OR(disjunction, formulas.get(i));
			}
			return disjunction;
		}
		return null;
	}
	
}
