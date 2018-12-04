package com.utc.utrc.hermes.iml.gen.nusmv.generator;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.Relation;
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TermExpression;
import com.utc.utrc.hermes.iml.iml.TermMemberSelection;
import com.utc.utrc.hermes.iml.iml.TupleConstructor;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;
import com.utc.utrc.hermes.iml.util.AbstractModelAcceptor;
import com.utc.utrc.hermes.iml.util.AbstractModelVisitor;

public class NuSmvTranslationProvider {

	
	public static boolean isEnum(ConstrainedType t) {
		if (t.getRelations() == null) {
			return false;
		}
		for (TypeRestriction r : t.getRestrictions()) {
			if (r instanceof EnumRestriction) {
				return true;
			}
		}
		return false;

	}

	public static boolean isA(SymbolDeclaration s, ConstrainedType imlType) {
		if (s.getPropertylist() == null)
			return false;
		for (ImplicitInstanceConstructor p : s.getPropertylist().getProperties()) {
			if (((SimpleTypeReference) p.getRef()).getType() == imlType) {
				return true;
			}
		}
		return false;
	}
	
	public static boolean isConnect(SymbolReferenceTerm s) {
		return (s.getSymbol().getName().equals("connect")) ;
	}
	

	public static boolean hasType(SymbolDeclaration s, ConstrainedType imlType) {
		if (s.getType() instanceof SimpleTypeReference) {
			if (((SimpleTypeReference) s.getType()).getType() == imlType) {
				return true;
			}
		}
		return false;
	}

	public static List<String> getLiterals(ConstrainedType t) {
		List<String> retval = new ArrayList<String>();
		if (t.getRelations() != null) {

			for (TypeRestriction r : t.getRestrictions()) {
				if (r instanceof EnumRestriction) {
					for(SymbolDeclaration sd : ((EnumRestriction) r).getLiterals()) {
						retval.add(sd.getName());
					}
				}
			}
		}
		return retval;

	}

	
	
}
