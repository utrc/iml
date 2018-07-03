package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.ArrayList;
import java.util.List;
import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.generator.infra.EncodedSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SExpr.Seq;
import com.utc.utrc.hermes.iml.generator.infra.SExprTokens;
import com.utc.utrc.hermes.iml.generator.infra.SrlFactory;
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId;
import com.utc.utrc.hermes.iml.generator.infra.SrlTerm;
import com.utc.utrc.hermes.iml.generator.infra.SrlTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SymbolTable;
import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.NumberLiteral;
import com.utc.utrc.hermes.iml.iml.Program;
import com.utc.utrc.hermes.iml.iml.RelationKind;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TypeConstructor;

public class FunctionEncodeStrategy implements IStrategy {

	@Inject
	SrlFactory factory;

	@Override
	public void encode(SymbolTable st) {
		for (SrlSymbolId id : st.getSymbols().keySet()) {
			EncodedSymbol es = (st.getSymbols()).get(id);
			if (es.getEncoding() == null) {
				if (es.getSymbol() instanceof SrlNamedTypeSymbol) {
					SrlNamedTypeSymbol nts = (SrlNamedTypeSymbol) es.getSymbol();
					if (!nts.isTemplate()) {
						List<Seq> seqList = new ArrayList<>();
						Seq seq = new SExpr.Seq();
						encodeSort(nts, seq); // declare sort
						seqList.add(seq);
						if (!nts.getRelations().isEmpty()) { // handle extension
							for (SrlObjectSymbol sos : nts.getRelations()) {
								if (sos.getName().equals("rel_0")) { // extension; single extension assumption???
									seqList.add(encodeExtension(nts, sos));
								}
							}
						}
						for (SrlObjectSymbol os : nts.getSymbols()) {
							seqList.addAll(encode(os));
						}
						es.setEncoding(seqList);
					}					
					
				} else if (es.getSymbol() instanceof SrlObjectSymbol) {
					List<Seq> seqList = new ArrayList<>();
					encodeTLObjectSymbol((SrlObjectSymbol)es.getSymbol(), seqList);
					es.setEncoding(seqList);
				} else if (es.getSymbol() instanceof SrlHigherOrderTypeSymbol) {
					SrlHigherOrderTypeSymbol hots = (SrlHigherOrderTypeSymbol) es.getSymbol();
					String realizedTemplateName = "";
					if (!hots.getBindings().isEmpty()) { // dealing with realized template type
						es.setEncoding(encodeBoundedTemplateType(hots));
					} else {
						if (!hots.isHigherOrder()) {
							SrlTypeSymbol dmn = (SrlTypeSymbol) hots.getDomain();
							if (dmn instanceof SrlNamedTypeSymbol) {
								SrlNamedTypeSymbol namedDmn = (SrlNamedTypeSymbol) dmn;
								if (!namedDmn.isMeta()) {
									es.setEncoding(encode(namedDmn, realizedTemplateName));
								}
							} 
						} 
					}
				}
			}
		}
	}
	
	
	public SExpr assemble(SymbolTable table) {
		Seq result = new SExpr.Seq();
		for (EncodedSymbol value : table.getSymbols().values()) {
			if (value.getEncoding() != null) {
				for (Seq seq : value.getEncoding()) {
					result.add(seq);
				}
			}
		}
		return result;
	}

	private List<Seq> encodeBoundedTemplateType(SrlHigherOrderTypeSymbol hots) {
		List<Seq> seqList = new ArrayList<>();
		if (!hots.isHigherOrder()) {
			SrlTypeSymbol dmn = (SrlTypeSymbol) hots.getDomain();
			if (dmn instanceof SrlNamedTypeSymbol) {
				SrlNamedTypeSymbol namedDmn = (SrlNamedTypeSymbol) dmn;
				seqList.addAll(encode(namedDmn, hots.getName(), hots.getBindings()));
			}
		}
		return seqList;
	}

	private List<Seq> encode(SrlNamedTypeSymbol t, String realizedTemplateName, List<SrlTypeSymbol> bindings) {
		List<Seq> seqList = new ArrayList<>();
		
		if (!t.isMeta()) {
			if (t.getProperties().isEmpty()) {
				if (t.isTemplate()) {
					if (t.getRelations().isEmpty()) {
						if (!(t.getContainer().toString()).equals("iml.lang")) {
							Seq seq = new SExpr.Seq();
							seq.add(SExprTokens.DECLARE_SORT);
							String fqRealizedTemplateName = t.stringId().replaceAll(t.getName(), realizedTemplateName);
							seq.add(SExprTokens.createToken(fqRealizedTemplateName));
							seq.add(SExprTokens.createToken(0));
							seqList.add(seq);
						}
					} 
				} else {
					if (t.getRelations().isEmpty()) {
						if (!(t.getContainer().toString()).equals("iml.lang")) {
							// double check gqw originally directly appended to retVal
//							retVal.add(SExprTokens.DECLARE_SORT);
//							retVal.add(SExprTokens.createToken(t.stringId()));
							Seq seq = new SExpr.Seq();
							seq.add(SExprTokens.DECLARE_SORT);
							seq.add(SExprTokens.createToken(t.stringId()));
							seq.add(SExprTokens.createToken(0));
							seqList.add(seq);
						}
					} else {
						// handle sameas
						SrlObjectSymbol os = (t.getRelations()).get(0);
						if (!(os.getType().getContainer().toString()).equals("iml.lang")) {
							// double check gqw originally directly appended to retVal
//							retVal.add(SExprTokens.DECLARE_SORT);
//							retVal.add(SExprTokens.createToken((os.getType().getContainer() + "." + os.getType().getName())));
							Seq seq = new SExpr.Seq();
							seq.add(SExprTokens.DECLARE_SORT);
							seq.add(SExprTokens.createToken((os.getType().getContainer() + "." + os.getType().getName())));
							seq.add(SExprTokens.createToken(0));
							seqList.add(seq);
						}
					}
				}
			}
		}
		// Process its symbols
		for (SrlObjectSymbol os : t.getSymbols()) {
			seqList.addAll(encode(os, t, bindings, realizedTemplateName));
		}
		return seqList;
	}

	private List<Seq> encode(SrlObjectSymbol s, SrlNamedTypeSymbol t, List<SrlTypeSymbol> bindings,
			String realizedTemplateName) {
		List<Seq> seqList = new ArrayList<>();
		Seq retVal = new SExpr.Seq();
		SrlTerm def = s.getDefinition();
		if (def == null) {
			retVal.add(SExprTokens.DECLARE_FUN);
		} else {
			retVal.add(SExprTokens.DEFINE_FUN);
		}
		String nm = s.stringId().replaceAll(t.getName(), realizedTemplateName);
		retVal.add(SExprTokens.createToken(nm));

		retVal.add(SExprTokens.createToken("("));
		retVal.add(SExprTokens.createToken(s.getDefinition() == null ? "" : "("));
		retVal.add(SExprTokens.createToken(s.getDefinition() == null ? "" : "x!1"));
		nm = s.getContainer().toString().replaceAll(t.getName(), realizedTemplateName);
		retVal.add(SExprTokens.createToken(nm));
		retVal.add(SExprTokens.createToken(s.getDefinition() == null ? "" : ")"));
		retVal.add(SExprTokens.createToken(")"));

		if ((s.getType()) instanceof SrlHigherOrderTypeSymbol) {
			SrlHigherOrderTypeSymbol hots = (SrlHigherOrderTypeSymbol) s.getType();
			if (!hots.isHigherOrder()) {
				if (hots.getDomain() instanceof SrlNamedTypeSymbol) {
					SrlNamedTypeSymbol nts = (SrlNamedTypeSymbol) hots.getDomain();
					// check whether nts is a parameter
					int idx;
					for (idx = 0; idx < t.getParameters().size(); ++idx) {
						if (nts.equals(t.getParameters().get(idx)))
							break;
					}
					if (idx == t.getParameters().size()) {
						if (!nts.getContainer().toString().equals("iml.lang")) {
							retVal.add(SExprTokens.createToken(nts.stringId()));
						} else {
							retVal.add(SExprTokens.createToken(nts.getName()));
						}
					} else { // parameter
						SrlTypeSymbol boundT = bindings.get(idx);
						if (boundT instanceof SrlHigherOrderTypeSymbol) {
							SrlHigherOrderTypeSymbol boundHot = (SrlHigherOrderTypeSymbol) boundT;
							if (!boundHot.isHigherOrder()) {
								SrlSymbol dmn = boundHot.getDomain();
								if (dmn instanceof SrlNamedTypeSymbol) {
									SrlNamedTypeSymbol snts = (SrlNamedTypeSymbol) dmn;
									if (snts.getRelations().isEmpty()) {
										if (!snts.getContainer().toString().equals("iml.lang")) {
											retVal.add(SExprTokens.createToken(snts.stringId()));
										} else {
											retVal.add(SExprTokens.createToken(snts.getName()));
										}
									} else {
										// sameas info
										retVal.add(SExprTokens
												.createToken(snts.getRelations().get(0).getType().getName()));
									}
								}
							}
						}
					}
				} 
			} 
		} else if ((s.getType()) instanceof SrlNamedTypeSymbol) {
			SrlNamedTypeSymbol snts = (SrlNamedTypeSymbol) s.getType();
			retVal.add(SExprTokens.createToken(snts.stringId()));
		}
		// process definition
		if (def != null) { // need to worry about template parameter
			FolFormula f = def.getFormula();
//			encodeWithTemplatePar(f, retVal, t.getName(), realizedTemplateName);			
//			need to consolidate
			encode(f, retVal, null, null, t.getName(), realizedTemplateName);
		}
		seqList.add(retVal);
		return seqList;
	}

	private boolean isTypeConstructor(SrlTerm st) {
		boolean retVal = false;
		FolFormula f = st.getFormula();
		FolFormula fl = f.getLeft();
		if (fl instanceof TermExpression) {
			if (fl instanceof TypeConstructor) {
				retVal = true;
			}
		}
		return retVal;
	}
	
	private void encodeTLObjectSymbol(SrlObjectSymbol s, List<Seq> seqList) {
		Seq retVal = new SExpr.Seq();
		retVal.add(SExprTokens.DECLARE_FUN);
		retVal.add(SExprTokens.createToken(s.stringId()));
		retVal.add(SExprTokens.OPEN_PARANTHESIS);
		retVal.add(SExprTokens.CLOSE_PARANTHESIS);
		if (s.getType() instanceof SrlNamedTypeSymbol) {
			SrlNamedTypeSymbol snts = (SrlNamedTypeSymbol) s.getType();
			retVal.add(SExprTokens.createToken(snts.stringId()));
			seqList.add(retVal);

			for (SrlObjectSymbol sos : snts.getSymbols()) {
				if (sos.getType().getName().contains("Connection")) {
					retVal = new SExpr.Seq();
					retVal.add(SExprTokens.ASSERT);
					Seq initSExpr = new SExpr.Seq();
					initSExpr.add(SExprTokens.EQ);
					initSExpr.add(SExprTokens.OPEN_PARANTHESIS);
					initSExpr.add(SExprTokens.createToken(sos.stringId() + ".init " + s.stringId()));
					initSExpr.add(SExprTokens.CLOSE_PARANTHESIS);
					initSExpr.add(SExprTokens.TRUE);
					retVal.add(initSExpr);
					seqList.add(retVal);
					
					retVal = new SExpr.Seq();
					retVal.add(SExprTokens.ASSERT);
					Seq connA1SExpr = new SExpr.Seq();
					connA1SExpr.add(SExprTokens.EQ);
					connA1SExpr.add(SExprTokens.OPEN_PARANTHESIS);
					connA1SExpr.add(SExprTokens.createToken(sos.getType().stringId() + ".a1"));
					connA1SExpr.add(SExprTokens.OPEN_PARANTHESIS);
					connA1SExpr.add(SExprTokens.createToken(sos.stringId()));
					connA1SExpr.add(SExprTokens.createToken(s.stringId()));
					connA1SExpr.add(SExprTokens.CLOSE_PARANTHESIS);
					connA1SExpr.add(SExprTokens.CLOSE_PARANTHESIS);
					connA1SExpr.add(SExprTokens.TRUE);
					retVal.add(connA1SExpr);

					seqList.add(retVal);				
				}
			}		
		}	
	}

	@Override
	public List<Seq> encode(SrlObjectSymbol s) {
		List<Seq> seqList = new ArrayList<>();		
		Seq retVal = new SExpr.Seq();
		
		SrlTerm def = s.getDefinition();
		boolean donotGenParam = true;
		if (def == null) {
			retVal.add(SExprTokens.DECLARE_FUN);
		} else {
			if (isTypeConstructor(def)) {
				retVal.add(SExprTokens.DECLARE_FUN);
				
			} else {
				retVal.add(SExprTokens.DEFINE_FUN);
				donotGenParam = false;
			}
		}
		retVal.add(SExprTokens.createToken(s.stringId()));
		retVal.add(SExprTokens.createToken("("));
		retVal.add(SExprTokens.createToken(donotGenParam ? "" : "("));
		retVal.add(SExprTokens.createToken(donotGenParam ? "" : "x!1"));
		retVal.add(SExprTokens.createToken(s.getContainer().toString()));
		retVal.add(SExprTokens.createToken(donotGenParam ? "" : ")"));
		retVal.add(SExprTokens.createToken(")"));		
		
		String origName = "";
		String realizedName = "";
		if ((s.getType()) instanceof SrlHigherOrderTypeSymbol) {
			SrlHigherOrderTypeSymbol hots = (SrlHigherOrderTypeSymbol) s.getType();
			if (!hots.isHigherOrder()) {
				if (!hots.getBindings().isEmpty()) {
					realizedName = hots.getName();
				}
				if (hots.getDomain() instanceof SrlNamedTypeSymbol) {
					SrlNamedTypeSymbol nts = (SrlNamedTypeSymbol) hots.getDomain();
					// get the bound type from relation
					if (nts.getRelations().isEmpty()) {
						if (!nts.getContainer().toString().equals("iml.lang")) {
							if (realizedName.isEmpty()) {
								retVal.add(SExprTokens.createToken(nts.stringId()));
							} else {
								origName = nts.getName();
								retVal.add(SExprTokens
										.createToken(nts.stringId().replaceAll(origName, realizedName)));
							}
						} else {
							retVal.add(SExprTokens.createToken(nts.getName()));
						}
					} else {
						// sameas info
						retVal.add(SExprTokens.createToken(nts.getRelations().get(0).getType().getName()));
					}
				} 
			} 
		} else if ((s.getType()) instanceof SrlNamedTypeSymbol) {
			SrlNamedTypeSymbol snts = (SrlNamedTypeSymbol) s.getType();
			retVal.add(SExprTokens.createToken(snts.stringId()));
		}
		// process definition
		if (def != null && !isTypeConstructor(def)) {
			FolFormula f = def.getFormula();
//			encode(f, retVal, null);			
//			Need to change
			encode(f, retVal, null, null, null, null);
		}
		seqList.add(retVal);
		if (def != null && isTypeConstructor(def)) {
			// generate init function
			seqList.add(encodeInit(s, origName, realizedName));
		}
		return seqList;
	}

	private Seq encodeInit(SrlObjectSymbol s, String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		SrlTerm def = s.getDefinition();
		retVal.add(SExprTokens.DEFINE_FUN);
		retVal.add(SExprTokens.createToken(s.stringId() + ".init"));
		retVal.add(SExprTokens.createToken("("));
		retVal.add(SExprTokens.createToken("("));
		retVal.add(SExprTokens.createToken("x!1"));
		retVal.add(SExprTokens.createToken(s.getContainer().toString()));
		retVal.add(SExprTokens.createToken(")"));
		retVal.add(SExprTokens.createToken(")"));
		retVal.add(SExprTokens.createToken("Bool"));
		FolFormula f = def.getFormula();
		encodeInitBody(f, s, retVal, origName, replacement);
		return retVal;
	}

	private void encodeInitBody(FolFormula f, SrlObjectSymbol s, Seq retVal, String origName, String replacement) {
		SignedAtomicFormula saf = (SignedAtomicFormula) f;
		FolFormula lFol = saf.getLeft();
		TypeConstructor tc = (TypeConstructor) lFol;
		Program init = (Program) tc.getInit();
		Seq seq = new SExpr.Seq();
		seq.add(SExprTokens.AND);
//		encodeInitWithTemplatePar(init.getRelations().get(0), seq, null, s, origName, replacement);		
//		need to consolidate
		encode(init.getRelations().get(0), seq, null, s, origName, replacement);		
		
//		encodeInitWithTemplatePar(init.getRelations().get(1), seq, null, s, origName, replacement);
//		need to consolidate
		encode(init.getRelations().get(1), seq, null, s, origName, replacement);
		
		retVal.add(seq);
	}
	
    public SExpr encode(FolFormula formula) {
    	Seq result = new Seq();
//		encode(formula, result, null);
//		need to consoditate
		encode(formula, result, null, null, null, null);
		return result;
	}

/*
	public void encode(FolFormula f, Seq seq, TermExpression rcv) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.AND);
				encode(f.getLeft(), retVal, rcv);
				encode(f.getRight(), retVal, rcv);
				seq.add(retVal);
			} else if (op.equals("||")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.OR);
				encode(f.getLeft(), retVal, rcv);
				encode(f.getRight(), retVal, rcv);
				seq.add(retVal);
			} else if (op.equals("=>")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.IMPLICATION);
				encode(f.getLeft(), retVal, rcv);
				encode(f.getRight(), retVal, rcv);
				seq.add(retVal);
			}
			// TOIMPLEMENT, <=>, forall, exists
		} else {
			if (f instanceof SignedAtomicFormula) {
				SignedAtomicFormula safi = (SignedAtomicFormula) f;
				FolFormula leftFol = safi.getLeft();
				if (leftFol instanceof AtomicExpression) {
					AtomicExpression aei = (AtomicExpression) leftFol;
					encode(aei, seq, rcv);
				} else if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					encode(tci, seq, rcv);
				} else if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}  else if (leftFol instanceof FloatNumberLiteral) {
					FloatNumberLiteral nli = (FloatNumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
				} else if (leftFol instanceof SymbolReferenceTerm) {
//					SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol;
					encode(leftFol, seq, rcv);
				} else if (leftFol instanceof TermMemberSelection) {
					TermMemberSelection tms = (TermMemberSelection) leftFol;
					TermExpression rcv_ = tms.getReceiver();
					TermExpression mbr = tms.getMember();
					if (mbr instanceof SymbolReferenceTerm) {
						SymbolReferenceTerm srt = (SymbolReferenceTerm) mbr;
						encode(srt, seq, rcv_);
						encode (rcv_, seq, null);
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
			} else if (f instanceof SymbolReferenceTerm) {
				encode ((SymbolReferenceTerm) f, seq);
			} else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			} else if (f instanceof FloatNumberLiteral) {
				FloatNumberLiteral nli = (FloatNumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			} else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(mi.getSign())); 
				encode(mi.getLeft(), retVal, rcv);
				encode(mi.getRight(), retVal, rcv);
				seq.add(retVal);
			} else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(ai.getSign())); 
				encode(ai.getLeft(), retVal, rcv);
				encode(ai.getRight(), retVal, rcv);
				seq.add(retVal);

			} else if (f instanceof AtomicExpression) {
				Seq retVal = new SExpr.Seq();
				AtomicExpression ae = (AtomicExpression) f;
				encode(ae, retVal, rcv);
				seq.add(retVal);
			} else if (f instanceof TermMemberSelection) { //????NEW
				TermMemberSelection tms = (TermMemberSelection) f;
				TermExpression rcv_ = tms.getReceiver();
				TermExpression mbr = tms.getMember();
				if (mbr instanceof SymbolReferenceTerm) {
					SymbolReferenceTerm srt = (SymbolReferenceTerm) mbr;
					encode(srt, seq, rcv_);
					if (rcv_ != null) {
						encode (rcv_, seq, null);
					}
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			} else if (f instanceof AndExpression) {
				
			}
		}
	}
*/
	/*
    // no receiver
	private void encode(SymbolReferenceTerm sr, Seq seq) {
		SymbolReferenceTerm srti = (SymbolReferenceTerm) sr;
		SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
		String sfqn = sdi.getName();
		String n = sdi.getName();
		if (!(sdi.eContainer() instanceof FolFormula)) {
			SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
			sfqn = srlObject.stringId();
		}
		if (srti.getTails() != null && !srti.getTails().isEmpty()) {
			seq.add(SExprTokens.OPEN_PARANTHESIS);
			if (n.equals("sqrt")) {
				seq.add(SExprTokens.createToken("pow"));
			} else {
				seq.add(SExprTokens.createToken(n));
			}
			SymbolReferenceTail srtailI = srti.getTails().get(0);
			if (srtailI instanceof TupleConstructor) {
//				encode(((TupleConstructor) srtailI).getElements().get(0), seq, null);
//				need to consolidate
				encode(((TupleConstructor) srtailI).getElements().get(0), seq, null, null, null, null);
			}
			if (n.equals("sqrt")) {
				seq.add(SExprTokens.createToken(0.5f));
			}
			seq.add(SExprTokens.CLOSE_PARANTHESIS);
		} else {
			if (!(sdi.eContainer() instanceof FolFormula) && !(sdi.eContainer() instanceof Model)) {
				seq.add(SExprTokens.OPEN_PARANTHESIS);
			}
			seq.add(SExprTokens.createToken(sfqn));
			if (!(sdi.eContainer() instanceof FolFormula) && !(sdi.eContainer() instanceof Model)) {
				seq.add(SExprTokens.createToken(" x!1"));
				seq.add(SExprTokens.CLOSE_PARANTHESIS);
			}
		}
	}
*/
	private void encode(SymbolReferenceTerm f, Seq seq, TermExpression rcv) {
		SymbolReferenceTerm srti = (SymbolReferenceTerm) f;
		SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
		String sfqn = sdi.getName();
		String n = sdi.getName();
		if (!(sdi.eContainer() instanceof FolFormula)) {
			SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
			sfqn = srlObject.stringId();
		}
		if (srti.getTails() != null && !srti.getTails().isEmpty()) {
			seq.add(SExprTokens.OPEN_PARANTHESIS);
			seq.add(SExprTokens.createToken(n));
			SymbolReferenceTail srtailI = srti.getTails().get(0);
			if (srtailI instanceof TupleConstructor) {
//				encode(((TupleConstructor) srtailI).getElements().get(0), seq, rcv);				
//				Need to consolidate
				encode(((TupleConstructor) srtailI).getElements().get(0), seq, rcv, null, null, null);				
			}
			seq.add(SExprTokens.CLOSE_PARANTHESIS);
		} else {
			if (!(sdi.eContainer() instanceof FolFormula)) {
				seq.add(SExprTokens.OPEN_PARANTHESIS);
			}
			seq.add(SExprTokens.createToken(sfqn));
		}
	}	
/*	
	public void encodeWithTemplatePar(FolFormula f, Seq seq, String origName, String replacement) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();
				retVal.sexprs().add(SExprTokens.AND);
				encodeWithTemplatePar(f.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(f.getRight(), retVal, origName, replacement);
				seq.add(retVal);
			} else if (op.equals("||")) {
				Seq retVal = new SExpr.Seq();
				retVal.sexprs().add(SExprTokens.OR);
				encodeWithTemplatePar(f.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(f.getRight(), retVal, origName, replacement);
				seq.add(retVal);
			}
		} else {
			if (f instanceof SignedAtomicFormula) {
				SignedAtomicFormula safi = (SignedAtomicFormula) f;
				FolFormula leftFol = safi.getLeft();
				if (leftFol instanceof AtomicExpression) {
					AtomicExpression aei = (AtomicExpression) leftFol;
					encodeWithTemplatePar(aei, seq, origName, replacement);
				} else if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					encodeWithTemplatePar(tci, seq, origName, replacement);
				} else if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}  else if (leftFol instanceof FloatNumberLiteral) {
					FloatNumberLiteral nli = (FloatNumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				} else if (leftFol instanceof SymbolReferenceTerm) {
//					SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol; // ?????? bugggggggg
					encodeWithTemplatePar(leftFol, seq, origName, replacement);
				}
			} else if (f instanceof SymbolReferenceTerm) {
				SymbolReferenceTerm srti = (SymbolReferenceTerm) f;
				SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
				String sfqn = sdi.getName();
				String n = sdi.getName();
				if (!(sdi.eContainer() instanceof FolFormula)) {
					SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
					sfqn = srlObject.stringId();
					sfqn = sfqn.replaceAll(origName, replacement);
				}
				if (srti.getTails() != null && !srti.getTails().isEmpty()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					if (n.equals("sqrt")) {
						seq.add(SExprTokens.createToken("pow"));
					} else {
						seq.add(SExprTokens.createToken(n));
					}
					SymbolReferenceTail srtailI = srti.getTails().get(0);
					if (srtailI instanceof TupleConstructor) {
						encodeWithTemplatePar(((TupleConstructor) srtailI).getElements().get(0), seq, origName,
								replacement);
					}
					if (n.equals("sqrt")) {
						seq.add(SExprTokens.createToken(0.5f));
					}
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				} else {
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
					}
					seq.add(SExprTokens.createToken(sfqn));
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.add(SExprTokens.createToken(" x!1"));
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
			} else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			}  else if (f instanceof FloatNumberLiteral) {
				FloatNumberLiteral nli = (FloatNumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			} else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(mi.getSign())); 
				encodeWithTemplatePar(mi.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(mi.getRight(), retVal, origName, replacement);
				seq.add(retVal);
			} else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(ai.getSign())); 
				encodeWithTemplatePar(ai.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(ai.getRight(), retVal, origName, replacement);
				seq.add(retVal);

			} else if (f instanceof AtomicExpression) {
				Seq retVal = new SExpr.Seq();
				AtomicExpression ae = (AtomicExpression) f;
				encodeWithTemplatePar(ae, retVal, origName, replacement);
				seq.add(retVal);
			}
		}
	}
*/
/*	
	private void encodeInitWithTemplatePar(FolFormula f, Seq seq, TermExpression rcv, SrlObjectSymbol s, String origName,
			String replacement) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.AND);
				encodeInitWithTemplatePar(f.getLeft(), retVal, rcv, s, origName, replacement);
				encodeInitWithTemplatePar(f.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (op.equals("||")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.OR); ////// ??????????????????????
				encodeInitWithTemplatePar(f.getLeft(), retVal, rcv, s, origName, replacement);				
				encodeInitWithTemplatePar(f.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			}
			// TOIMPLEMENT =>, <=>, forall, exists
		} else {
			if (f instanceof SignedAtomicFormula) {
				SignedAtomicFormula safi = (SignedAtomicFormula) f;
				FolFormula leftFol = safi.getLeft();
				if (leftFol instanceof AtomicExpression) {
					AtomicExpression aei = (AtomicExpression) leftFol;
					encodeInitWithTemplatePar(aei, seq, rcv, s, origName, replacement);
				} else if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					encodeInitWithTemplatePar(tci, seq, rcv, s, origName, replacement);
				} else if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}  else if (leftFol instanceof FloatNumberLiteral) {
					FloatNumberLiteral nli = (FloatNumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
				if (leftFol instanceof SymbolReferenceTerm) {
					// SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol; //??????
					// bugggggggg
					encodeInitWithTemplatePar(leftFol, seq, rcv, s, origName, replacement);
				}
			} else if (f instanceof SymbolReferenceTerm) {
				SymbolReferenceTerm srti = (SymbolReferenceTerm) f;
				SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
				String sfqn = sdi.getName();
				String n = sdi.getName();
				if (!(sdi.eContainer() instanceof FolFormula)) {
					SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
					sfqn = srlObject.stringId();
					sfqn = sfqn.replaceAll(origName, replacement);
				}
				if (srti.getTails() != null && !srti.getTails().isEmpty()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					if (n.equals("sqrt")) {
						seq.add(SExprTokens.createToken("pow"));
					} else {
						seq.add(SExprTokens.createToken(n));
					}
					SymbolReferenceTail srtailI = srti.getTails().get(0);
					if (srtailI instanceof TupleConstructor) {
						encodeInitWithTemplatePar(((TupleConstructor) srtailI).getElements().get(0), seq, rcv, s,
								origName, replacement);
					}
					if (n.equals("sqrt")) {
						seq.add(SExprTokens.createToken(0.5f));
					}
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				} else {
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
					}
					seq.add(SExprTokens.createToken(sfqn));
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						SrlHigherOrderTypeSymbol symCT = (SrlHigherOrderTypeSymbol) s.getType();
						// NOT CONSIDERING HOT
						SrlNamedTypeSymbol ct = (SrlNamedTypeSymbol) symCT.getDomain();
						String symbolFqn = ct.getContainer() + "." + ct.getName();
						if (sfqn.contains(symbolFqn)) {
							seq.add(SExprTokens.createToken(s.stringId()));
						} else {
							if (rcv != null) { // member selection
								String rcvStr = generateReveiverString(rcv);
								seq.add(SExprTokens.createToken(rcvStr));
							} else { // extension
								String ctnr1 = s.getContainer().toString();
								String ctnr2 = sfqn.substring(0, sfqn.lastIndexOf('.'));
								if (ctnr1.equals(ctnr2)) {
									seq.add(SExprTokens.createToken(sfqn));
								} else { // inherited
									seq.add(SExprTokens.createToken(ctnr1 + ".base_0"));
								}
							}
						}
						seq.add(SExprTokens.createToken("x!1"));
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
			} else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			}  else if (f instanceof FloatNumberLiteral) {
				FloatNumberLiteral nli = (FloatNumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			} else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(mi.getSign()));
				encodeInitWithTemplatePar(mi.getLeft(), retVal, rcv, s, origName, replacement);
				encodeInitWithTemplatePar(mi.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(ai.getSign()));
				encodeInitWithTemplatePar(ai.getLeft(), retVal, rcv, s, origName, replacement);
				encodeInitWithTemplatePar(ai.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);

			} else if (f instanceof AtomicExpression) {
				Seq retVal = new SExpr.Seq();
				AtomicExpression ae = (AtomicExpression) f;
				encodeInitWithTemplatePar(ae, retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (f instanceof TermMemberSelection) {
				TermMemberSelection tms = (TermMemberSelection) f;
				TermExpression rcv_ = tms.getReceiver();
				TermExpression mbr = tms.getMember();
				if (mbr instanceof SymbolReferenceTerm) {
					SymbolReferenceTerm srt = (SymbolReferenceTerm) mbr;
					encodeInitWithTemplatePar(srt, seq, rcv_, s, origName, replacement);
				}
			}
		}
	}
*/
///*	
	private void encode(FolFormula f, Seq seq, TermExpression rcv, SrlObjectSymbol s, String origName,
			String replacement) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.AND);
				encode(f.getLeft(), retVal, rcv, s, origName, replacement);
				encode(f.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (op.equals("||")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.OR);
				encode(f.getLeft(), retVal, rcv, s, origName, replacement);
				encode(f.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (op.equals("=>")) {
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.IMPLICATION);
				encode(f.getLeft(), retVal, rcv, s, origName, replacement);
				encode(f.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			}
			// TOIMPLEMENT <=>, forall, exists
		} else {
			if (f instanceof SignedAtomicFormula) {
				SignedAtomicFormula safi = (SignedAtomicFormula) f;
				FolFormula leftFol = safi.getLeft();
				if (leftFol instanceof AtomicExpression) {
					AtomicExpression aei = (AtomicExpression) leftFol;
					encode(aei, seq, rcv, s, origName, replacement);
				} else if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					encode(tci, seq, rcv, s, origName, replacement);
				} else if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}  else if (leftFol instanceof FloatNumberLiteral) {
					FloatNumberLiteral nli = (FloatNumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
						seq.add(SExprTokens.createToken("-"));
					}
					seq.add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				} else if (leftFol instanceof TermMemberSelection) {
					TermMemberSelection tms = (TermMemberSelection) leftFol;
					TermExpression rcv_ = tms.getReceiver();
					TermExpression mbr = tms.getMember();
					if (mbr instanceof SymbolReferenceTerm) {
						SymbolReferenceTerm srt = (SymbolReferenceTerm) mbr;
						encode(srt, seq, rcv_);
						if (rcv_ != null) {
							encode (rcv_, seq, null, s, origName, replacement);
						}
						seq.add(SExprTokens.CLOSE_PARANTHESIS);
					}
				} else if (leftFol instanceof SymbolReferenceTerm) {
					// SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol; //??????
					// bugggggggg
					encode(leftFol, seq, rcv, s, origName, replacement);
				}
				
				// need to consolidate symbolreferenceTerm
			} else if (f instanceof SymbolReferenceTerm) {
				SymbolReferenceTerm srti = (SymbolReferenceTerm) f;
				SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
				String sfqn = sdi.getName();
				String n = sdi.getName();
				if (!(sdi.eContainer() instanceof FolFormula)) {
					SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
					sfqn = srlObject.stringId();
					if (replacement != null) {
						sfqn = sfqn.replaceAll(origName, replacement);
					}
				}
				if (srti.getTails() != null && !srti.getTails().isEmpty()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					if (n.equals("sqrt")) {
						seq.add(SExprTokens.createToken("pow"));
					} else {
						seq.add(SExprTokens.createToken(n));
					}
					SymbolReferenceTail srtailI = srti.getTails().get(0);
					if (srtailI instanceof TupleConstructor) {
//						encodeInitWithTemplatePar(((TupleConstructor) srtailI).getElements().get(0), seq, rcv, s,
//								origName, replacement);
//						need to consolidate
						encode(((TupleConstructor) srtailI).getElements().get(0), seq, rcv, s,
								origName, replacement);
					}
					if (n.equals("sqrt")) {
						seq.add(SExprTokens.createToken(0.5f));
					}
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				} else {
					if (!(sdi.eContainer() instanceof FolFormula) && !(sdi.eContainer() instanceof Model)) {
						seq.add(SExprTokens.OPEN_PARANTHESIS);
					}
					seq.add(SExprTokens.createToken(sfqn));
					if (!(sdi.eContainer() instanceof FolFormula) && !(sdi.eContainer() instanceof Model)) {
						if (s != null) {						
							seq.add(SExprTokens.OPEN_PARANTHESIS);
							SrlHigherOrderTypeSymbol symCT = (SrlHigherOrderTypeSymbol) s.getType();
							// NOT CONSIDERING HOT
							SrlNamedTypeSymbol ct = (SrlNamedTypeSymbol) symCT.getDomain();
							String symbolFqn = ct.getContainer() + "." + ct.getName();
							if (sfqn.contains(symbolFqn)) {
								seq.add(SExprTokens.createToken(s.stringId()));
							} else {
								if (rcv != null) { // member selection
									String rcvStr = generateReveiverString(rcv);
									seq.add(SExprTokens.createToken(rcvStr));
								} else { // extension
									String ctnr1 = s.getContainer().toString();
									String ctnr2 = sfqn.substring(0, sfqn.lastIndexOf('.'));
									if (ctnr1.equals(ctnr2)) {
										seq.add(SExprTokens.createToken(sfqn));
									} else { // inherited
										seq.add(SExprTokens.createToken(ctnr1 + ".base_0"));
									}
								}
							}
						}
						if (rcv == null) {
							seq.add(SExprTokens.createToken("x!1"));
							seq.add(SExprTokens.CLOSE_PARANTHESIS);
						}
						if (s != null) {
							seq.add(SExprTokens.CLOSE_PARANTHESIS);
						}
					}
				}
			} else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			}  else if (f instanceof FloatNumberLiteral) {
				FloatNumberLiteral nli = (FloatNumberLiteral) f;
				if (nli.isNeg()) {
					seq.add(SExprTokens.OPEN_PARANTHESIS);
					seq.add(SExprTokens.createToken("-"));
				}
				seq.add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.add(SExprTokens.CLOSE_PARANTHESIS);
				}
			} else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(mi.getSign()));
				encode(mi.getLeft(), retVal, rcv, s, origName, replacement);
				encode(mi.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();
				retVal.add(SExprTokens.createToken(ai.getSign()));
				encode(ai.getLeft(), retVal, rcv, s, origName, replacement);
				encode(ai.getRight(), retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (f instanceof AtomicExpression) {
				Seq retVal = new SExpr.Seq();
				AtomicExpression ae = (AtomicExpression) f;
				encode(ae, retVal, rcv, s, origName, replacement);
				seq.add(retVal);
			} else if (f instanceof TermMemberSelection) {
				TermMemberSelection tms = (TermMemberSelection) f;
				TermExpression rcv_ = tms.getReceiver();
				TermExpression mbr = tms.getMember();
				if (mbr instanceof SymbolReferenceTerm) {
					SymbolReferenceTerm srt = (SymbolReferenceTerm) mbr;
					encode(srt, seq, rcv_, s, origName, replacement);
					if (rcv_ != null) {
						encode (rcv_, seq, null, s, origName, replacement);
					}
					seq.add(SExprTokens.CLOSE_PARANTHESIS); // ?? why need this???
				}
			}
		}
	}
	
//*/	
	
	
	private String generateReveiverString(TermExpression rcv) {
		String retVal = null;
		String op = rcv.getOp();
		if (op == null) {
			if (rcv instanceof SymbolReferenceTerm) {
				SymbolReferenceTerm srt = (SymbolReferenceTerm) rcv;
				SymbolDeclaration sd = (SymbolDeclaration) srt.getSymbol();
				SrlObjectSymbol srlObject = factory.createObjectSymbol(sd);
				return srlObject.stringId();
			}
		} 
		return retVal;
	}
/*
	public void encode(AtomicExpression aei, Seq seq, TermExpression rcv) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.add(SExprTokens.SMALLEREQ);
			encode(aei.getLeft(), retVal, rcv);
			encode(aei.getRight(), retVal, rcv);
		} else if (rk.getName().toString().equals("GEQ")) {
			retVal.add(SExprTokens.GREATEREQ);
			encode(aei.getLeft(), retVal, rcv);
			encode(aei.getRight(), retVal, rcv);
		} else if (rk.getName().toString().equals("EQ")) {
			retVal.add(SExprTokens.EQ);
			encode(aei.getLeft(), retVal, rcv);
			encode(aei.getRight(), retVal, rcv);
		} else if (rk.getName().toString().equals("LESS")) {
			retVal.add(SExprTokens.LESS);
			encode(aei.getLeft(), retVal, rcv);
			encode(aei.getRight(), retVal, rcv);
		} else if (rk.getName().toString().equals("GREATER")) {
			retVal.add(SExprTokens.GREATER);
			encode(aei.getLeft(), retVal, rcv);
			encode(aei.getRight(), retVal, rcv);
		}
		seq.add(retVal);
	}
*/
/*	
	public void encodeWithTemplatePar(AtomicExpression aei, Seq seq, String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.add(SExprTokens.SMALLEREQ);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		} else if (rk.getName().toString().equals("GEQ")) {
			retVal.add(SExprTokens.GREATEREQ);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		} else if (rk.getName().toString().equals("EQ")) {
			retVal.add(SExprTokens.EQ);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		}  else if (rk.getName().toString().equals("LESS")) {
			retVal.add(SExprTokens.LESS);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		} else if (rk.getName().toString().equals("GREATER")) {
			retVal.add(SExprTokens.GREATER);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		}
		seq.add(retVal);
	}
*/
/*	
	public void encodeInitWithTemplatePar(AtomicExpression aei, Seq seq, TermExpression rcv, SrlObjectSymbol s,
			String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.add(SExprTokens.SMALLEREQ);
			encodeInitWithTemplatePar(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encodeInitWithTemplatePar(aei.getRight(), retVal, rcv, s, origName, replacement);
		} else if (rk.getName().toString().equals("GEQ")) {
			retVal.add(SExprTokens.GREATEREQ);
			encodeInitWithTemplatePar(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encodeInitWithTemplatePar(aei.getRight(), retVal, rcv, s, origName, replacement);
		} else if (rk.getName().toString().equals("EQ")) {
			retVal.add(SExprTokens.EQ);
			encodeInitWithTemplatePar(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encodeInitWithTemplatePar(aei.getRight(), retVal, rcv, s, origName, replacement);
		}  else if (rk.getName().toString().equals("LESS")) {
			retVal.add(SExprTokens.LESS);
			encodeInitWithTemplatePar(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encodeInitWithTemplatePar(aei.getRight(), retVal, rcv, s, origName, replacement);
		} else if (rk.getName().toString().equals("GREATER")) {
			retVal.add(SExprTokens.GREATER);
			encodeInitWithTemplatePar(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encodeInitWithTemplatePar(aei.getRight(), retVal, rcv, s, origName, replacement);
		} 
		 seq.add(retVal);
	}
*/
///*
	public void encode(AtomicExpression aei, Seq seq, TermExpression rcv, SrlObjectSymbol s,
			String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.add(SExprTokens.SMALLEREQ);
			encode(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encode(aei.getRight(), retVal, rcv, s, origName, replacement);
		} else if (rk.getName().toString().equals("GEQ")) {
			retVal.add(SExprTokens.GREATEREQ);
			encode(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encode(aei.getRight(), retVal, rcv, s, origName, replacement);
		} else if (rk.getName().toString().equals("EQ")) {
			retVal.add(SExprTokens.EQ);
			encode(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encode(aei.getRight(), retVal, rcv, s, origName, replacement);
		}  else if (rk.getName().toString().equals("LESS")) {
			retVal.add(SExprTokens.LESS);
			encode(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encode(aei.getRight(), retVal, rcv, s, origName, replacement);
		} else if (rk.getName().toString().equals("GREATER")) {
			retVal.add(SExprTokens.GREATER);
			encode(aei.getLeft(), retVal, rcv, s, origName, replacement);
			encode(aei.getRight(), retVal, rcv, s, origName, replacement);
		} 
		 seq.add(retVal);
	}
//*/	
//	public void encode(TupleConstructor tci, Seq seq, TermExpression rcv) {
	public void encode(TupleConstructor tci, Seq seq, TermExpression rcv, SrlObjectSymbol s, String origName,
			String replacement) {
		Seq retVal = new SExpr.Seq();
		// list? how many elements???
		FolFormula ffi = (FolFormula) tci.getElements().get(0);
		String op = ffi.getOp();
		if (op != null) {
			if (op.equals("exists")) {
				retVal.add(SExprTokens.EXISTS);
				retVal.add(SExprTokens.OPEN_PARANTHESIS);
				for (SymbolDeclaration ssdi : ffi.getScope()) {
					retVal.add(SExprTokens.OPEN_PARANTHESIS);
					retVal.add(SExprTokens.createToken(ssdi.getName()));
					HigherOrderType ssdit = ssdi.getType();
					SimpleTypeReference stri = (SimpleTypeReference) ssdit;
					retVal.add(SExprTokens.createToken(stri.getType().getName()));
					retVal.add(SExprTokens.CLOSE_PARANTHESIS);
				}
				retVal.add(SExprTokens.CLOSE_PARANTHESIS);
//				encode(ffi.getLeft(), retVal, rcv);				
//				need to consolidate
				encode(ffi.getLeft(), retVal, rcv, s, origName, replacement);				
			} else if (op.equals("&&")) {
				retVal.add(SExprTokens.AND);
//				encode(ffi.getLeft(), retVal, rcv);
//				need to consolidate
				encode(ffi.getLeft(), retVal, rcv, s, origName, replacement);
//				encode(ffi.getRight(), retVal, rcv);
//				need to consolidate
				encode(ffi.getRight(), retVal, rcv, s, origName, replacement);
			} else if (op.equals("||")) {
				retVal.add(SExprTokens.OR);
//				encode(ffi.getLeft(), retVal, rcv);
//				need to consolidate
				encode(ffi.getLeft(), retVal, rcv, s, origName, replacement);
//				encode(ffi.getRight(), retVal, rcv);
//				need to consolidate
				encode(ffi.getRight(), retVal, rcv, s, origName, replacement);
			} else if (op.equals("=>")) {
				retVal.add(SExprTokens.IMPLICATION);
//				encode(ffi.getLeft(), retVal, rcv);
//				need to consolidate
				encode(ffi.getLeft(), retVal, rcv, s, origName, replacement);
//				encode(ffi.getRight(), retVal, rcv);				
//				need to consolidate
				encode(ffi.getRight(), retVal, rcv, s, origName, replacement);				
			}
		} else {
//			encode(ffi.getLeft(), retVal, rcv);
//			need to consolidate
			encode(ffi.getLeft(), retVal, rcv, s, origName, replacement);
		}
		seq.add(retVal);
	}

	private void encodeSort(SrlNamedTypeSymbol t, Seq seq) {
		seq.add(SExprTokens.DECLARE_SORT);
		seq.add(SExprTokens.createToken(t.stringId()));
		seq.add(SExprTokens.createToken(0));
	}

	private Seq encodeExtension(SrlNamedTypeSymbol t, SrlObjectSymbol sos) {
		Seq retVal = new SExpr.Seq();
		retVal.add(SExprTokens.DECLARE_FUN);
		retVal.add(SExprTokens.createToken(t.stringId() + ".base_0"));
		retVal.add(SExprTokens.OPEN_PARANTHESIS);
		retVal.add(SExprTokens.createToken(t.stringId()));
		retVal.add(SExprTokens.CLOSE_PARANTHESIS);
		retVal.add(SExprTokens.createToken(sos.getType().stringId()));
		return retVal;
	}

	@Override
	public List<Seq> encode(SrlNamedTypeSymbol t, String realizedTemplateName) {
		List<Seq> seqList = new ArrayList<>();
		if (!t.isMeta()) {
			if (t.getProperties().isEmpty()) {
				if (!t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							if (!(t.getContainer().toString()).equals("iml.lang")) {
								Seq seq = new SExpr.Seq();
								seq.sexprs().add(SExprTokens.DECLARE_SORT);
								String fqRealizedTemplateName = t.stringId().replaceAll(t.getName(),
										realizedTemplateName);
								seq.sexprs().add(SExprTokens.createToken(fqRealizedTemplateName));
								seq.add(SExprTokens.createToken(0));
								seqList.add(seq);
							}
						} 
					} else {
						if (t.getRelations().isEmpty()) {
							if (!(t.getContainer().toString()).equals("iml.lang")) {
								Seq seq = new SExpr.Seq();
//								retVal.sexprs().add(SExprTokens.DECLARE_SORT);
//								retVal.sexprs().add(SExprTokens.createToken(t.stringId()));
								seq.add(SExprTokens.DECLARE_SORT);
								seq.add(SExprTokens.createToken(t.stringId()));
								seq.add(SExprTokens.createToken(0));
								seqList.add(seq);
							}
						} else {
							// handle sameas
							SrlObjectSymbol os = (t.getRelations()).get(0);
							if (!(os.getType().getContainer().toString()).equals("iml.lang")) {
								Seq seq = new SExpr.Seq();
//								retVal.sexprs().add(SExprTokens.DECLARE_SORT);
//								retVal.sexprs().add(SExprTokens
//										.createToken((os.getType().getContainer() + "." + os.getType().getName())));
								seq.add(SExprTokens.DECLARE_SORT);
								seq.add(SExprTokens
										.createToken((os.getType().getContainer() + "." + os.getType().getName())));
								seq.add(SExprTokens.createToken(0));
								seqList.add(seq);
							}
						}
					}
				}
			} 
		}
		// Process its symbols
		for (SrlObjectSymbol os : t.getSymbols()) {
			seqList.addAll(encode(os));
		}
		return seqList;
	}
	
	/*
	@Override
	public SExpr encode(SrlHigherOrderTypeSymbol hot) {
		 System.out.println(24);
		Seq retVal = new SExpr.Seq();

		if (!hot.isHigherOrder()) {
			if (hot.getDomain() instanceof SrlNamedTypeSymbol) {
				SrlNamedTypeSymbol dmn = (SrlNamedTypeSymbol) hot.getDomain();
				// check modifier, if meta, then pass
				if (!dmn.isMeta()) {
					(retVal.sexprs()).add(SExprTokens.DECLARE_SORT);
					(retVal.sexprs()).add(SExprTokens.createToken(hot.stringId()));
				}
			}
		} else {
			// retVal.sexprs().add(SExprTokens.HOT_ARROW);
			// retVal.sexprs().add(SExprTokens.createToken("("));
			SrlSymbol sDomainS = hot.getDomain();
			if (sDomainS instanceof SrlHigherOrderTypeSymbol) {
				if (((SrlHigherOrderTypeSymbol) sDomainS).isTuple()) {
					for (SrlObjectSymbol first : ((SrlHigherOrderTypeSymbol) sDomainS).getTupleElements()) {
						retVal.sexprs().add(encode(first.getType()));
					}
				} else if (((SrlHigherOrderTypeSymbol) sDomainS).isArray()) {
					System.out.println("TODO: need to implement");
				}
			} else {
				retVal.sexprs().add(SExprTokens.createToken(sDomainS.getName()));
			}
			// retVal.sexprs().add(SExprTokens.createToken(")"));

			SrlSymbol sRangeS = hot.getRange();
			if (sRangeS instanceof SrlHigherOrderTypeSymbol) {
				// retVal.sexprs().add(SExprTokens.createToken("("));
				if (((SrlHigherOrderTypeSymbol) sRangeS).isTuple()) {
					for (SrlObjectSymbol first : ((SrlHigherOrderTypeSymbol) sRangeS).getTupleElements()) {
						retVal.sexprs().add(encode(first.getType()));
					}
				} else if (((SrlHigherOrderTypeSymbol) sRangeS).isArray()) {
					System.out.println("TODO: need to implement");
				}
			} else {
				retVal.sexprs().add(SExprTokens.createToken(sRangeS.getName()));
			}
			// retVal.sexprs().add(SExprTokens.createToken(")"));
		}
		return retVal;
	}
	*/
}
