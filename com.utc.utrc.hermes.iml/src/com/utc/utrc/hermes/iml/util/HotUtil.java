package com.utc.utrc.hermes.iml.util;

import com.utc.utrc.hermes.iml.iml.ArrayType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.ParenthesizedType;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.iml.TupleType;

public class HotUtil {
	
	public static HigherOrderType removeParenthesis(HigherOrderType type) {
		if (type instanceof ParenthesizedType) {
			return removeParenthesis(((ParenthesizedType) type).getSubexpression());
		} else {
			return type;
		}
	}
	
	public static boolean isSimpleHot(HigherOrderType type) {
		type = removeParenthesis(type);

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
		if (type instanceof ParenthesizedType) {
			return isActualHot(((ParenthesizedType) type).getSubexpression());
		}
		if (type.getRange() != null) {
			return true;
		}
		return false;
	}
	
	public static HigherOrderType domain(HigherOrderType type) {
		type = removeParenthesis(type);
		return removeParenthesis(type.getDomain());
	}
	
	public static HigherOrderType range(HigherOrderType type) {
		type = removeParenthesis(type);
		return removeParenthesis(type.getRange());
	}

}
