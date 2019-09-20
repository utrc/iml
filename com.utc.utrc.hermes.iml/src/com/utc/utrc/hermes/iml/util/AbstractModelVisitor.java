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

public abstract class AbstractModelVisitor implements IModelVisitor {

	@Override
	public Object visit(Import e) {
		return null;

	}

	@Override
	public Object visit(Model e) {
		return null;

	}

	@Override
	public Object visit(NamedType e) {
		return null;

	}

	@Override
	public Object visit(Assertion e) {
		return null;

	}

	@Override
	public Object visit(SymbolDeclaration e) {
		return null;

	}

	@Override
	public Object visit(PropertyList e) {
		return null;

	}

	@Override
	public Object visit(Property e) {
		return null;

	}

	@Override
	public Object visit(SimpleTypeReference e) {
		return null;

	}

	@Override
	public Object visit(SequenceTerm e) {
		return null;

	}

	@Override
	public Object visit(TypeWithProperties e) {
		return null;

	}

	@Override
	public Object visit(CardinalityRestriction e) {
		return null;

	}

	@Override
	public Object visit(EnumRestriction e) {
		return null;

	}

	@Override
	public Object visit(ImlType e) {
		return null;

	}

	@Override
	public Object visit(FolFormula e) {
		return null;

	}

	@Override
	public Object visit(AtomicExpression e) {
		return null;

	}

	@Override
	public Object visit(Addition e) {
		return null;

	}

	@Override
	public Object visit(Multiplication e) {
		return null;

	}

	@Override
	public Object visit(TermMemberSelection e) {
		return null;

	}

	@Override
	public Object visit(SymbolReferenceTerm e) {
		return null;

	}
	
	@Override
	public Object visit(TailedExpression e) {
		return null;
		
	}

	@Override
	public Object visit(TupleConstructor e) {
		return null;

	}

	@Override
	public Object visit(SignedAtomicFormula e) {
		return null;

	}

	@Override
	public Object visit(IteTermExpression e) {
		return null;

	}

	@Override
	public Object visit(CaseTermExpression e) {
		return null;
	}
	
	@Override
	public Object visit(OptionalTermExpr e) {
		return null;
	}

}
