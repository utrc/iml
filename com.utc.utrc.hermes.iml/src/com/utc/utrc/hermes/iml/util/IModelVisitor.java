/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.iml.Addition;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.AtomicExpression;
import com.utc.utrc.hermes.iml.iml.CardinalityRestriction;
import com.utc.utrc.hermes.iml.iml.CaseTermExpression;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.OptionalTermExpr;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.ImlType;
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
import com.utc.utrc.hermes.iml.iml.TailedExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public interface IModelVisitor<T> {
	
	public T visit(Import e) ;
	
	public T visit(Model e) ;
	
	public T visit(NamedType e);
	
	public T visit(Assertion e);

	public T visit(SymbolDeclaration e);
	
	public T visit(PropertyList e) ;
	
	public T visit(Property e) ;
	
	public T visit(SimpleTypeReference e);
	
	public T visit(SequenceTerm e) ;
	
	public T visit(TypeWithProperties e) ;
	
	public T visit(CardinalityRestriction e);
	
	public T visit(EnumRestriction e);
	
	public T visit(ImlType e);
	
	public T visit(FolFormula e);
	
	public T visit(AtomicExpression e);
	
	public T visit(Addition e);
	
	public T visit(Multiplication e);
	
	public T visit(TermMemberSelection e);
	
	public T visit(SymbolReferenceTerm e);
	
	public T visit(TailedExpression e);
	
	public T visit(TupleConstructor e);
	
	public T visit(SignedAtomicFormula e);
	
	public T visit(IteTermExpression e);
	
	public T visit(CaseTermExpression e);
	
	public T visit(OptionalTermExpr e);
	
}
