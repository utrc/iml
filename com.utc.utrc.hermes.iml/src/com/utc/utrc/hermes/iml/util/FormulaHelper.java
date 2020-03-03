/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;
import java.util.List;
import static org.eclipse.emf.ecore.util.EcoreUtil.copy;

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.ArrayAccess;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TailedExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TruthValue;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;


public class FormulaHelper {
	public final static String IMPLIES = "=>";
	public final static FolFormula TRUE = ImlCustomFactory.INST.createTruthValue(true);
	public final static FolFormula FALSE = ImlCustomFactory.INST.createTruthValue(false);

	public static FolFormula createBool(boolean value) {
		return ImlCustomFactory.INST.createTruthValue(value);
	}

	public static FolFormula AND(FolFormula left, FolFormula right) {
		return ImlCustomFactory.INST.createAndExpression(copy(left), copy(right));
	}
	
	public static FolFormula OR(FolFormula left, FolFormula right) {
		return ImlCustomFactory.INST.createOrExpression(copy(left), copy(right));
	}

	public static FolFormula IMPLIES(FolFormula assumption, FolFormula guarantee) {
		return ImlCustomFactory.INST.createFolFormula(copy(assumption), IMPLIES, copy(guarantee));
	}

	public static FolFormula AND_ALL(List<FolFormula> formulas) {
		if (!formulas.isEmpty()) {
			FolFormula conjunction = formulas.get(0);
			for (int i = 1; i < formulas.size(); i++) {
				conjunction = AND(conjunction, formulas.get(i));
			}
			return conjunction;
		}
		return copy(TRUE);
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
	
	public static String formual2String(FolFormula fol) {
		if (fol == null) return "null";
		
		String left = null;
		String right = null;
		if (fol.getLeft() != null) {
			left = formual2String(fol.getLeft());
		}
		if (fol.getRight() != null) {
			right = formual2String(fol.getRight());
		}
		if (fol.getOp() != null) {
			return left +" "+ fol.getOp() + " " + right;
		} else if (fol instanceof SymbolReferenceTerm) {
			return ((SymbolReferenceTerm) fol).getSymbol().getName();
		} else if (fol instanceof TermMemberSelection) {
			return formual2String(((TermMemberSelection) fol).getReceiver()) + "."
					+ formual2String(((TermMemberSelection) fol).getMember());
		} else if (fol instanceof AtomicExpression) {
			return left +" "+ ((AtomicExpression) fol).getRel().getLiteral() + " " + right;
		} else if (fol.getOp() != null) {
			return left +" "+ fol.getOp() + " " + right; 
		} else if (fol instanceof SignedAtomicFormula) {
			return (((SignedAtomicFormula) fol).isNeg()?"!":"") + left; 
		} else if (fol instanceof TailedExpression) {
			String tailedString;
			if (((TailedExpression) fol).getTail() instanceof ArrayAccess) {
				tailedString = "[" +formual2String(((ArrayAccess)((TailedExpression) fol).getTail()).getIndex()) + "]"; 
			} else {
				tailedString = "(" + ((TupleConstructor)((TailedExpression) fol).getTail()).getElements().stream()
								.map(FormulaHelper::formual2String).reduce((acc, curr) -> acc + ',' + curr).orElse("") 
								+")";
			}
			return left + tailedString;
		} else if (fol instanceof ParenthesizedTerm) { 
			return "(" + fol + ")";
		} else if (fol instanceof TruthValue) {
			return ((TruthValue) fol).isTRUE()? "true": "false";
		} else {
			return "___FORMULA_NOT_SUPPORTED__";
		}
	}
	
}
