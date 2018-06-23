package com.utc.utrc.hermes.iml.generator.strategies;

import java.util.List;
import java.util.jar.Attributes.Name;

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
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
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

	@Inject SrlFactory factory;
	
	@Override
	public void encode(SymbolTable st) {
		for (SrlSymbolId id : st.getSymbols().keySet()) {
			EncodedSymbol es = (st.getSymbols()).get(id);
			if (es.getEncoding() == null) {
				if (es.getSymbol() instanceof SrlNamedTypeSymbol) {
					SrlNamedTypeSymbol nts = (SrlNamedTypeSymbol)es.getSymbol();
					Seq seq = new SExpr.Seq();
					// declare sort 
					if (!nts.isTemplate()) {
						encodeSort(nts, seq);
						// handle extension
						if (!nts.getRelations().isEmpty()) {
							for (SrlObjectSymbol sos : nts.getRelations()) {
								if (sos.getName().equals("rel_0")) { // extension; single extension assumption???
									encodeExtension(nts, sos, seq);
								}
							}
						}
						for (SrlObjectSymbol os : nts.getSymbols()) {
							seq.sexprs().add(encode(os));
						}
					}
					es.setEncoding(seq);
				} else if(es.getSymbol() instanceof SrlObjectSymbol) {
					es.setEncoding(encode((SrlObjectSymbol)es.getSymbol()));
				} else if(es.getSymbol() instanceof SrlHigherOrderTypeSymbol) {
					SrlHigherOrderTypeSymbol hots = (SrlHigherOrderTypeSymbol)es.getSymbol();
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
							else { //
								//NEED to Throw unimplemented
							}
						} else {
							//NEED to Throw unimplemented
						}
					}
//					es.setEncoding(encode((SrlHigherOrderTypeSymbol)es.getSymbol()));
				}
			}
		}
	}
	
	private SExpr encodeBoundedTemplateType(SrlHigherOrderTypeSymbol hots) {
		Seq retVal = new SExpr.Seq();
		if (!hots.isHigherOrder()) {
			SrlTypeSymbol dmn = (SrlTypeSymbol) hots.getDomain();
			if (dmn instanceof SrlNamedTypeSymbol) {
				SrlNamedTypeSymbol namedDmn = (SrlNamedTypeSymbol) dmn;
				encode(namedDmn, hots.getName().trim(), hots.getBindings(), retVal);
			}
			
			
			
		}
		return retVal;
	}

	
	public SExpr encode(SrlNamedTypeSymbol t, String realizedTemplateName, List<SrlTypeSymbol> bindings, Seq retVal) {
//		Seq retVal = new SExpr.Seq();
		
		if (t.isMeta()) {
			if (t.getProperties().isEmpty()) {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
				}				
			} else {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
				}
			}
		} else {
			if (t.getProperties().isEmpty()) {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							if (!(t.getContainer().toString()).equals("iml.lang")) {
								Seq seq = new SExpr.Seq();
								seq.sexprs().add(SExprTokens.DECLARE_SORT);
								String fqRealizedTemplateName = t.stringId().replaceAll(t.getName(), realizedTemplateName);
								seq.sexprs().add(SExprTokens.createToken(fqRealizedTemplateName));
								retVal.add(seq);
							}
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							if (!(t.getContainer().toString()).equals("iml.lang")) {
								retVal.sexprs().add(SExprTokens.DECLARE_SORT);
								retVal.sexprs().add(SExprTokens.createToken(t.stringId()));
							}
						} else {
							// handle sameas
							SrlObjectSymbol os = (t.getRelations()).get(0);
							if (!(os.getType().getContainer().toString()).equals("iml.lang") ) {
								retVal.sexprs().add(SExprTokens.DECLARE_SORT);
								retVal.sexprs().add(SExprTokens.createToken((os.getType().getContainer() + "." + os.getType().getName())));
							}
						}						
					}
				}				
			} else {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
				}
			}
		}
		
		// Process its symbols		
		for (SrlObjectSymbol os : t.getSymbols()) {
			(retVal.sexprs()).add(encode(os, t, bindings, realizedTemplateName));
		}		
		
		return (retVal.toString().equals("( )") ? null : retVal);
	}

	public SExpr encode(SrlObjectSymbol s, SrlNamedTypeSymbol t, List<SrlTypeSymbol> bindings, String realizedTemplateName) {
		Seq retVal = new SExpr.Seq();
		SrlTerm def = s.getDefinition();
		if (def == null) {
		 (retVal.sexprs()).add(SExprTokens.DECLARE_FUN);
		} else {
			 (retVal.sexprs()).add(SExprTokens.DEFINE_FUN);			
		}
		
		String nm = s.stringId().replaceAll(t.getName(), realizedTemplateName);
		
		(retVal.sexprs()).add(SExprTokens.createToken(nm));

		retVal.sexprs().add(SExprTokens.createToken("("));
		retVal.sexprs().add(SExprTokens.createToken(s.getDefinition() == null ? "" : "("));
		retVal.sexprs().add(SExprTokens.createToken(s.getDefinition() == null ? "" : "x!1"));
		nm = s.getContainer().toString().replaceAll(t.getName(), realizedTemplateName);
		retVal.sexprs().add(SExprTokens.createToken(nm));
		retVal.sexprs().add(SExprTokens.createToken(s.getDefinition() == null ? "" : ")"));
		retVal.sexprs().add(SExprTokens.createToken(")"));
		
		if ((s.getType()) instanceof SrlHigherOrderTypeSymbol) {
			SrlHigherOrderTypeSymbol hots = (SrlHigherOrderTypeSymbol) s.getType();
			if (!hots.isHigherOrder()) {
				if(hots.getDomain() instanceof SrlNamedTypeSymbol) {
					SrlNamedTypeSymbol nts = (SrlNamedTypeSymbol)hots.getDomain();
					// is nts a parameter?
					
					int idx;
					for (idx = 0; idx < t.getParameters().size(); ++idx) {
						if (nts.equals(t.getParameters().get(idx)))
							break;
					}
					
					if (idx == t.getParameters().size()) {
						if (!nts.getContainer().toString().equals("iml.lang")) {
							retVal.sexprs().add(SExprTokens.createToken(nts.stringId()));
						} else {
							retVal.sexprs().add(SExprTokens.createToken(nts.getName()));
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
											retVal.sexprs().add(SExprTokens.createToken(snts.stringId()));
										} else {
											retVal.sexprs().add(SExprTokens.createToken(snts.getName()));
										}
									} else {
										//sameas info
										retVal.sexprs().add(SExprTokens.createToken(snts.getRelations().get(0).getType().getName()));
									}
								}
							}
						}						
					}
				} else {
					// TODO
				}
			} else {
				// TODO
			}			
		} else if ((s.getType()) instanceof SrlNamedTypeSymbol) {
			SrlNamedTypeSymbol snts = (SrlNamedTypeSymbol) s.getType();
			retVal.sexprs().add(SExprTokens.createToken(snts.stringId()));
		}
		
		// process definition
		if (def != null) {  // need to worry about template parameter
			FolFormula f = def.getFormula();
			encodeWithTemplatePar(f, retVal, t.getName().trim(), realizedTemplateName);
		}
		return retVal;		
	}
	
	
	@Override
	public SExpr encode(SrlSymbol s) {
		if (s instanceof SrlObjectSymbol) {
			return encode(s);
		} else if (s instanceof SrlNamedTypeSymbol) {
			return encode (s);
		} else {
			return null; // Need to check, logic not right
		}
	}

	private boolean isTypeConstructor (SrlTerm st) {
		boolean retVal = false;
		FolFormula f = st.getFormula();
		FolFormula fl = f.getLeft();
		if (fl instanceof TermExpression) {
			TermExpression te = (TermExpression) fl;
			if (fl instanceof TypeConstructor) {
				retVal = true;
			}
		}
		return retVal;
	}

	@Override
	public SExpr encode(SrlObjectSymbol s) {
		Seq retVal = new SExpr.Seq();
		SrlTerm def = s.getDefinition();
		if (def == null ) {
		 (retVal.sexprs()).add(SExprTokens.DECLARE_FUN);
		} else {
			if (isTypeConstructor(def)) {
				 (retVal.sexprs()).add(SExprTokens.DECLARE_FUN);
			} else {
				(retVal.sexprs()).add(SExprTokens.DEFINE_FUN);	
			}
		}
		
		(retVal.sexprs()).add(SExprTokens.createToken(s.stringId()));
//		(retVal.sexprs()).add(encode((SrlTypeSymbol) s.getType()));
		// Need to encode type???

		retVal.sexprs().add(SExprTokens.createToken("("));
		retVal.sexprs().add(SExprTokens.createToken(s.getDefinition() == null ? "" : "("));
		retVal.sexprs().add(SExprTokens.createToken(s.getDefinition() == null ? "" : "x!1"));
		retVal.sexprs().add(SExprTokens.createToken(s.getContainer().toString()));
		retVal.sexprs().add(SExprTokens.createToken(s.getDefinition() == null ? "" : ")"));
		retVal.sexprs().add(SExprTokens.createToken(")"));
		
		if ((s.getType()) instanceof SrlHigherOrderTypeSymbol) {
			SrlHigherOrderTypeSymbol hots = (SrlHigherOrderTypeSymbol) s.getType();
			if (!hots.isHigherOrder()) {
				String realizedName = "";
				if (!hots.getBindings().isEmpty()) {
					realizedName = hots.getName();
				}
				
				if(hots.getDomain() instanceof SrlNamedTypeSymbol) {
					SrlNamedTypeSymbol nts = (SrlNamedTypeSymbol)hots.getDomain();
					// get the bound type from relation
					if (nts.getRelations().isEmpty()) {
						if (!nts.getContainer().toString().equals("iml.lang")) {
							if (realizedName.isEmpty()) {
							retVal.sexprs().add(SExprTokens.createToken(nts.stringId()));
							} else {
								retVal.sexprs().add(SExprTokens.createToken(nts.stringId().replaceAll(nts.getName(), realizedName)));
							}
						} else {
							retVal.sexprs().add(SExprTokens.createToken(nts.getName()));
						}
					} else {
						//sameas info
						retVal.sexprs().add(SExprTokens.createToken(nts.getRelations().get(0).getType().getName()));
					}				
				} else {
					// TODO
				}
			} else {
				// TODO
			}			
		} else if ((s.getType()) instanceof SrlNamedTypeSymbol) {
			SrlNamedTypeSymbol snts = (SrlNamedTypeSymbol) s.getType();
			retVal.sexprs().add(SExprTokens.createToken(snts.stringId()));
		}
		
		// process definition
		if (def != null) {
			if (!isTypeConstructor(def)) {
				FolFormula f = def.getFormula();
				encode(f, retVal);
			} else { // generate init function
				retVal.sexprs().add(encodeInit(s));
			}
		}
		return retVal;		
	}

	private SExpr encodeInit(SrlObjectSymbol s) {
		Seq retVal = new SExpr.Seq();
		SrlTerm def = s.getDefinition();
		(retVal.sexprs()).add(SExprTokens.DEFINE_FUN);	
	
		(retVal.sexprs()).add(SExprTokens.createToken(s.stringId() + ".init"));

		retVal.sexprs().add(SExprTokens.createToken("("));
		retVal.sexprs().add(SExprTokens.createToken("("));
		retVal.sexprs().add(SExprTokens.createToken("x!1"));
		retVal.sexprs().add(SExprTokens.createToken(s.getContainer().toString()));
		retVal.sexprs().add(SExprTokens.createToken(")"));
		retVal.sexprs().add(SExprTokens.createToken(")"));
		retVal.sexprs().add(SExprTokens.createToken("Bool"));		
		FolFormula f = def.getFormula();
//		encode(f, retVal);
		encodeInitBody(f, s, retVal);
		return retVal;				
	}

	private void encodeInitBody(FolFormula f, SrlObjectSymbol s, Seq retVal) {
		SignedAtomicFormula saf = (SignedAtomicFormula) f;
		FolFormula lFol = saf.getLeft();
		TypeConstructor tc = (TypeConstructor) lFol;
		Program init = (Program) tc.getInit();
		SimpleTypeReference str = (SimpleTypeReference) tc.getRef();
		SExpr fst = encodeInitWithTemplatePar(init.getRelations().get(0), null, s, "", "");
		for (int i = 1; i < init.getRelations().size(); i++) {
			FolFormula ff = init.getRelations().get(i);					
			SExpr snd = encodeInitWithTemplatePar(ff, null, s, "", "");
			Seq seq = new SExpr.Seq();
			seq.sexprs().add(SExprTokens.AND);
			seq.sexprs().add(fst);
			seq.sexprs().add(snd);
			fst = seq;
		}
		retVal.add(fst);
		System.out.println("test");
	}

	public void encode (FolFormula f, Seq seq) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();				
				retVal.sexprs().add(SExprTokens.AND);
				encode(f.getLeft(), retVal);
				encode(f.getRight(), retVal);
				seq.add(retVal);
			}
			else if (op.equals("||")) {
				Seq retVal = new SExpr.Seq();				
				retVal.sexprs().add(SExprTokens.OR);
				encode(f.getLeft(), retVal);
				encode(f.getRight(), retVal);
				seq.add(retVal);
			}

		} else {
			if (f instanceof SignedAtomicFormula) {
				SignedAtomicFormula safi = (SignedAtomicFormula) f;
				FolFormula leftFol = safi.getLeft();
				if (leftFol instanceof AtomicExpression) {
					AtomicExpression aei = (AtomicExpression) leftFol;
					encode(aei, seq);
				}
				
				if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					encode(tci, seq);
				}
				
				if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
						seq.sexprs().add(SExprTokens.createToken("-"));
					}
					seq.sexprs().add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
				if (leftFol instanceof SymbolReferenceTerm) {
					SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol;
					encode(leftFol, seq);
				}
			}
			else if (f instanceof SymbolReferenceTerm) {

				SymbolReferenceTerm srti = (SymbolReferenceTerm) f;
				SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
				String sfqn = sdi.getName();
				String n = sdi.getName();
				if (!(sdi.eContainer() instanceof FolFormula)) {
					SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
					sfqn = srlObject.stringId();
				}
				if (srti.getTails() != null && !srti.getTails().isEmpty()) {					
					seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					if (n.equals("sqrt")) {
						seq.sexprs().add(SExprTokens.createToken("^"));
					} else {
						seq.sexprs().add(SExprTokens.createToken(n));
					}
					SymbolReferenceTail srtailI = srti.getTails().get(0);
					if (srtailI instanceof TupleConstructor) {
						encode(((TupleConstructor) srtailI).getElements().get(0), seq);
					}
					if (n.equals("sqrt")) {
						seq.sexprs().add(SExprTokens.createToken(0.5f));
					}
					seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				} else {
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					}
					seq.sexprs().add(SExprTokens.createToken(sfqn));
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.sexprs().add(SExprTokens.createToken(" x!1"));				
						seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
			}
			else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				if (nli.isNeg()) {
					seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					seq.sexprs().add(SExprTokens.createToken("-"));
				}
				seq.sexprs().add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				}
			}
			else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();				
				retVal.add(SExprTokens.createToken(mi.getSign())); // Why this is sign?? not operator??
				encode(mi.getLeft(), retVal);
				encode(mi.getRight(), retVal);
				seq.add(retVal);
			}
			else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();				
				retVal.add(SExprTokens.createToken(ai.getSign())); // Why this is sign?? not operator??
				encode(ai.getLeft(), retVal);
				encode(ai.getRight(), retVal);
				seq.add(retVal);
				
			} else if (f instanceof AtomicExpression) {
				Seq retVal = new SExpr.Seq();
				AtomicExpression ae = (AtomicExpression) f;
				encode(ae, retVal);
				seq.add(retVal);
			}
		}
	}

	public void encodeWithTemplatePar (FolFormula f, Seq seq, String origName, String replacement) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();				
				retVal.sexprs().add(SExprTokens.AND);
				encodeWithTemplatePar(f.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(f.getRight(), retVal, origName, replacement);
				seq.add(retVal);
			}
			else if (op.equals("||")) {
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
				}
				
				if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					encodeWithTemplatePar(tci, seq, origName, replacement);
				}
				
				if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					if (nli.isNeg()) {
						seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
						seq.sexprs().add(SExprTokens.createToken("-"));
					}
					seq.sexprs().add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
				if (leftFol instanceof SymbolReferenceTerm) {
					SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol; //?????? bugggggggg
					encode(leftFol, seq);
				}
			}
			else if (f instanceof SymbolReferenceTerm) {

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
					seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					if (n.equals("sqrt")) {
						seq.sexprs().add(SExprTokens.createToken("^"));
					} else {
						seq.sexprs().add(SExprTokens.createToken(n));
					}
					SymbolReferenceTail srtailI = srti.getTails().get(0);
					if (srtailI instanceof TupleConstructor) {
						encodeWithTemplatePar(((TupleConstructor) srtailI).getElements().get(0), seq, origName, replacement);
					}
					if (n.equals("sqrt")) {
						seq.sexprs().add(SExprTokens.createToken(0.5f));
					}
					seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				} else {
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					}
					seq.sexprs().add(SExprTokens.createToken(sfqn));
					if (!(sdi.eContainer() instanceof FolFormula)) {
						seq.sexprs().add(SExprTokens.createToken(" x!1"));				
						seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
				}
			}
			else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				if (nli.isNeg()) {
					seq.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					seq.sexprs().add(SExprTokens.createToken("-"));
				}
				seq.sexprs().add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					seq.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				}
			}
			else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();				
				retVal.add(SExprTokens.createToken(mi.getSign())); // Why this is sign?? not operator??
				encodeWithTemplatePar(mi.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(mi.getRight(), retVal, origName, replacement);
				seq.add(retVal);
			}
			else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();				
				retVal.add(SExprTokens.createToken(ai.getSign())); // Why this is sign?? not operator??
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

	public SExpr encodeInitWithTemplatePar (FolFormula f, TermExpression rcv, SrlObjectSymbol s, String origName, String replacement) {
		String op = f.getOp();
		if (op != null) {
			if (op.equals("&&")) {
				Seq retVal = new SExpr.Seq();				
				retVal.sexprs().add(SExprTokens.AND);
				retVal.sexprs().add(encodeInitWithTemplatePar(f.getLeft(), rcv, s, origName, replacement));
				retVal.sexprs().add(encodeInitWithTemplatePar(f.getRight(), rcv, s, origName, replacement));
				return retVal;
			}
			else if (op.equals("||")) {
				Seq retVal = new SExpr.Seq();				
				retVal.sexprs().add(SExprTokens.OR);
				retVal.sexprs().add(encodeInitWithTemplatePar(f.getLeft(), rcv, s, origName, replacement));
				retVal.sexprs().add(encodeInitWithTemplatePar(f.getRight(), rcv, s, origName, replacement));
				return retVal;
			}

		} else {
			if (f instanceof SignedAtomicFormula) {
				SignedAtomicFormula safi = (SignedAtomicFormula) f;
				FolFormula leftFol = safi.getLeft();
				if (leftFol instanceof AtomicExpression) {
					AtomicExpression aei = (AtomicExpression) leftFol;
					return encodeInitWithTemplatePar(aei, rcv, s, origName, replacement);
				}
				
				if (leftFol instanceof TupleConstructor) {
					TupleConstructor tci = (TupleConstructor) leftFol;
					return encodeInitWithTemplatePar(tci, rcv, s, origName, replacement);
				}
				
				if (leftFol instanceof NumberLiteral) {
					NumberLiteral nli = (NumberLiteral) leftFol;
					Seq retVal = new SExpr.Seq(); 
					if (nli.isNeg()) {
						retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
						retVal.sexprs().add(SExprTokens.createToken("-"));
					}
					retVal.sexprs().add(SExprTokens.createToken(nli.getValue()));
					if (nli.isNeg()) {
						retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
					return retVal;
				}
				if (leftFol instanceof SymbolReferenceTerm) {
//					SymbolReferenceTerm tmpSRTI = (SymbolReferenceTerm) leftFol; //?????? bugggggggg
//					encode(leftFol, seq);
				}
			}
			else if (f instanceof SymbolReferenceTerm) {

				SymbolReferenceTerm srti = (SymbolReferenceTerm) f;
				SymbolDeclaration sdi = (SymbolDeclaration) srti.getSymbol();
				String sfqn = sdi.getName();
				String n = sdi.getName();
				if (!(sdi.eContainer() instanceof FolFormula)) {
					SrlObjectSymbol srlObject = factory.createObjectSymbol(sdi);
					sfqn = srlObject.stringId();
					sfqn = sfqn.replaceAll(origName, replacement);
				}
				Seq retVal = new SExpr.Seq();
				if (srti.getTails() != null && !srti.getTails().isEmpty()) {
					retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					if (n.equals("sqrt")) {
						retVal.sexprs().add(SExprTokens.createToken("^"));
					} else {
						retVal.sexprs().add(SExprTokens.createToken(n));
					}
					SymbolReferenceTail srtailI = srti.getTails().get(0);
					if (srtailI instanceof TupleConstructor) {
						retVal.sexprs().add(encodeInitWithTemplatePar(((TupleConstructor) srtailI).getElements().get(0), rcv, s, origName, replacement));
					}
					if (n.equals("sqrt")) {
						retVal.sexprs().add(SExprTokens.createToken(0.5f));
					}
					retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				} else {
					if (!(sdi.eContainer() instanceof FolFormula)) {
						retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					}
					retVal.sexprs().add(SExprTokens.createToken(sfqn));
					if (!(sdi.eContainer() instanceof FolFormula)) {
						retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
						SrlHigherOrderTypeSymbol symCT = (SrlHigherOrderTypeSymbol) s.getType();
						// NOT CONSIDERING HOT
						SrlNamedTypeSymbol ct = (SrlNamedTypeSymbol) symCT.getDomain();
						String symbolFqn = ct.getContainer() + "." + ct.getName();
						if (sfqn.contains(symbolFqn)) {
							retVal.sexprs().add(SExprTokens.createToken(s.stringId()));
						} else {
							if (rcv != null) {
								String rcvStr = generateReveiverString(rcv);
								retVal.sexprs().add(SExprTokens.createToken(rcvStr));
							} else {
								String ctnr1 = s.getContainer().toString();
								String ctnr2 = sfqn.substring(0, sfqn.lastIndexOf('.'));
								if (ctnr1 .equals(ctnr2)) {
									retVal.sexprs().add(SExprTokens.createToken(sfqn));
								} else { // inherited
									retVal.sexprs().add(SExprTokens.createToken(ctnr1 + ".base_0"));
								}
							}							
						}
						retVal.sexprs().add(SExprTokens.createToken(" x!1"));				
						if (sfqn.contains(symbolFqn)) {
							retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
						}
						retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
					}
					return retVal;
				}
			}
			else if (f instanceof NumberLiteral) {
				NumberLiteral nli = (NumberLiteral) f;
				Seq retVal = new SExpr.Seq();
				if (nli.isNeg()) {
					retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					retVal.sexprs().add(SExprTokens.createToken("-"));
				}
				retVal.sexprs().add(SExprTokens.createToken(nli.getValue()));
				if (nli.isNeg()) {
					retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				}
				return retVal;
			}
			else if (f instanceof Multiplication) {
				Multiplication mi = (Multiplication) f;
				Seq retVal = new SExpr.Seq();				
				retVal.add(SExprTokens.createToken(mi.getSign())); // Why this is sign?? not operator??
				retVal.sexprs().add(encodeInitWithTemplatePar(mi.getLeft(), rcv, s, origName, replacement));
				retVal.sexprs().add(encodeInitWithTemplatePar(mi.getRight(), rcv, s, origName, replacement));
				return retVal;
			}
			else if (f instanceof Addition) {
				Addition ai = (Addition) f;
				Seq retVal = new SExpr.Seq();				
				retVal.add(SExprTokens.createToken(ai.getSign())); // Why this is sign?? not operator??
				retVal.sexprs().add(encodeInitWithTemplatePar(ai.getLeft(), rcv, s, origName, replacement));
				retVal.sexprs().add(encodeInitWithTemplatePar(ai.getRight(), rcv, s, origName, replacement));
				return retVal;
				
			} else if (f instanceof AtomicExpression) {
				Seq retVal = new SExpr.Seq();
				AtomicExpression ae = (AtomicExpression) f;
				retVal.sexprs().add(encodeInitWithTemplatePar(ae, rcv, s, origName, replacement));
				return retVal;
			}
			else if (f instanceof TermMemberSelection) {
				Seq retVal = new SExpr.Seq();
				TermMemberSelection tms = (TermMemberSelection) f;
				TermExpression rcv_ = tms.getReceiver();
				TermExpression mbr = tms.getMember();
				if (mbr instanceof SymbolReferenceTerm) {
					SymbolReferenceTerm srt = (SymbolReferenceTerm) mbr;
					retVal.sexprs().add(encodeInitWithTemplatePar(srt, rcv_, s, origName, replacement));
					return retVal;
				}
			}
		}
		return null;
	}
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
		} else {
			FolFormula l = rcv.getLeft();
			FolFormula r = rcv.getRight();			
		}
		return retVal;
	}

	public void encode (AtomicExpression aei, Seq seq) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.sexprs().add(SExprTokens.SMALLEREQ);
			encode(aei.getLeft(), retVal);
			encode(aei.getRight(), retVal);
		}
		else if (rk.getName().toString().equals("GEQ")) {
			retVal.sexprs().add(SExprTokens.GREATEREQ);
			encode(aei.getLeft(), retVal);
			encode(aei.getRight(), retVal);
		}
		else if (rk.getName().toString().equals("EQ")) {
			retVal.sexprs().add(SExprTokens.EQ);
			encode(aei.getLeft(), retVal);
			encode(aei.getRight(), retVal);
		}
		seq.add(retVal);
	}
	
	public void encodeWithTemplatePar (AtomicExpression aei, Seq seq, String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.sexprs().add(SExprTokens.SMALLEREQ);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		}
		else if (rk.getName().toString().equals("GEQ")) {
			retVal.sexprs().add(SExprTokens.GREATEREQ);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		}
		else if (rk.getName().toString().equals("EQ")) {
			retVal.sexprs().add(SExprTokens.EQ);
			encodeWithTemplatePar(aei.getLeft(), retVal, origName, replacement);
			encodeWithTemplatePar(aei.getRight(), retVal, origName, replacement);
		}
		seq.add(retVal);
	}

	public SExpr encodeInitWithTemplatePar (AtomicExpression aei, TermExpression rcv, SrlObjectSymbol s, String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		RelationKind rk = aei.getRel();
		if (rk.getName().toString().equals("LEQ")) {
			retVal.sexprs().add(SExprTokens.SMALLEREQ);
			retVal.sexprs().add(encodeInitWithTemplatePar(aei.getLeft(), rcv, s, origName, replacement));
			retVal.sexprs().add(encodeInitWithTemplatePar(aei.getRight(), rcv, s, origName, replacement));
		}
		else if (rk.getName().toString().equals("GEQ")) {
			retVal.sexprs().add(SExprTokens.GREATEREQ);
			retVal.sexprs().add(encodeInitWithTemplatePar(aei.getLeft(), rcv, s, origName, replacement));
			retVal.sexprs().add(encodeInitWithTemplatePar(aei.getRight(), rcv, s, origName, replacement));
		}
		else if (rk.getName().toString().equals("EQ")) {
			retVal.sexprs().add(SExprTokens.EQ);
			retVal.sexprs().add(encodeInitWithTemplatePar(aei.getLeft(), rcv, s, origName, replacement));
			retVal.sexprs().add(encodeInitWithTemplatePar(aei.getRight(), rcv, s, origName, replacement));
		}
		return retVal;
	}

	
	public void encode (TupleConstructor tci, Seq seq) {
		Seq retVal = new SExpr.Seq();
		// list? how many elements???
		FolFormula ffi = (FolFormula) tci.getElements().get(0);
		String op = ffi.getOp();
		if (op != null) {
			if (op.equals("exists")) {
				retVal.sexprs().add(SExprTokens.EXISTS);
				retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
				for (SymbolDeclaration ssdi : ffi.getScope()) {
					retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					retVal.sexprs().add(SExprTokens.createToken(ssdi.getName()));
					HigherOrderType ssdit = ssdi.getType();
					SimpleTypeReference stri = (SimpleTypeReference) ssdit;
					retVal.sexprs().add(SExprTokens.createToken(stri.getType().getName()));
					retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				}
				retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				encode(ffi.getLeft(), retVal);
			} else if (op.equals("&&")) {
				retVal.sexprs().add(SExprTokens.AND);
				encode(ffi.getLeft(), retVal);
				encode(ffi.getRight(), retVal);
			} else if (op.equals("||")) {
				retVal.sexprs().add(SExprTokens.OR);
				encode(ffi.getLeft(), retVal);
				encode(ffi.getRight(), retVal);
			}
		} else {
			encode(ffi.getLeft(), retVal);
		}
		seq.add(retVal);
	}
	
	public void encodeWithTemplatePar (TupleConstructor tci, Seq seq, String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		// list? how many elements???
		FolFormula ffi = (FolFormula) tci.getElements().get(0);
		String op = ffi.getOp();
		if (op != null) {
			if (op.equals("exists")) {
				retVal.sexprs().add(SExprTokens.EXISTS);
				retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
				for (SymbolDeclaration ssdi : ffi.getScope()) {
					retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					retVal.sexprs().add(SExprTokens.createToken(ssdi.getName()));
					HigherOrderType ssdit = ssdi.getType();
					SimpleTypeReference stri = (SimpleTypeReference) ssdit;
					retVal.sexprs().add(SExprTokens.createToken(stri.getType().getName()));
					retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				}
				retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				encodeWithTemplatePar(ffi.getLeft(), retVal, origName, replacement);
			} else if (op.equals("&&")) {
				retVal.sexprs().add(SExprTokens.AND);
				encodeWithTemplatePar(ffi.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(ffi.getRight(), retVal, origName, replacement);
			} else if (op.equals("||")) {
				retVal.sexprs().add(SExprTokens.OR);
				encodeWithTemplatePar(ffi.getLeft(), retVal, origName, replacement);
				encodeWithTemplatePar(ffi.getRight(), retVal, origName, replacement);
			}
		} else {
			encodeWithTemplatePar(ffi.getLeft(), retVal, origName, replacement);
		}
		seq.add(retVal);
	}
		
	public SExpr encodeInitWithTemplatePar (TupleConstructor tci, TermExpression rcv, SrlObjectSymbol s, String origName, String replacement) {
		Seq retVal = new SExpr.Seq();
		// list? how many elements???
		FolFormula ffi = (FolFormula) tci.getElements().get(0);
		String op = ffi.getOp();
		if (op != null) {
			if (op.equals("exists")) {
				retVal.sexprs().add(SExprTokens.EXISTS);
				retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
				for (SymbolDeclaration ssdi : ffi.getScope()) {
					retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
					retVal.sexprs().add(SExprTokens.createToken(ssdi.getName()));
					HigherOrderType ssdit = ssdi.getType();
					SimpleTypeReference stri = (SimpleTypeReference) ssdit;
					retVal.sexprs().add(SExprTokens.createToken(stri.getType().getName()));
					retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				}
				retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
				retVal.sexprs().add(encodeInitWithTemplatePar(ffi.getLeft(), rcv, s, origName, replacement));
			} else if (op.equals("&&")) {
				retVal.sexprs().add(SExprTokens.AND);
				retVal.sexprs().add(encodeInitWithTemplatePar(ffi.getLeft(), rcv, s, origName, replacement));
				retVal.sexprs().add(encodeInitWithTemplatePar(ffi.getRight(), rcv, s, origName, replacement));
			} else if (op.equals("||")) {
				retVal.sexprs().add(SExprTokens.OR);
				retVal.sexprs().add(encodeInitWithTemplatePar(ffi.getLeft(), rcv, s, origName, replacement));
				retVal.sexprs().add(encodeInitWithTemplatePar(ffi.getRight(), rcv, s, origName, replacement));
			}
		} else {
			retVal.sexprs().add(encodeInitWithTemplatePar(ffi.getLeft(), rcv, s, origName, replacement));
		}
		return retVal;
	}

	@Override
	public SExpr encode(SrlTypeSymbol t) {
		if (t instanceof SrlNamedTypeSymbol) {
			return encode((SrlNamedTypeSymbol) t);
		} else {
			return encode((SrlHigherOrderTypeSymbol) t);
		}
	}
	
	private void encodeSort(SrlNamedTypeSymbol t, Seq seq) {
		Seq retVal = new SExpr.Seq();
		(retVal.sexprs()).add(SExprTokens.DECLARE_SORT);
		(retVal.sexprs()).add(SExprTokens.createToken(t.stringId()));
		seq.add(retVal);
	}
	
	private void encodeExtension(SrlNamedTypeSymbol t, SrlObjectSymbol sos, Seq seq) {
		Seq retVal = new SExpr.Seq();

		retVal.sexprs().add(SExprTokens.DECLARE_FUN);
		retVal.sexprs().add(SExprTokens.createToken(t.stringId() + "_base_0"));
		retVal.sexprs().add(SExprTokens.OPEN_PARANTHESIS);
		retVal.sexprs().add(SExprTokens.createToken(t.stringId()));
		retVal.sexprs().add(SExprTokens.CLOSE_PARANTHESIS);
		retVal.sexprs().add(SExprTokens.createToken(sos.getType().stringId()));
		seq.add(retVal);
	}
	
	@Override
	public SExpr encode(SrlNamedTypeSymbol t, String realizedTemplateName) {
		Seq retVal = new SExpr.Seq();
		
		if (t.isMeta()) {
			if (t.getProperties().isEmpty()) {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
				}				
			} else {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
				}
			}
		} else {
			if (t.getProperties().isEmpty()) {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							if (!(t.getContainer().toString()).equals("iml.lang")) {
								Seq seq = new SExpr.Seq();
								seq.sexprs().add(SExprTokens.DECLARE_SORT);
								String fqRealizedTemplateName = t.stringId().replaceAll(t.getName(), realizedTemplateName);
								seq.sexprs().add(SExprTokens.createToken(fqRealizedTemplateName));
								retVal.add(seq);
							}
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							if (!(t.getContainer().toString()).equals("iml.lang")) {
								retVal.sexprs().add(SExprTokens.DECLARE_SORT);
								retVal.sexprs().add(SExprTokens.createToken(t.stringId()));
							}
						} else {
							// handle sameas
							SrlObjectSymbol os = (t.getRelations()).get(0);
							if (!(os.getType().getContainer().toString()).equals("iml.lang") ) {
								retVal.sexprs().add(SExprTokens.DECLARE_SORT);
								retVal.sexprs().add(SExprTokens.createToken((os.getType().getContainer() + "." + os.getType().getName())));
							}
						}						
					}
				}				
			} else {
				if (t.isFinite()) {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
					
				} else {
					if (t.isTemplate()) {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							
						} else {
							
						}						
					}
				}
			}
		}
		
		// Process its symbols		
		for (SrlObjectSymbol os : t.getSymbols()) {
			(retVal.sexprs()).add(encode(os));
		}		
		
		return (retVal.toString().equals("( )") ? null : retVal);
	}

	@Override
	public SExpr encode(SrlHigherOrderTypeSymbol hot) {
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
//			retVal.sexprs().add(SExprTokens.HOT_ARROW);
//			retVal.sexprs().add(SExprTokens.createToken("("));
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
//			retVal.sexprs().add(SExprTokens.createToken(")"));
			
			SrlSymbol sRangeS = hot.getRange();
			if (sRangeS instanceof SrlHigherOrderTypeSymbol) {
//				retVal.sexprs().add(SExprTokens.createToken("("));
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
//			retVal.sexprs().add(SExprTokens.createToken(")"));
		}
		return retVal;
	}
}
