package com.utc.utrc.hermes.iml.gen.nusmv.generator;

import java.util.ArrayList;
import java.util.List;

import com.utc.utrc.hermes.iml.iml.EnumRestriction;
import com.utc.utrc.hermes.iml.iml.NamedType;
import com.utc.utrc.hermes.iml.iml.Property;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm;
import com.utc.utrc.hermes.iml.iml.TypeRestriction;

public class NuSmvTranslationProvider {

	
	public static boolean isEnum(NamedType t) {
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

	public static boolean isA(SymbolDeclaration s, NamedType imlType) {
		if (s.getPropertylist() == null)
			return false;
		for (Property p : s.getPropertylist().getProperties()) {
			if (((SimpleTypeReference) p.getRef()).getType() == imlType) {
				return true;
			}
		}
		return false;
	}
	
	public static boolean isConnect(SymbolReferenceTerm s) {
		return (s.getSymbol().getName().equals("connect")) ;
	}
	

	public static boolean hasType(SymbolDeclaration s, NamedType imlType) {
		if (s.getType() instanceof SimpleTypeReference) {
			if (((SimpleTypeReference) s.getType()).getType() == imlType) {
				return true;
			}
		}
		return false;
	}

	public static List<String> getLiterals(NamedType t) {
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
