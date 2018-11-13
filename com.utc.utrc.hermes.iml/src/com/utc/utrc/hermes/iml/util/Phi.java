package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.RelationKind;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;

public class Phi {
	
	private FolFormula retval;
	
	
	public Phi() {
		retval = null ;
		
	}
	
	public FolFormula build() {
		if (retval == null) {
			retval = ImlCustomFactory.INST.createSignedAtomicFormula() ;
			retval.setLeft( ImlCustomFactory.INST.createTruthValue(true)  );
			((SignedAtomicFormula) retval).setNeg(false);
		}
		if (retval instanceof AtomicExpression) {
			SignedAtomicFormula tmp = ImlCustomFactory.INST.createSignedAtomicFormula() ;
			tmp.setLeft( retval  );
			((SignedAtomicFormula) tmp).setNeg(false);
			retval = tmp ;
		}
		return retval; 
	}
	
	public FolFormula get() {
		return retval;
	}
	
	public Phi rel(RelationKind r, TermExpression other) {
		if (retval instanceof TermExpression) {
			retval  = ImlCustomFactory.INST.createAtomicExpression((TermExpression) retval, r , other) ;	
		}
		return this;
	}
	
	
	public Phi and(FolFormula other) {
		retval = ImlCustomFactory.INST.createAndExpression(retval, other);
		return this;
	}
	
	public Phi or(FolFormula other) {
		retval = ImlCustomFactory.INST.createOrExpression(retval, other);
		return this;
	}
	
	public Phi set(FolFormula e ) {
		retval = e ;
		return this;
	}
	
	public Phi termSelection(SymbolDeclaration sd) {
		retval = ImlCustomFactory.INST.createSymbolReferenceTerm(sd) ;
		return this;
	}
	
	public Phi termSelection(SymbolDeclaration receiver, SymbolDeclaration member) {
		retval = ImlCustomFactory.INST.createTermMemberSelection(receiver, member) ;
		return this;
	}
	
	public Phi termSelection(SymbolDeclaration sd1, SymbolDeclaration sd2, SymbolDeclaration sd3) {
		TermMemberSelection tms1 = ImlCustomFactory.INST.createTermMemberSelection() ;
		tms1.setReceiver(ImlCustomFactory.INST.createSymbolReferenceTerm(sd1));
		tms1.setMember(ImlCustomFactory.INST.createTermMemberSelection(sd2,sd3));
		return this;
	}
	
		
	
	
}
