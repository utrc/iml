/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.Annotation;
import com.utc.utrc.hermes.iml.iml.ArrayAccess;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.CardinalityRestriction;
import com.utc.utrc.hermes.iml.iml.CaseTermExpression;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.OptionalTermExpr;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.FunctionType;
import com.utc.utrc.hermes.iml.iml.ImlType;
import com.utc.utrc.hermes.iml.iml.Import;
import com.utc.utrc.hermes.iml.iml.Inclusion;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.PropertyList;
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula;
import com.utc.utrc.hermes.iml.iml.RecordType;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SelfType;
import com.utc.utrc.hermes.iml.iml.SequenceTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TailedExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.Trait;
import com.utc.utrc.hermes.iml.iml.TraitExhibition;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public class AbstractModelAcceptor implements IModelAcceptor {

	@Override
	public void accept(Model m, IModelVisitor visitor) {
		for(Import i : m.getImports()) {
			accept(i,visitor);
		}
		for(Symbol s : m.getSymbols()) {
			if (s instanceof Assertion) {
				accept((Assertion)s,visitor) ;
			} else if (s  instanceof NamedType) {
				if (s instanceof Annotation) {
					accept((Annotation)s,visitor);
				} else if (s instanceof Trait) {
					accept((Trait)s,visitor);
				} else {
					accept((NamedType)s,visitor);
				}
			} else {
				accept((SymbolDeclaration)s,visitor);
			}
		}
		visitor.visit(m);
	}

	@Override
	public  void accept(Assertion s, IModelVisitor visitor) {
		if (s.getPropertylist() != null) {
			accept(s.getPropertylist(),visitor);
		}
		accept((SequenceTerm) s.getDefinition(),visitor);
		visitor.visit(s);
	}

	@Override
	public  void accept(NamedType s, IModelVisitor visitor) {
		if (s.getPropertylist() != null) {
			accept(s.getPropertylist(),visitor);
		}
		if (s.isTemplate()) {
			for(NamedType tp : s.getTypeParameter()) {
				accept(tp, visitor);
			}
		}
		if (s.getRelations() != null) {
			for(Relation r : s.getRelations()) {
				if (r instanceof Inclusion) {
					for(TypeWithProperties p : ((Inclusion) r).getInclusions()) {
						accept(p,visitor);
					}
				}
				if (r instanceof Alias) {
					accept(((Alias) r).getType(),visitor);
				}
				if (r instanceof TraitExhibition) {
					for(TypeWithProperties p : ((TraitExhibition) r).getExhibitions()) {
						accept(p,visitor);
					}
				}
			}
		}
		if (s.getRestriction() != null) {
			TypeRestriction r = s.getRestriction();
			if (r instanceof CardinalityRestriction) {
				accept((CardinalityRestriction)r, visitor);
			}
			if (r instanceof EnumRestriction) {
				accept((EnumRestriction)r,visitor);
			}
		}
		for(Symbol symb: s.getSymbols()) {
			if (symb instanceof Assertion) {
				accept((Assertion)s,visitor) ;
			} else {
				accept((SymbolDeclaration)s,visitor);
			}
		}
		visitor.visit(s);
	}

	@Override
	public  void accept(SymbolDeclaration s, IModelVisitor visitor) {
		if (s.getPropertylist() != null) {
			accept(s.getPropertylist(),visitor);
		}
		if (s.isTemplate()) {
			for(NamedType tp : s.getTypeParameter()) {
				accept(tp,visitor);
			}
		}
		if (s.getType() != null) {
			accept(s.getType(),visitor);
		}
		if (s.getDefinition() != null) {
			accept(s.getDefinition(),visitor);
		}
		visitor.visit(s);
	}

	@Override
	public void accept(Import m, IModelVisitor visitor) {
		visitor.visit(m);
	}

	@Override
	public void accept(PropertyList l,  IModelVisitor visitor) {
		for(Property p : l.getProperties()) {
			accept((Property)p,visitor);
		}
		visitor.visit(l);
	}

	@Override
	public void accept(Property p, IModelVisitor visitor) {
		accept((SimpleTypeReference) p.getRef(),visitor);
		if(p.getDefinition() != null) {
			accept((SequenceTerm)p.getDefinition(),visitor);
		}
		visitor.visit(p);
	}

	@Override
	public void accept(SimpleTypeReference s, IModelVisitor visitor) {
		if (s.getTypeBinding() != null) {
			for(ImlType t : s.getTypeBinding()) {
				accept(t,visitor);
			}
		}
		visitor.visit(s);
	}

	

	@Override
	public void accept(Annotation s, IModelVisitor visitor) {
		if (s.getRelations() != null) {
			for(Relation r : s.getRelations()) {
				if (r instanceof Inclusion) {
					for(TypeWithProperties p : ((Inclusion) r).getInclusions()) {
						accept(p,visitor);
					}
				}
			}
		}
		if (s.getRestriction() != null) {
			TypeRestriction r = s.getRestriction();
			if (r instanceof CardinalityRestriction) {
				accept((CardinalityRestriction)r, visitor);
			}
			if (r instanceof EnumRestriction) {
				accept((EnumRestriction)r,visitor);
			}
		}
		for(Symbol symb: s.getSymbols()) {
			if (symb instanceof Assertion) {
				accept((Assertion)s,visitor) ;
			} else {
				accept((SymbolDeclaration)s,visitor);
			}
		}
		visitor.visit(s);
	}

	@Override
	public void accept(Trait s, IModelVisitor visitor) {
		if (s.getPropertylist() != null) {
			accept(s.getPropertylist(),visitor);
		}
		if (s.isTemplate()) {
			for(NamedType tp : s.getTypeParameter()) {
				accept(tp, visitor);
			}
		}
		if (s.getRelations() != null) {
			for(Relation r : s.getRelations()) {
				if (r instanceof Inclusion) {
					for(TypeWithProperties p : ((Inclusion) r).getInclusions()) {
						accept(p,visitor);
					}
				}
				if (r instanceof Alias) {
					accept(((Alias) r).getType(),visitor);
				}
				if (r instanceof TraitExhibition) {
					for(TypeWithProperties p : ((TraitExhibition) r).getExhibitions()) {
						accept(p,visitor);
					}
				}
			}
		}
		if (s.getRestriction() != null) {
			TypeRestriction r = s.getRestriction();
			if (r instanceof CardinalityRestriction) {
				accept((CardinalityRestriction)r, visitor);
			}
			if (r instanceof EnumRestriction) {
				accept((EnumRestriction)r,visitor);
			}
		}
		for(Symbol symb: s.getSymbols()) {
			if (symb instanceof Assertion) {
				accept((Assertion)s,visitor) ;
			} else {
				accept((SymbolDeclaration)s,visitor);
			}
		}
		visitor.visit(s);
	}

	@Override
	public void accept(TypeWithProperties p, IModelVisitor visitor) {
		if(p.getProperties() != null) {
			accept(p.getProperties(),visitor);
		}
		accept(p.getType(),visitor);
		visitor.visit(p);
	}

	@Override
	public void accept(CardinalityRestriction e, IModelVisitor visitor) {
		visitor.visit(e);
	}

	@Override
	public void accept(EnumRestriction e, IModelVisitor visitor) {
		visitor.visit(e);
	}

	@Override
	public void accept(ImlType e, IModelVisitor visitor) {
		if (e instanceof SimpleTypeReference) {
			accept((SimpleTypeReference) e, visitor);
		} else if (e instanceof ArrayType) {
			accept((ArrayType) e, visitor);
		} else if (e instanceof TupleType) {
			accept((TupleType) e, visitor);
		} else if (e instanceof FunctionType) {
			accept((FunctionType) e, visitor);
		} else if (e instanceof RecordType) {
			accept((RecordType) e, visitor);
		} else if (e instanceof SelfType) {
			accept((SelfType) e, visitor);
		}
//		visitor.visit(e); // Visit one of the concrete class instead
	}
	
	@Override
	public void accept(ArrayType e, IModelVisitor visitor) {
		accept(e.getType(), visitor);
		for (OptionalTermExpr term : e.getDimensions()) {
			accept(term, visitor);
		}
		visitor.visit(e);
	}
	
	@Override
	public void accept(FunctionType e, IModelVisitor visitor) {
		accept(e.getDomain(), visitor);
		accept(e.getRange(), visitor);
		visitor.visit(e);
	}
	
	@Override
	public void accept(SelfType e, IModelVisitor visitor) {
		visitor.visit(e);
	}
	
	@Override
	public void accept(TupleType e, IModelVisitor visitor) {
		for (ImlType s : e.getTypes()) {
			accept(s, visitor);
		}
		visitor.visit(e);
	}
	
	@Override
	public void accept(RecordType e, IModelVisitor visitor) {
		for (SymbolDeclaration s : e.getSymbols()) {
			accept(s, visitor);
		}
		visitor.visit(e);
	}
	
	@Override
	public void accept(OptionalTermExpr t, IModelVisitor visitor) {
		if (t.getTerm() != null) {
			accept(t.getTerm(), visitor);
		}
		visitor.visit(t);
	}

	@Override
	public void accept(FolFormula e, IModelVisitor visitor) {
		if (e.getOp() != null && 
				(e.getOp().equals("=>") || 
				 e.getOp().equals("<=>") ||
				 e.getOp().equals("&&") ||
				 e.getOp().equals("||"))) {
			accept(e.getLeft(),visitor);
			accept(e.getRight(),visitor);
			visitor.visit(e);
		}  else if (e instanceof AtomicExpression) {
			accept(e.getLeft(),visitor);
			accept(e.getRight(),visitor);
			visitor.visit((AtomicExpression) e);
		}else if (e instanceof Addition) {
			accept(e.getLeft(),visitor);
			accept(e.getRight(),visitor);
			visitor.visit((Addition) e);
		}else if (e instanceof Multiplication) {
			accept(e.getLeft(),visitor);
			accept(e.getRight(),visitor);
			visitor.visit((Multiplication) e);
		}else if (e instanceof TermMemberSelection) {
			accept(((TermMemberSelection) e).getReceiver(),visitor);
			accept(((TermMemberSelection) e).getMember(),visitor);
			visitor.visit((TermMemberSelection)e);
		}else if (e instanceof SymbolReferenceTerm) {
			visitor.visit((SymbolReferenceTerm)e);
		} else if (e instanceof TailedExpression) {
			if (((TailedExpression)e).getTail() instanceof TupleConstructor) {
				accept((TupleConstructor) ((TailedExpression)e).getTail(), visitor);
			} else {
				accept(((ArrayAccess)((TailedExpression)e).getTail()).getIndex(),visitor );
			}
			visitor.visit((TailedExpression) e);
		} else if (e instanceof TupleConstructor) {
			for(FolFormula el : ((TupleConstructor) e).getElements()) {
				accept(el,visitor);
			}
			visitor.visit((TupleConstructor)e);
		}else if (e instanceof ParenthesizedTerm) {
			accept(((ParenthesizedTerm) e).getSub(),visitor);
		}else if (e instanceof IteTermExpression) {
			accept(((IteTermExpression) e).getCondition(),visitor);
			accept(e.getLeft(),visitor);
			if (e.getRight() != null) {
				accept(e.getRight(),visitor);
			}
			visitor.visit((IteTermExpression)e);
		}else if (e instanceof CaseTermExpression) {
			for(int index = 0 ; index < ((CaseTermExpression)e).getCases().size() ; index ++) {
				accept(((CaseTermExpression) e).getCases().get(index),visitor);
				accept(((CaseTermExpression) e).getExpressions().get(index),visitor);
			}
			visitor.visit((CaseTermExpression)e);
		}else if (e instanceof SequenceTerm) {
			if(((SequenceTerm) e).getDefs() !=null) {
				for(SymbolDeclaration symb : ((SequenceTerm) e).getDefs()) {
					accept(symb,visitor);
				}
			}
			accept(((SequenceTerm) e).getReturn(),visitor);
			visitor.visit((SequenceTerm)e);
		}else if (e instanceof QuantifiedFormula) {
			if (((QuantifiedFormula) e).isTemplate()) {
				for(NamedType tp : ((QuantifiedFormula) e).getTypeParameter()) {
					accept(tp,visitor);
				}
			}
			for(SymbolDeclaration sd : ((QuantifiedFormula) e).getScope()) {
				accept(sd,visitor);
			}
			accept(e.getLeft(),visitor);
			visitor.visit(e);
		}else if (e instanceof SignedAtomicFormula) {
			accept(e.getLeft(),visitor);
			visitor.visit((SignedAtomicFormula)e);
		}
		
	}

	
	
}
