/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.CaseTermExpression
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.EnumRestriction
import com.utc.utrc.hermes.iml.iml.Extension
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.InstanceConstructor
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula
import com.utc.utrc.hermes.iml.iml.SelfTerm
import com.utc.utrc.hermes.iml.iml.SelfType
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.TruthValue
import com.utc.utrc.hermes.iml.iml.TupleConstructor
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.TypeRestriction
import com.utc.utrc.hermes.iml.util.ImlUtil
import java.util.HashMap
import java.util.Map
import org.eclipse.emf.ecore.util.EcoreUtil
import org.eclipse.xtext.EcoreUtil2

import static extension org.eclipse.xtext.EcoreUtil2.*
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.ExpressionTail
import com.utc.utrc.hermes.iml.iml.FunctionType
import com.utc.utrc.hermes.iml.iml.TailedExpression
import com.utc.utrc.hermes.iml.iml.StringLiteral
import com.utc.utrc.hermes.iml.iml.CharLiteral
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import com.utc.utrc.hermes.iml.iml.RecordType
import com.utc.utrc.hermes.iml.iml.MatchExpression
import com.utc.utrc.hermes.iml.iml.MatchStatement
import com.utc.utrc.hermes.iml.iml.RecordConstructor
import com.utc.utrc.hermes.iml.iml.TraitExhibition
import com.utc.utrc.hermes.iml.iml.DatatypeConstructor
import com.utc.utrc.hermes.iml.iml.Trait

class ImlTypeProvider {
	
	@Inject
	extension ImlStdLib
	
	@Inject 
	extension TypingServices

	def ImlType termExpressionType(FolFormula t) {
		val container = t.getContainerOfType(NamedType);
		val ctx = new TypingEnvironment
		if(container !== null) {
			ctx.addContext(ImlCustomFactory.INST.createSimpleTypeReference(container))
		} 
		termExpressionType(t, ctx)
	}

	def ImlType termExpressionType(TermExpression t) {
		val container = t.getContainerOfType(NamedType);
		val ctx = new TypingEnvironment
		if(container !== null) {
			ctx.addContext(ImlCustomFactory.INST.createSimpleTypeReference(container))
		} 
		termExpressionType(t, ctx)
	}
	
	def ImlType termExpressionType(FolFormula t, TypingEnvironment context) {
		if (t instanceof TermExpression) {
			return termExpressionType((t as TermExpression), context)
		}
		if (t instanceof AtomicExpression) {
			return createBoolRef
		}
		return t.left.termExpressionType(context);
	}
	
	def ImlType termExpressionType(TermExpression t, TypingEnvironment context) {
		return normalizeType(expressionType(t, context))
	}
	

	/* Compute the type of a TermExpression 
	 * This is the most important function in the type provider. 
	 * Given a term expression, this function returns a type reference
	 * that contains stereotypes, type and type binding information
	 * for the term. 
	 * */
	def ImlType expressionType(TermExpression t, TypingEnvironment context) {

		switch (t) {
			// If the expression is "self", then its type is 
			// type of the container type.
			SelfTerm: {
				var typeContainer = t.getContainerOfType(NamedType);
				// TODO selfterm in trait is tricky, need to resolve
				if (typeContainer instanceof Trait && context.selfContext !== null) {
					return context.selfContext
				} else {
					return bind(ImlCustomFactory.INST.createSimpleTypeReference(typeContainer), context)
				}
			}
			// Additions are among numeric types and the result is a numeric 
			// type. If one of the two terms is real, then the type is real
			// otherwise it is integer.
			Addition: {
				// note that in iml grammar, addition includes both "+" and "-".
				if (t.left.termExpressionType(context).isReal ||
					t.right.termExpressionType(context).isReal) {
					return createRealRef
				}
				return createIntRef
			}
			// For reminder and modulo, the result is integer
			// For multiplication and division, the result is numeric
			// Multiplication of integers is an integer, otherwise the result
			// is a real number.
			Multiplication: {

				if (t.sign == '%' || t.sign == 'mod') {
					return createIntRef;
				}

				// note that in iml grammar, multiplication includes both "x" and "/".
				if (t.left.termExpressionType(context).isReal ||
					t.right.termExpressionType(context).isReal || t.sign == '/') {
					return createRealRef
				}
				return createIntRef;
			}
			// Compute the actual type reference which 
			// depends on the types of the change of member selections
			TermMemberSelection: {
				val receiverType = termExpressionType(t.receiver, context)
				if (receiverType instanceof SimpleTypeReference) {
					return termExpressionType(t.member, context.addContext(receiverType))
				} else if (receiverType instanceof RecordType) {
					return termExpressionType(t.member, context)
				} else if (receiverType instanceof SelfType) {
					return receiverType
				} else {
					throw new IllegalArgumentException("TermMemberSelection receiver should be simple type or record type only.")	
				}
			}
			TailedExpression: {
				var leftType = termExpressionType(t.left, context)
				return accessTail(leftType, t.tail)
			}
			SymbolReferenceTerm: {
				val symbolType =getSymbolReferenceType(t, context)
				return normalizeType(symbolType, context.selfType)

			}
			// A number literal is always an integer
			NumberLiteral: {
				return createIntRef;

			}
			FloatNumberLiteral: {
				return createRealRef;

			}
			StringLiteral :{
				return createStringRef;
			}
			
			CharLiteral : {
				return createCharRef;
			}
			
			IteTermExpression: {
				return termExpressionType(t.left, context)
			}
			CaseTermExpression: {
				return termExpressionType(t.expressions.get(0), context)
			}
			
			TruthValue: {
				return createBoolRef;
			}
			LambdaExpression: {
				var retval = ImlFactory.eINSTANCE.createFunctionType
				if (t.parameters !== null && t.parameters.size === 1){
					retval.domain = clone(t.parameters.get(0).type)
				} else {
					retval.domain = ImlCustomFactory.INST.createTupleType(t.parameters.map[clone(type)])
				}
				retval.range = (t.definition as SequenceTerm).^return.termExpressionType(context)
				return retval
			}
			InstanceConstructor: {
				return t.ref.type
			}
			TupleConstructor: {
				return ImlFactory.eINSTANCE.createTupleType => [
					types.addAll(t.elements.map[it.termExpressionType(context)]);
				]
			}
			RecordConstructor: {
				return ImlFactory.eINSTANCE.createRecordType => [
					symbols.addAll(t.elements.map[
						ImlCustomFactory.INST.createSymbolDeclaration(it.name, it.definition.termExpressionType(context))
					])
				]
			}
			SequenceTerm: {
				return t.^return.termExpressionType(context)
			}
			ParenthesizedTerm : {
				return t.sub.termExpressionType(context)
			} 
			QuantifiedFormula : {
				return createBoolRef
			}
			MatchExpression : {
				return t.matchStatements.get(0).^return.termExpressionType(context)
			}
			default: {
				return createNullRef
			}
		}
	}
	
	def isEnumLiteral(Symbol s) {
		val container = EcoreUtil2.getContainerOfType(s, NamedType)
		if (container !== null) {
			return isLiteralOf(s, container)
		}
		return false
	}

	def isLiteralOf(Symbol s, NamedType t) {
		for (TypeRestriction r : t.restrictions) {
			if (r instanceof EnumRestriction) {
				if (r.literals.contains(s)) {
					return true;
				}
			}
		}
		return false;
	}
	
	def getSymbolReferenceType(SymbolReferenceTerm sr, TypingEnvironment context) {
		if (sr.symbol instanceof NamedType) {
			if (isAlias(sr.symbol as NamedType)) {
				return getAliasType(sr.symbol as NamedType)
			} else {
				// FIXME some stuff here need to be refactored as it seems we have duplicate code
				var SimpleTypeReference retType = ImlCustomFactory.INST.createSimpleTypeReference=>[type = sr.symbol as NamedType];
				retType.typeBinding.addAll(sr.typeBinding.map[it.clone])
				return bind(retType, context)
			}
		} else if (sr.symbol.isEnumLiteral) {
			// Accessing specific literal
			return bind(ImlCustomFactory.INST.createSimpleTypeReference(EcoreUtil2.getContainerOfType(sr.symbol, NamedType)), context)
		} else if (sr.symbol.eContainer instanceof MatchStatement && 
					(sr.symbol.eContainer as MatchStatement).paramSymbols.contains(sr.symbol)) { // Datatype constructor symbol
			val matchStatment = sr.symbol.eContainer as MatchStatement
			val constructor = matchStatment.constructor
			val symbolType = constructor.parameters.get(matchStatment.paramSymbols.indexOf(sr.symbol))
			return bind(symbolType, context)
		} else {
			// Reference to a symbol declaration
			return getType(sr, context);
		}
		
	}

	def accessTail(ImlType type, ExpressionTail tail) {
		if (tail instanceof ArrayAccess) {
			if (type instanceof ArrayType) {
				return accessArray(type as ArrayType, tail as ArrayAccess)
			} else if (type instanceof TupleType) {
				return accessTuple(type as TupleType, tail as ArrayAccess)
			}
		} else if (tail instanceof TupleConstructor) { // Method invocation using Tuple
			if (type instanceof FunctionType) {
				return type.range
			}  else if (type instanceof RecordType) {
				return accessRecord(type as RecordType, tail as TupleConstructor)
			}
		} else {
			throw new IllegalArgumentException("Unknown tail type: " + tail.class)
		}
		return type
	}

	def accessArray(ArrayType type, ArrayAccess arrayAccessTail) {
		type.dimensions.remove(type.dimensions.size - 1)
		if (type.dimensions.isEmpty) {
			return type.type
		} else {
			return type
		}
	}

	def accessTuple(TupleType type, ArrayAccess arrayAccessTail) {
		val index = arrayAccessTail.index // It should be integer or symbol a[0] or a[symbolName]
		if (index.left !== null) {
			val indexAtomic = index.left
			if (indexAtomic instanceof NumberLiteral) { // Specific index
				val indexValue = indexAtomic.value * (if(indexAtomic.neg) -1 else 1)
				if (indexValue >= 0 && indexValue < type.types.size) {
					return type.types.get(indexValue)
				}
			}
		}
		return type
	}
	
	def accessRecord(RecordType type, TupleConstructor accessTail) {
		if (accessTail.elements.size === 1) {
			val element = accessTail.elements.get(0)
			if (element.left !== null) {
				val atomic = element.left
				if (atomic instanceof SymbolReferenceTerm) { // Specific symbol
					for (symbol : type.symbols) {
						if (symbol.name !== null && symbol.name == atomic.symbol.name) {
							return symbol.type
						}
					}
				}
			}
		}
			return type
	}
	
	// FIXME this is a temp implementation as we ignore SymbolDeclaration templates
	// TODO do we need this? Why not getType(SymbolTermReference, SimpleTypeReference)?
//	def ImlType getType(SymbolDeclaration s, SimpleTypeReference ctx) {
//		if (ImlUtil.isGlobalSymbol(s)) {
//			return s.type // Global symbols doesn't need binding with context
//		}
//		if (ctx === null) {
//			return s.type
//		}
//		if (!s.isTemplate) {
//			if ( ctx.type.symbols.contains(s) || symbolInsideLambda(s) || 
//				symbolInsideProgram(s)
//			) {
//				return bind(s.type,ctx)
//			}
//			
//			for (rel : ctx.type.relations) {
//				switch (rel) {
//					Extension: {
//						for (twp : rel.extensions) {
//							val target = twp.type
//							if (target instanceof SimpleTypeReference) {
//								var sup = bind(target, ctx) as SimpleTypeReference
//								var retval = getType(s, sup);
//								if (retval !== null) {
//									return retval;
//								}
//							}
//	
//						}
//					}
//				}
//			}
//			return null;
//		} else {
//			return s.type
//		}
//	}

	def ImlType getType(SymbolReferenceTerm s, TypingEnvironment context) {
		var ctx = context;
//		if (ctx === null) {
//			ctx = getSymbolRefContext(s) as SimpleTypeReference
//		}
		
		if (ctx.typeContext === null || ctx.typeContext.type === null) {
			if ( s.symbol instanceof SymbolDeclaration) {
				val symbolDecl = s.symbol as SymbolDeclaration
				if (! symbolDecl.isPolymorphic) {
					return EcoreUtil.copy(symbolDecl.type)
				}
				//TODO take care of type binding here
				var retval = EcoreUtil.copy(symbolDecl.type)
				if (symbolDecl.typeParameter.size != s.typeBinding.size) return retval; // Precondition
				
				//replace all type parameters with the new ones
				var ctmap = new HashMap<NamedType,ImlType>()
				for(var i = 0; i < symbolDecl.typeParameter.size();i++){
					ctmap.put(symbolDecl.typeParameter.get(i),s.typeBinding.get(i))
				}
				return context.remap(retval,ctmap);
			}
		}
		
		if (s.symbol instanceof SymbolDeclaration) {
			if ((s.symbol as SymbolDeclaration).type instanceof SelfType){
				if (ctx.selfContext !== null) {
					return ctx.selfContext;
				} else {
					return (s.symbol as SymbolDeclaration).type
				}
			}
			
			if (ctx.typeContext.type.symbols.contains(s.symbol as SymbolDeclaration) || isSymbolLocalScope(s.symbol as SymbolDeclaration)) {
				return bind(s, ctx)
			}
		}
		
		if(s.symbol instanceof DatatypeConstructor) {
			return ctx.typeContext
		}
		
		val relatedTypes = newArrayList
		for (rel : ctx.typeContext.type.relations) {
			switch (rel) {
				Extension: {
					for (twp : rel.extensions) {
						relatedTypes.add(twp.type)
					}
				}
				TraitExhibition: {
					for (twp : rel.exhibitions) {
						relatedTypes.add(twp.type)
					}
				}
			}
		}
		for (target : relatedTypes) {
			if (target instanceof SimpleTypeReference) {
				var sup = bind(target, ctx) as SimpleTypeReference
				var retval = getType(s, ctx.addContext(sup));
				if (retval !== null) {
					return retval;
				}
			}
		}
		return null;
	}
	
	def isSymbolLocalScope(SymbolDeclaration symbol) {
		val container = symbol.eContainer
		if (container instanceof RecordType || container instanceof QuantifiedFormula || container instanceof LambdaExpression
			|| container instanceof InstanceConstructor || container instanceof SequenceTerm
		) {
			return true
		}
		return false
	}
	
	def getSymbolRefContext(SymbolReferenceTerm symbolRef) {
		return getSymbolRefContext(symbolRef, symbolRef.eContainer)		
	}
	
	def SimpleTypeReference getSymbolRefContext(SymbolReferenceTerm symbolRef, EObject container) {
		switch (container) {
			TermMemberSelection: {
				if (container.member == symbolRef.symbol) {
					return termExpressionType(container.receiver) as SimpleTypeReference
				}
			}
			NamedType: {
				if (container.symbols.contains(symbolRef.symbol)) {
					return ImlCustomFactory.INST.createSimpleTypeReference(container)
				}
				
				getContextFromRelation(symbolRef, ImlCustomFactory.INST.createSimpleTypeReference(container))
				
				for (target : ImlUtil.getRelationTypes(container, Extension)) {
					if (target.type instanceof SimpleTypeReference && (target.type as SimpleTypeReference).type.symbols.contains(symbolRef.symbol)) {
						return target.type as SimpleTypeReference
					}
				}
			}
			Model: {
				return null; // End of recursion
			}
		}
		return getSymbolRefContext(symbolRef, container.eContainer)
	}
	
	def getContextFromRelation(SymbolReferenceTerm term, SimpleTypeReference ctx) {
		
	}
		
	/**
	 * Check if symbol declaration is defined inside a program
	 */
	def symbolInsideProgram(SymbolDeclaration symbol) {
		return symbol.eContainer instanceof SequenceTerm
	}

	/**
	 * Check if symbol declaration is defined inside a lambda signature
	 */
	def symbolInsideLambda(SymbolDeclaration symbol) {
		return symbol.eContainer instanceof LambdaExpression &&
			(symbol.eContainer as LambdaExpression).parameters.contains(symbol)
	}

	def bind(SymbolReferenceTerm s, TypingEnvironment ctx) {
		if (ctx.typeContext.type === null){
			return clone((s.symbol as SymbolDeclaration).type)
		}
		
		if (s.symbol instanceof SymbolDeclaration) {
			ctx.addContext(s)
			bind((s.symbol as SymbolDeclaration).type, ctx)
		} else {
			return ctx.typeContext
		}
//		var partialbind = new HashMap<NamedType, ImlType>();
//		for(var i =0 ; i < s.typeBinding.size() ; i++){
//			var NamedType typeParameter = null;
//			if (s.symbol instanceof NamedType) {
//				typeParameter = (s.symbol as NamedType).typeParameter.get(i)
//			} else if (s.symbol instanceof SymbolDeclaration) {
//				typeParameter = (s.symbol as SymbolDeclaration).typeParameter.get(i)
//			} else {
//				throw new IllegalArgumentException("Type " + s.symbol.class + " doesn't support type parameters!")
//			}
//			partialbind.put(typeParameter, s.typeBinding.get(i))
//		}
//		if (s.symbol instanceof SymbolDeclaration) {
//			return bind((s.symbol as SymbolDeclaration).type, partialbind,ctx)
//		} 
//		System.out.println(s.symbol.name + " is just a symbol ") ;
//		ctx
	}

	def bind(ImlType t, TypingEnvironment ctx) {
//		if (ctx === null) return t; // Precondition
//		var ctxbinds = new HashMap<NamedType, ImlType>();
//		if (ctx.typeBinding.size == ctx.type.typeParameter.size) {
//			for (i : 0 ..< ctx.type.typeParameter.size) {
//				ctxbinds.put(ctx.type.typeParameter.get(i), ctx.typeBinding.get(i))
//			}
//		}

		return ctx.remap(t, ctx.bindingMap)
	}
	
	def bind(ImlType t, Map<NamedType, ImlType> partialbind, TypingEnvironment ctx) {
		var ctxbinds = new HashMap<NamedType, ImlType>();
		ctxbinds.putAll(partialbind)
//		if (ctx.typeBinding.size == ctx.type.typeParameter.size) {
//			for (i : 0 ..< ctx.type.typeParameter.size) {
//				ctxbinds.put(ctx.type.typeParameter.get(i), ctx.typeBinding.get(i))
//			}
//		}
		ctxbinds.putAll(ctx.bindingMap)

		return ctx.remap(t, ctxbinds)
	}


	def boolean isPolymorphic(Symbol s){
		switch(s){
			NamedType : { return s.typeParameter.size > 0 }
			SymbolDeclaration : { return s.typeParameter.size > 0 }
			default:
				return false
		}
	}
}
