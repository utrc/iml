package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
//import com.utc.utrc.hermes.iml.iml.ParenthesizedType;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;

public class HotUtil {
	
	public static boolean isSimpleHot(HigherOrderType type) {
		if (isActualHot(type)) {
			if (containsHot(type.getDomain())) {
				return false;
			}
			if (containsHot(type.getRange())) {
				return false;
			}
			return true;
		}
		return !containsHot(type);
	}

	public static boolean containsHot(HigherOrderType type) {
		if (isActualHot(type)) {
			return true;
		}
		
		if (type instanceof TupleType) {
			for (SymbolDeclaration tupleElement : ((TupleType) type).getSymbols()) {
				if (containsHot(tupleElement.getType())) {
					return true;
				}
			}
		}
		
		if (type instanceof ArrayType) {
			if (containsHot(((ArrayType) type).getType())) {
				return true;
			}
		}
		
		return false;
	}
	
	public static boolean isActualHot(HigherOrderType type) {
		if (type.getRange() != null) {
			return true;
		}
		return false;
	}
}
