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
import com.utc.utrc.hermes.iml.custom.ImlCustomFactory

class TypingEnvironment {
	Map<NamedType, ImlType> bindingMap
	// These can be lists or combined?
	SimpleTypeReference typeContext
	SimpleTypeReference selfContext
	SymbolReferenceTerm symbolRefContext
	
	new() {
		bindingMap = newHashMap
	}
	
	new(NamedType ctx) {
		this()
		addContext(ctx)		
	}
	
	new(SimpleTypeReference ctx) {
		this()
		addContext(ctx)		
	}
	
	new(SymbolReferenceTerm ctx) {
		this()
		addContext(ctx)		
	}
	
	def TypingEnvironment addContext(NamedType ctx) {
		if (ctx !== null) {
			addContext(ImlCustomFactory.INST.createSimpleTypeReference(ctx))
		}
		return this
	}

	def TypingEnvironment addContext(SimpleTypeReference ctx) {
		if (ctx === null) return this
		typeContext = remap(ctx) as SimpleTypeReference
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
		symbolRefContext = remap(ctx)
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
	
	def bind(SymbolReferenceTerm s) {
		if (typeContext.type === null){
			return EcoreUtil.copy((s.symbol as SymbolDeclaration).type)
		}
		
		if (s.symbol instanceof SymbolDeclaration) {
			addContext(s)
			bind((s.symbol as SymbolDeclaration).type)
		} else {
			return typeContext
		}
	}

	def bind(ImlType t) {
		return remap(t)
	}
	
	def ImlType remap(ImlType t) {
		if (bindingMap.isEmpty || t instanceof SelfType) { 
			return EcoreUtil.copy(t)
		}
		switch (t) {
			ArrayType: {
				var retval = ImlFactory.eINSTANCE.createArrayType;
				retval.type = remap(t.type)
				for (d : t.dimensions) {
					// TODO : Should we TypingServices.clone the term expressions?
					retval.dimensions.add(ImlFactory::eINSTANCE.createOptionalTermExpr => [
						term = ImlFactory::eINSTANCE.createNumberLiteral => [value = 0];
					])
				}
				return retval
			}
			SimpleTypeReference: {
				if (bindingMap.containsKey(t.type)) {
					return EcoreUtil.copy(bindingMap.get(t.type))					
				}
				var retval = ImlFactory.eINSTANCE.createSimpleTypeReference;
				retval.type = t.type
				for (h : t.typeBinding) {
					if (h instanceof SimpleTypeReference) {
						if ((h as SimpleTypeReference).typeBinding.size === 0) {
							if (bindingMap.containsKey(h.type)) {
								retval.typeBinding.add(EcoreUtil.copy(bindingMap.get(h.type)))
							} else {
								retval.typeBinding.add(EcoreUtil.copy(h))
							}
						} else {
							retval.typeBinding.add(remap(h))
						}
					} else {
						retval.typeBinding.add(remap(h))
					}
				}
				return retval;
			}
			TupleType: {
				var retval = ImlFactory.eINSTANCE.createTupleType;
				for (s : t.types) {
					retval.types.add(remap(s))
				}
				return retval;
			}
			RecordType: {
				var retval = ImlFactory.eINSTANCE.createRecordType;
				for (s : t.symbols) {
					val ss = ImlFactory.eINSTANCE.createSymbolDeclaration
					ss.name = s.name
					ss.type = remap(s.type)
					retval.symbols.add(ss)
				}
				return retval;
			}
			FunctionType: { // Function type
				var retval = ImlFactory.eINSTANCE.createFunctionType;
				retval.domain = remap(t.domain)
				if (t.range !== null) {
					retval.range = remap(t.range)
				}
				return retval;
			}
		}
	}
	
	def SymbolReferenceTerm remap(SymbolReferenceTerm t) {
		return ImlFactory.eINSTANCE.createSymbolReferenceTerm => [
			symbol = t.symbol;
			typeBinding.addAll(t.typeBinding.map[remap])
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
