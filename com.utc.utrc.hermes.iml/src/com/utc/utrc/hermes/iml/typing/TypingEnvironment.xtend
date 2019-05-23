package com.utc.utrc.hermes.iml.typing

import java.util.Map
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.Trait
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.RecordType
import com.utc.utrc.hermes.iml.iml.FunctionType
import org.eclipse.emf.ecore.util.EcoreUtil
import com.utc.utrc.hermes.iml.iml.SelfType

class TypingEnvironment {
	Map<NamedType, ImlType> bindingMap
	// These can be lists or combined?
	SimpleTypeReference typeContext
	SimpleTypeReference selfContext
	SymbolReferenceTerm symbolRefContext
	
	new() {
		bindingMap = newHashMap
	}

	def TypingEnvironment addContext(SimpleTypeReference ctx) {
		if (ctx === null) return this
		typeContext = remap(ctx, bindingMap) as SimpleTypeReference
		if (!(ctx.getType() instanceof Trait)) {
			selfContext = typeContext
		}
		if (!typeContext.getTypeBinding().isEmpty() &&
			typeContext.getType().getTypeParameter().size() === typeContext.getTypeBinding().size()) {
			for (var int i = 0; i < typeContext.getType().getTypeParameter().size(); i++) {
				bindingMap.put(typeContext.getType().getTypeParameter().get(i), typeContext.getTypeBinding().get(i))
			}
		}
		return this
	}

	def TypingEnvironment addContext(SymbolReferenceTerm ctx) {
		symbolRefContext = remap(ctx, bindingMap)
		if (ctx.getSymbol() instanceof SymbolDeclaration) {
			var SymbolDeclaration symbol = (ctx.getSymbol() as SymbolDeclaration)
			if (!symbolRefContext.getTypeBinding().isEmpty() &&
				symbol.getTypeParameter().size() === symbolRefContext.getTypeBinding().size()) {
				for (var int i = 0; i < symbol.getTypeParameter().size(); i++) {
					bindingMap.put(symbol.getTypeParameter().get(i), symbolRefContext.getTypeBinding().get(i))
				}
			}
		}
		return this
	}
	
	def ImlType remap(ImlType t, Map<NamedType, ImlType> map) {
		if (map.isEmpty || t instanceof SelfType) { 
			return EcoreUtil.copy(t)
		}
		switch (t) {
			ArrayType: {
				var retval = ImlFactory.eINSTANCE.createArrayType;
				retval.type = remap(t.type, map)
				for (d : t.dimensions) {
					// TODO : Should we TypingServices.clone the term expressions?
					retval.dimensions.add(ImlFactory::eINSTANCE.createOptionalTermExpr => [
						term = ImlFactory::eINSTANCE.createNumberLiteral => [value = 0];
					])
				}
				return retval
			}
			SimpleTypeReference: {
				if (map.containsKey(t.type)) {
					return EcoreUtil.copy(map.get(t.type))					
				}
				var retval = ImlFactory.eINSTANCE.createSimpleTypeReference;
				retval.type = t.type
				for (h : t.typeBinding) {
					if (h instanceof SimpleTypeReference) {
						if ((h as SimpleTypeReference).typeBinding.size === 0) {
							if (map.containsKey(h.type)) {
								retval.typeBinding.add(EcoreUtil.copy(map.get(h.type)))
							} else {
								retval.typeBinding.add(EcoreUtil.copy(h))
							}
						} else {
							retval.typeBinding.add(remap(h, map))
						}
					} else {
						retval.typeBinding.add(remap(h, map))
					}
				}
				return retval;
			}
			TupleType: {
				var retval = ImlFactory.eINSTANCE.createTupleType;
				for (s : t.types) {
					retval.types.add(remap(s, map))
				}
				return retval;
			}
			RecordType: {
				var retval = ImlFactory.eINSTANCE.createRecordType;
				for (s : t.symbols) {
					val ss = ImlFactory.eINSTANCE.createSymbolDeclaration
					ss.name = s.name
					ss.type = remap(s.type, map)
					retval.symbols.add(ss)
				}
				return retval;
			}
			FunctionType: { // Function type
				var retval = ImlFactory.eINSTANCE.createFunctionType;
				retval.domain = remap(t.domain, map)
				if (t.range !== null) {
					retval.range = remap(t.range, map)
				}
				return retval;
			}
		}
	}
	
	def SymbolReferenceTerm remap(SymbolReferenceTerm t, Map<NamedType, ImlType> map) {
		return ImlFactory.eINSTANCE.createSymbolReferenceTerm => [
			symbol = t.symbol;
			typeBinding.addAll(t.typeBinding.map[remap(map)])
		]
	}
	
	def getSelfType() {
		if (selfContext !== null) {
			return selfContext
		} else if (typeContext !== null) {
			return typeContext
		}
		return null;
	}

	def Map<NamedType, ImlType> getBindingMap() {
		return bindingMap
	}

	def SimpleTypeReference getSelfContext() {
		return selfContext
	}

	def SymbolReferenceTerm getSymbolRefContext() {
		return symbolRefContext
	}

	def SimpleTypeReference getTypeContext() {
		return typeContext
	}
}
