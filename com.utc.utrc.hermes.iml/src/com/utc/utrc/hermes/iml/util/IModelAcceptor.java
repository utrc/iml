/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.iml.Annotation;
import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.Assertion;
import com.utc.utrc.hermes.iml.iml.CardinalityRestriction;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.OptionalTermExpr;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.FunctionType;
import com.utc.utrc.hermes.iml.iml.ImlType;
import com.utc.utrc.hermes.iml.iml.Import;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.PropertyList;
import com.utc.utrc.hermes.iml.iml.RecordType;
import com.utc.utrc.hermes.iml.iml.SelfType;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.Trait;
import com.utc.utrc.hermes.iml.iml.TupleType;
import com.utc.utrc.hermes.iml.iml.TypeWithProperties;

public interface IModelAcceptor {
	
	public void accept(Model o, IModelVisitor visitor);
	
	public void accept(Import o, IModelVisitor visitor );
	
	public  void accept(NamedType o, IModelVisitor visitor);
	
	public  void accept(Annotation o, IModelVisitor visitor);
	
	public  void accept(Trait o, IModelVisitor visitor);
	
	public  void accept(Assertion o, IModelVisitor visitor);

	public  void accept(SymbolDeclaration e, IModelVisitor visitor);
	
	public void accept(PropertyList e, IModelVisitor visitor) ;
	
	public void accept(Property e, IModelVisitor visitor) ;
	
	public void accept(TypeWithProperties e, IModelVisitor visitor);
	
	public void accept(CardinalityRestriction e, IModelVisitor visitor);
	
	public void accept(EnumRestriction e, IModelVisitor visitor);
	
	public void accept(ImlType e, IModelVisitor visitor);
	
	public void accept(SimpleTypeReference e, IModelVisitor visitor);
	
	public void accept(ArrayType e, IModelVisitor visitor);
	
	public void accept(TupleType e, IModelVisitor visitor);
	
	public void accept(RecordType e, IModelVisitor visitor);
	
	public void accept(FunctionType e, IModelVisitor visitor);
	
	public void accept(SelfType e, IModelVisitor visitor);
	
	public void accept(OptionalTermExpr t, IModelVisitor visitor);
	
	public void accept(FolFormula e, IModelVisitor visitor);
}
