package com.utc.utrc.hermes.iml.generator.strategies;

import com.utc.utrc.hermes.iml.generator.infra.SExpr;
import com.utc.utrc.hermes.iml.generator.infra.SExpr.Seq;
import com.utc.utrc.hermes.iml.generator.infra.SExprTokens;
import com.utc.utrc.hermes.iml.generator.infra.SrlHigherOrderTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlNamedTypeSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlObjectSymbol;
import com.utc.utrc.hermes.iml.generator.infra.SrlSymbol;

public class FunctionEncodeStrategy implements IStrategy {

	@Override
	public SExpr encode(SrlSymbol s) {
		if (s instanceof SrlObjectSymbol) {
			return encode(s);
		} else if (s instanceof SrlNamedTypeSymbol) {
			return encode (s);
		} else {
			return encode(s);
		}
	}

	@Override
	public SExpr encode(SrlObjectSymbol s) {
		Seq retVal = new SExpr.Seq();
		(retVal.sexprs()).add(SExprTokens.DECLARE_FUN);
		(retVal.sexprs()).add(SExprTokens.createToken(s.stringId()));
		(retVal.sexprs()).add(encode(s.getType()));
		return retVal;		
	}

	@Override
	public SExpr encode(SrlNamedTypeSymbol t) {
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
							
						} else {
							
						}
					} else {
						if (t.getRelations().isEmpty()) {
							retVal.sexprs().add(SExprTokens.DECLARE_SORT);
							retVal.sexprs().add(SExprTokens.createToken(t.stringId()));
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
		}
		
		return retVal;
	}

	@Override
	public SExpr encode(SrlHigherOrderTypeSymbol hot) {
		Seq retVal = new SExpr.Seq();
		
		if (!hot.isHigherOrder()) {
			retVal.sexprs().add(SExprTokens.createToken(hot.stringId()));
		} else {
			retVal.sexprs().add(SExprTokens.HOT_ARROW);
			retVal.sexprs().add(SExprTokens.createToken("("));
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
			retVal.sexprs().add(SExprTokens.createToken(")"));
			
			SrlSymbol sRangeS = hot.getRange();
			if (sRangeS instanceof SrlHigherOrderTypeSymbol) {
				retVal.sexprs().add(SExprTokens.createToken("("));
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
			retVal.sexprs().add(SExprTokens.createToken(")"));

			
			
		}
		
		return retVal;
	}
	
}
