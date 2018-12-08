package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.CardinalityRestriction;
import com.utc.utrc.hermes.iml.iml.CaseTermExpression;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor;
import com.utc.utrc.hermes.iml.iml.Import;
import com.utc.utrc.hermes.iml.iml.IteTermExpression;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Multiplication;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.PropertyList;
import com.utc.utrc.hermes.iml.iml.SequenceTerm;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public interface IModelVisitor {
	
	public void visit(Import e) ;
	
	public void visit(Model e) ;
	
	public  void visit(ConstrainedType e);
	
	public  void visit(Assertion e);

	public  void visit(SymbolDeclaration e);
	
	public void visit(PropertyList e) ;
	
	public void visit(Property e) ;
	
	public void visit(SimpleTypeReference e);
	
	public void visit(SequenceTerm e) ;
	
	public void visit(TypeWithProperties e) ;
	
	public void visit(CardinalityRestriction e);
	
	public void visit(EnumRestriction e);
	
	public void visit(HigherOrderType e);
	
	public void visit(FolFormula e);
	
	public void visit(AtomicExpression e);
	
	public void visit(Addition e);
	
	public void visit(Multiplication e);
	
	public void visit(TermMemberSelection e);
	
	public void visit(SymbolReferenceTerm e);
	
	public void visit(ImplicitInstanceConstructor e);
	
	public void visit(TupleConstructor e);
	
	public void visit(SignedAtomicFormula e);
	
	public void visit(IteTermExpression e);
	
	public void visit(CaseTermExpression e);
	
	
	
}