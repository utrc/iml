/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.eclipse.emf.ecore.util.EcoreUtil;

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory;
import com.utc.utrc.hermes.iml.iml.AndExpression;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.OrExpression;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.RelationKind;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.TermExpression;

public class Phi {
	
	public static AndExpression and(FolFormula left, FolFormula right) {
		AndExpression retval = ImlCustomFactory.INST.createAndExpression();
		retval.setLeft(left);
		retval.setRight(right);
		retval.setOp("&&");
		return retval;
	}
	public static OrExpression or(FolFormula left, FolFormula right) {
		OrExpression retval = ImlCustomFactory.INST.createOrExpression();
		retval.setLeft(left);
		retval.setRight(right);
		retval.setOp("||");
		return retval;
	}
	
	public static SignedAtomicFormula signed(boolean neg, FolFormula e) {
		SignedAtomicFormula retval = ImlCustomFactory.INST.createSignedAtomicFormula();
		retval.setNeg(neg);
		retval.setLeft(e);
		return retval;
	}
	public static SignedAtomicFormula signed(FolFormula e) {
		return signed(false,e);
	}
	
	public static SignedAtomicFormula signedPar(boolean neg, FolFormula e) {
		ParenthesizedTerm pt = ImlCustomFactory.INST.createParenthesizedTerm();
		pt.setSub(e);
		return signed(neg,pt);
	}
	public static SignedAtomicFormula signedPar(FolFormula e) {
		return signedPar(false,e);
	}
	
	public static SignedAtomicFormula eq(TermExpression left, TermExpression right) {
		AtomicExpression retval  = ImlCustomFactory.INST.createAtomicExpression(left, RelationKind.EQ , right) ;	
		return signed(false,retval);
	}
	
	public static FolFormula toCNF(FolFormula f) {
		List<List<FolFormula> > cnflist = toCNFList(f, false);
		
		FolFormula retval = null ;
		for(List<FolFormula> lf : cnflist) {
			// if (! isTrue(lf)) {  //for some reason this piece of code does not work. Strange!
				FolFormula clause = null ;
				for(FolFormula cf : lf) {
					if (clause == null) {
						clause = cf ;
					} else {
						clause = Phi.or(EcoreUtil.copy(clause),cf);
					}
				}
				if (retval == null) {
					retval = Phi.signedPar(clause);
				} else {
					retval = Phi.and(EcoreUtil.copy(retval),Phi.signedPar(clause)) ;
				}
			// }
		}
		
		return retval;
	
	} 
	
	public static List<FolFormula> getConjuncts(FolFormula f){
		List<FolFormula> retval = new ArrayList<>();
		
		if (f instanceof AndExpression) {
			retval.addAll(getConjuncts(f.getLeft()));
			retval.addAll(getConjuncts(f.getRight()));
		} else if (f instanceof ParenthesizedTerm) {
			retval.add(((ParenthesizedTerm) f).getSub());
		} else {
			retval.add(f);
		}
		
		return retval; 
	}
	
	public static List< List<FolFormula> > toCNFList(FolFormula f, boolean neg){
		List<List<FolFormula>> retval = new ArrayList<>();
		if (f instanceof AndExpression && ! neg) {
			retval.addAll(toCNFList(f.getLeft(),false));
			retval.addAll(toCNFList(f.getRight(),false));
		}else if (f instanceof OrExpression && neg) {
			retval.addAll(toCNFList(f.getLeft(),true));
			retval.addAll(toCNFList(f.getRight(),true));
		} else if ( f instanceof OrExpression && !neg ) {
			List< List<FolFormula> > left = toCNFList(f.getLeft(),false);
			List< List<FolFormula> > right = toCNFList(f.getRight(),false);
			for(List<FolFormula> l : left) {
				for(List<FolFormula> r : right) {
					List<FolFormula> clause =  new ArrayList<>();
					clause.addAll(l);
					clause.addAll(r);
					retval.add(clause);
				}	
			}
		}else if (f instanceof AndExpression && neg) {
			List< List<FolFormula> > left = toCNFList(f.getLeft(),true);
			List< List<FolFormula> > right = toCNFList(f.getRight(),true);
			for(List<FolFormula> l : left) {
				for(List<FolFormula> r : right) {
					List<FolFormula> clause =  new ArrayList<>();
					clause.addAll(l);
					clause.addAll(r);
					retval.add(clause);
				}	
			}
		} else if (f.getOp() != null && f.getOp().equals("=>") && ! neg) {
			List< List<FolFormula> > left = toCNFList(f.getLeft(),true);
			List< List<FolFormula> > right = toCNFList(f.getRight(),false);
			for(List<FolFormula> l : left) {
				for(List<FolFormula> r : right) {
					List<FolFormula> clause =  new ArrayList<>();
					clause.addAll(l);
					clause.addAll(r);
					retval.add(clause);
				}	
			}
		} else if (f.getOp() != null && f.getOp().equals("=>") && neg) {
			retval.addAll(toCNFList(f.getLeft(),false));
			retval.addAll(toCNFList(f.getRight(),true));
		} else if (f instanceof SignedAtomicFormula) {
			retval.addAll(toCNFList(f.getLeft(), neg ^ ((SignedAtomicFormula)f).isNeg()));
		}  else if (f instanceof ParenthesizedTerm) {
			retval.addAll(toCNFList(((ParenthesizedTerm) f).getSub(),neg));
		} else {
			retval.add(Arrays.asList(Phi.signed(neg,EcoreUtil.copy(f)))) ;
		}
		return retval;
	}
	

	
	public static boolean isTrue(List<FolFormula> clause) {
		for(int i = 0 ; i < clause.size() ; i++) {
			if (clause.get(i) instanceof SignedAtomicFormula) {
				SignedAtomicFormula left = (SignedAtomicFormula) clause.get(i);
				for(int j = i+1; j < clause.size() ; j++) {
					if (clause.get(j) instanceof SignedAtomicFormula) {
						SignedAtomicFormula right = (SignedAtomicFormula) clause.get(j);
						if ( left.isNeg() ^ right.isNeg() ) {
							if (EcoreUtil.equals(left.getLeft(), right.getLeft())) {
								return true ;
							}
						}
					}
				}
			}
		}
		return false;
	}

		
	
	
}
