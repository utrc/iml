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
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor;
import com.utc.utrc.hermes.iml.iml.Import;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.PropertyList;
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SequenceTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.Trait;
import com.utc.utrc.hermes.iml.iml.TraitExhibition;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public abstract class AbstractModelAcceptor implements IModelAcceptor {

	@Override
	public void accept(Model m, IModelVisitor visitor) {
		for(Import i : m.getImports()) {
			accept(i,visitor);
		}
		for(Symbol s : m.getSymbols()) {
			if (s instanceof Assertion) {
				accept((Assertion)s,visitor) ;
			} else if (s  instanceof ConstrainedType) {
				if (s instanceof Annotation) {
					accept((Annotation)s,visitor);
				} else if (s instanceof Trait) {
					accept((Trait)s,visitor);
				} else {
					accept((ConstrainedType)s,visitor);
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
	public  void accept(ConstrainedType s, IModelVisitor visitor) {
		if (s.getPropertylist() != null) {
			accept(s.getPropertylist(),visitor);
		}
		if (s.isTemplate()) {
			for(ConstrainedType tp : s.getTypeParameter()) {
				accept(tp, visitor);
			}
		}
		if (s.getRelations() != null) {
			for(Relation r : s.getRelations()) {
				if (r instanceof Extension) {
					for(TypeWithProperties p : ((Extension) r).getExtensions()) {
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
		if (s.getRestrictions() != null) {
			for(TypeRestriction r : s.getRestrictions()) {
				if (r instanceof CardinalityRestriction) {
					accept((CardinalityRestriction)r, visitor);
				}
				if (r instanceof EnumRestriction) {
					accept((EnumRestriction)r,visitor);
				}
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
			for(ConstrainedType tp : s.getTypeParameter()) {
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
		for(ImplicitInstanceConstructor p : l.getProperties()) {
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
			for(HigherOrderType t : s.getTypeBinding()) {
				accept(t,visitor);
			}
		}
		visitor.visit(s);
	}

	

	@Override
	public void accept(Annotation s, IModelVisitor visitor) {
		if (s.getRelations() != null) {
			for(Relation r : s.getRelations()) {
				if (r instanceof Extension) {
					for(TypeWithProperties p : ((Extension) r).getExtensions()) {
						accept(p,visitor);
					}
				}
			}
		}
		if (s.getRestrictions() != null) {
			for(TypeRestriction r : s.getRestrictions()) {
				if (r instanceof CardinalityRestriction) {
					accept((CardinalityRestriction)r, visitor);
				}
				if (r instanceof EnumRestriction) {
					accept((EnumRestriction)r,visitor);
				}
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
			for(ConstrainedType tp : s.getTypeParameter()) {
				accept(tp, visitor);
			}
		}
		if (s.getRelations() != null) {
			for(Relation r : s.getRelations()) {
				if (r instanceof Extension) {
					for(TypeWithProperties p : ((Extension) r).getExtensions()) {
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
		if (s.getRestrictions() != null) {
			for(TypeRestriction r : s.getRestrictions()) {
				if (r instanceof CardinalityRestriction) {
					accept((CardinalityRestriction)r, visitor);
				}
				if (r instanceof EnumRestriction) {
					accept((EnumRestriction)r,visitor);
				}
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
	public void accept(HigherOrderType e, IModelVisitor visitor) {
		//TODO Accept
		visitor.visit(e);
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
			if (((SymbolReferenceTerm) e).getTails() != null) {
				for(SymbolReferenceTail tail : ((SymbolReferenceTerm) e).getTails()) {
					if (tail instanceof TupleConstructor) {
						accept((TupleConstructor) tail, visitor);
					} else {
						accept(((ArrayAccess)tail).getIndex(),visitor );
					}
				}
			}
			visitor.visit((SymbolReferenceTerm)e);
		}else if (e instanceof ImplicitInstanceConstructor) {
			accept(((ImplicitInstanceConstructor) e).getRef(),visitor) ;
			accept((SequenceTerm) ((ImplicitInstanceConstructor)e).getDefinition(),visitor);
			visitor.visit((ImplicitInstanceConstructor)e);
		}else if (e instanceof TupleConstructor) {
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
				for(ConstrainedType tp : ((QuantifiedFormula) e).getTypeParameter()) {
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