package com.utc.utrc.hermes.iml.util;

import com.google.inject.Inject;
import com.google.inject.Singleton;
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.AndExpression;
import com.utc.utrc.hermes.iml.iml.ArrayAccess;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.ExpressionTail;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.OrExpression;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TailedExpression;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.lib.ImlStdLib;
import static org.eclipse.emf.ecore.util.EcoreUtil.copy;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Singleton
public class TermExpander {
	
	@Inject
	ImlStdLib stdLib;
	
	/**
	 * This method expand a given term to its atomic variables. For example, given a term <b>a.b or c</b> 
	 *  while <b> b := x and y </b> and <b>b := false</b>, the result is <b>a.x and a.y or false</b>
 	 * @param fol
	 * @return
	 */
	public FolFormula expand(FolFormula fol) {
		return expand(fol, null);
	}
	
	public FolFormula expand(FolFormula fol, TermExpression ctx) {
		if (fol == null) {
			return null;
		}
		FolFormula left = expand(fol.getLeft(), ctx);
		FolFormula right = expand(fol.getRight(), ctx);
		if (fol instanceof SymbolReferenceTerm && ((SymbolReferenceTerm) fol).getSymbol() instanceof SymbolDeclaration) {
			SymbolDeclaration symbol = (SymbolDeclaration) ((SymbolReferenceTerm) fol).getSymbol();
			if (symbol.getDefinition() != null && stdLib.isPrimitive(symbol.getType())) {
				return expand(symbol.getDefinition(), ctx);
			}
			return tms(copy(ctx), copy((SymbolReferenceTerm) fol));
		} else if (fol instanceof TermMemberSelection) {
			TermExpression receiver = ((TermMemberSelection) fol).getReceiver();
			TermExpression member = ((TermMemberSelection) fol).getMember();
			ctx = tms(copy(ctx), copy(receiver));
			return expand(member, ctx);
		} else if (fol instanceof SignedAtomicFormula) {
			if (((SignedAtomicFormula) fol).isNeg()) {
				return ImlCustomFactory.INST.createSignedAtomicFormula(((SignedAtomicFormula) fol).isNeg(), left);
			} else {
				return left;
			}
		} else if (fol instanceof OrExpression) {
			return ImlCustomFactory.INST.createOrExpression(left, right);
		} else if (fol instanceof AndExpression) {
			return ImlCustomFactory.INST.createAndExpression(left, right);
		} else if (fol instanceof Addition) {
			return ImlCustomFactory.INST.createAddition((TermExpression) left, ((Addition) fol).getSign(), (TermExpression) right);
		} else if (fol instanceof Multiplication) {
			return ImlCustomFactory.INST.createAddition((TermExpression) left, ((Addition) fol).getSign(), (TermExpression) right);
		} else if (fol instanceof AtomicExpression) {
			return ImlCustomFactory.INST.createAtomicExpression((TermExpression) left, ((AtomicExpression) fol).getRel(), (TermExpression) right);
		} else if (fol instanceof TailedExpression) {
			ExpressionTail tail = ((TailedExpression) fol).getTail();
			ExpressionTail expandedTail;
			if (tail instanceof ArrayAccess) {
				expandedTail = ImlCustomFactory.INST.createArrayAccess(expand(((ArrayAccess) tail).getIndex(), ctx));
			} else {
				List<FolFormula> params = new ArrayList<>();
				for (FolFormula par : ((TupleConstructor) tail).getElements()) {
					params.add(expand(par, ctx));
				}
				expandedTail = ImlCustomFactory.INST.createTupleConstructor(params);
			}
			
			return ImlCustomFactory.INST.createTailedExpression((TermExpression) left, expandedTail);
		}
		return copy(fol);
	}

	private TermExpression tms(TermExpression reciever, TermExpression member) {
		if (reciever != null) {
			return ImlCustomFactory.INST.createTermMemberSelection(reciever, member);
		} else {
			return member;
		}
	}

}
