package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.TermExpression
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.SelfTerm
import com.utc.utrc.hermes.iml.iml.TruthValue
import java.util.Map

import static extension com.utc.utrc.hermes.iml.typing.TypingServices.*
import static extension org.eclipse.xtext.EcoreUtil2.*
import java.util.HashMap
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import org.eclipse.xtext.EcoreUtil2
import com.utc.utrc.hermes.iml.iml.InstanceConstructor
import com.utc.utrc.hermes.iml.iml.TupleConstructor
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.TypeRestriction
import java.util.Enumeration
import com.utc.utrc.hermes.iml.iml.EnumRestriction
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor
import com.utc.utrc.hermes.iml.iml.ParenthesizedType
import org.eclipse.emf.ecore.util.EcoreUtil
import com.utc.utrc.hermes.iml.iml.Assertion
import com.utc.utrc.hermes.iml.iml.SelfType
import com.utc.utrc.hermes.iml.iml.ParenthesizedTerm
import com.utc.utrc.hermes.iml.iml.CaseTermExpression

public class ImlTypeProvider {

	public static val Any = createBasicType('Any')

	public static val Int = createBasicType('Int')

	public static val Null = createBasicType('Null')

	public static val Real = createBasicType('Real')

	public static val Bool = createBasicType('Bool')

	public static val String = createBasicType('String')

	def static HigherOrderType termExpressionType(FolFormula t) {
		termExpressionType(t, createSimpleTypeRef(t.getContainerOfType(ConstrainedType)))
	}

	def static HigherOrderType termExpressionType(TermExpression t) {
		termExpressionType(t, createSimpleTypeRef(t.getContainerOfType(ConstrainedType)))
	}
	
	def static HigherOrderType termExpressionType(FolFormula t, SimpleTypeReference context) {
		if (t instanceof TermExpression) {
			return termExpressionType((t as TermExpression), context)
		}
		if (t instanceof AtomicExpression) {
			return Bool
		}
		return t.left.termExpressionType(context);
	}

	/* Compute the type of a TermExpression 
	 * This is the most important function in the type provider. 
	 * Given a term expression, this function returns a type reference
	 * that contains stereotypes, type and type binding information
	 * for the term. 
	 * */
	def static HigherOrderType termExpressionType(TermExpression t, SimpleTypeReference context) {

		switch (t) {
			// If the expression is "self", then its type is 
			// type of the container type.
			SelfTerm: {
//				if (context.eContainer instanceof InstanceConstructor) {
//					return context // This here refers to the container type constructor
//				}
				return bind(createBasicType(t.getContainerOfType(ConstrainedType)), context)
			}
			// Additions are among numeric types and the result is a numeric 
			// type. If one of the two terms is real, then the type is real
			// otherwise it is integer.
			Addition: {
				// note that in csl grammar, addition includes both "+" and "-".
				if (t.left.termExpressionType(context).isEqual(Real) ||
					t.right.termExpressionType(context).isEqual(Real)) {
					return Real
				}
				return Int
			}
			// For reminder and modulo, the result is integer
			// For multiplication and division, the result is numeric
			// Multiplication of integers is an integer, otherwise the result
			// is a real number.
			Multiplication: {

				if (t.sign == '%' || t.sign == 'mod') {
					return Int;
				}

				// note that in csl grammar, multiplication includes both "x" and "/".
				if (t.left.termExpressionType(context).isEqual(Real) ||
					t.right.termExpressionType(context).isEqual(Real) || t.sign == '/') {
					return Real
				}
				return Int;
			}
			// Compute the actual type reference which 
			// depends on the types of the change of member selections
			TermMemberSelection: {
				val receiverType = termExpressionType(t.receiver, context)
				if (receiverType instanceof SimpleTypeReference) {
					return termExpressionType(t.member, receiverType)
				} else
					return null // TODO Should we raise an exception better?
			}
			SymbolReferenceTerm: {
				if (t.symbol instanceof ConstrainedType) {
					// Reference to a literal
					return createBasicType(t.symbol as ConstrainedType)
				} else if (t.symbol.eContainer instanceof ConstrainedType &&
					t.symbol.isLiteralOf(t.symbol.eContainer as ConstrainedType)) {
					// Accessing specific literal
					return createBasicType(t.symbol.eContainer as ConstrainedType)
				} else {
					// Reference to a symbol
					return getSymbolReferenceType(t, context)
				}

			}
			// A number literal is always an integer
			NumberLiteral: {
				return Int;

			}
			FloatNumberLiteral: {
				return Real;

			}
			IteTermExpression: {
				return termExpressionType(t.left, context)
			}
			CaseTermExpression: {
				return termExpressionType(t.expressions.get(0), context)
			}
			
			TruthValue: {
				return Bool;
			}
			LambdaExpression: {
				var HigherOrderType d = null
				if (t.signature instanceof TupleType && (t.signature as TupleType).symbols.size === 1){
					d = (t.signature as TupleType).symbols.get(0).type
				} else {
					d = t.signature
				}
				var retval = ImlFactory.eINSTANCE.createHigherOrderType
				retval.domain =  EcoreUtil2.clone(d)
				retval.range = (t.definition as SequenceTerm).^return.termExpressionType(context)
				return retval
			}
			InstanceConstructor: {
				return t.ref.type
			}
			ImplicitInstanceConstructor : {
				return t.ref ;
			}
			TupleConstructor: {
				return ImlFactory.eINSTANCE.createTupleType => [
					symbols.addAll(t.elements.map [
						val ts = ImlFactory.eINSTANCE.createSymbolDeclaration;
						ts.type = it.termExpressionType(context)
						ts
					]);
				]
			}
			SequenceTerm: {
				return t.^return.termExpressionType(context)
			}
			ParenthesizedTerm : {
				return t.sub.termExpressionType(context)
			}
			default: {
				return Null
			}
		}
	}

	def static isLiteralOf(Symbol s, ConstrainedType t) {
		for (TypeRestriction r : t.restrictions) {
			if (r instanceof EnumRestriction) {
				if (r.literals.contains(s)) {
					return true;
				}
			}
		}
		return false;
	}

	def static getSymbolReferenceType(SymbolReferenceTerm term, SimpleTypeReference context) {
		//Change this call to include type parameters
		var term_type = getType(term, context);
		for (tail : term.tails) {
			term_type = accessTail(term_type, tail)
		}
		return term_type
	}

	def static accessTail(HigherOrderType type, SymbolReferenceTail tail) {
		if (tail instanceof ArrayAccess) {
			if (type instanceof ArrayType) {
				return accessArray(type as ArrayType, tail as ArrayAccess)
			} else if (type instanceof TupleType) {
				return accessTuple(type as TupleType, tail as ArrayAccess)
			}

		} else { // Method invocation using Tuple
			if (type.range !== null) {
				return type.range
			}
		}
		return type
	}

	def static accessArray(ArrayType type, ArrayAccess arrayAccessTail) {
		type.dimensions.remove(type.dimensions.size - 1)
		if (type.dimensions.isEmpty) {
			return type.type
		} else {
			return type
		}
	}

	def static accessTuple(TupleType type, ArrayAccess arrayAccessTail) {
		val index = arrayAccessTail.index // It should be integer or symbol a[0] or a[symbolName]
		if (index.left !== null) {
			val indexAtomic = index.left
			if (indexAtomic instanceof SymbolReferenceTerm) { // Specific symbol
				for (symbol : type.symbols) {
					if (symbol.name !== null && symbol.name == indexAtomic.symbol.name) {
						return symbol.type
					}
				}
			} else if (indexAtomic instanceof NumberLiteral) { // Specific index
				val indexValue = indexAtomic.value * (if(indexAtomic.neg) -1 else 1)
				if (indexValue >= 0 && indexValue < type.symbols.size) {
					return type.symbols.get(indexValue).type
				}
			}
		}
		return type
	}

	def static HigherOrderType getType(SymbolReferenceTerm s, SimpleTypeReference ctx) {
		if (ctx.type === null){
			if (! (s.symbol as SymbolDeclaration).isPolymorphic) {
				return EcoreUtil.copy( (s.symbol as SymbolDeclaration).type)
			}
			//TODO take care of type binding here
			var retval = EcoreUtil.copy((s.symbol as SymbolDeclaration).type)
			//replace all type parameters with the new ones
			var ctmap = new HashMap<ConstrainedType,HigherOrderType>()	
			for(var i = 0; i < (s.symbol as SymbolDeclaration).typeParameter.size();i++){
				ctmap.put((s.symbol as SymbolDeclaration).typeParameter.get(i),s.typeBinding.get(i))
			}
			return remap(retval,ctmap);
		}
		
		if (s.symbol instanceof SymbolDeclaration) {
			if ((s.symbol as SymbolDeclaration).type instanceof SelfType){
				return ctx;
			}
			
			if (ctx.type.symbols.contains(s.symbol as SymbolDeclaration) || symbolInsideLambda(s.symbol as SymbolDeclaration) || symbolInsideProgram(s.symbol as SymbolDeclaration)) {
				return bind(s, ctx)
			}
		}
		

		for (rel : ctx.type.relations) {
			switch (rel) {
				com.utc.utrc.hermes.iml.iml.Extension: {
					for (twp : rel.extensions) {
						val target = twp.type
						if (target instanceof SimpleTypeReference) {
							var sup = bind(target, ctx) as SimpleTypeReference
							var retval = getType(s, sup);
							if (retval !== null) {
								return retval;
							}
						}

					}
				}
			}
		}
		return null;
	}

	/**
	 * Check if symbol declaration is defined inside a program
	 */
	def static symbolInsideProgram(SymbolDeclaration symbol) {
		return symbol.eContainer instanceof SequenceTerm
	}

	/**
	 * Check if symbol declaration is defined inside a lambda signature
	 */
	def static symbolInsideLambda(SymbolDeclaration symbol) {
		return symbol.eContainer instanceof TupleType && symbol.eContainer.eContainer instanceof LambdaExpression &&
			(symbol.eContainer.eContainer as LambdaExpression).signature == symbol.eContainer
	}

	def static getTypeConstructorType(TermExpression term) {
		val typeConstructor = EcoreUtil2.getContainerOfType(term, InstanceConstructor)
		if (typeConstructor !== null) {
			return (typeConstructor.ref as SimpleTypeReference).type
		}
//		val tupleParent = EcoreUtil2.getContainerOfType(term, TupleConstructor)
//		if (tupleParent !== null) {
//			val srt = EcoreUtil2.getContainerOfType(tupleParent, SymbolReferenceTerm)
//			if (srt !== null && srt.symbol instanceof ConstrainedType) {
//				return srt.symbol as ConstrainedType
//			}
//		}
	}

	def static bind(SymbolReferenceTerm s, SimpleTypeReference ctx) {
		if (ctx.type === null){
			return (s.symbol as SymbolDeclaration).type
		}
		var partialbind = new HashMap<ConstrainedType, HigherOrderType>();
		for(var i =0 ; i < s.typeBinding.size() ; i++){
			partialbind.put(s.symbol.typeParameter.get(i),s.typeBinding.get(i))
		}
		return bind((s.symbol as SymbolDeclaration).type, partialbind,ctx)
	}

	def static bind(HigherOrderType t, SimpleTypeReference ctx) {
		var ctxbinds = new HashMap<ConstrainedType, HigherOrderType>();
		if (ctx.typeBinding.size == ctx.type.typeParameter.size) {
			for (i : 0 ..< ctx.type.typeParameter.size) {
				ctxbinds.put(ctx.type.typeParameter.get(i), ctx.typeBinding.get(i))
			}
		}

		return remap(t, ctxbinds)
	}
	
	def static bind(HigherOrderType t, Map<ConstrainedType, HigherOrderType> partialbind, SimpleTypeReference ctx) {
		var ctxbinds = new HashMap<ConstrainedType, HigherOrderType>();
		ctxbinds.putAll(partialbind)
		if (ctx.typeBinding.size == ctx.type.typeParameter.size) {
			for (i : 0 ..< ctx.type.typeParameter.size) {
				ctxbinds.put(ctx.type.typeParameter.get(i), ctx.typeBinding.get(i))
			}
		}

		return remap(t, ctxbinds)
	}

	def static HigherOrderType remap(HigherOrderType t, Map<ConstrainedType, HigherOrderType> map) {
		switch (t) {
			ArrayType: {
				var retval = ImlFactory.eINSTANCE.createArrayType;
				retval.type = remap(t.type, map)
				for (d : t.dimensions) {
					// TODO : Should we clone the term expressions?
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
								retval.typeBinding.add(clone(map.get(h.type)))
							} else {
								retval.typeBinding.add(clone(h))
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
				for (s : t.symbols) {
					val ss = ImlFactory.eINSTANCE.createSymbolDeclaration
					ss.name = s.name
					ss.type = remap(s.type, map)
					retval.symbols.add(ss)
				}
				return retval;
			}
			default: {
				var retval = ImlFactory.eINSTANCE.createHigherOrderType;
				retval.domain = remap(t.domain, map)
				if (t.range !== null) {
					retval.range = remap(t.range, map)
				}
				return retval;
			}
		}
	}

	def static boolean isPolymorphic(Symbol s){
		switch(s){
			ConstrainedType : { return s.typeParameter.size > 0 }
			SymbolDeclaration : { return s.typeParameter.size > 0 }
			default:
				return false
		}
	}

	/* Check whether t is primitive type */
	def static boolean isPrimitive(HigherOrderType t) {
		return ( t == Null || t == Int || t == Real || t == Bool || t == Any)
	}

	/* Check whether t is numeric type reference */
	def static boolean isNumeric(HigherOrderType t) {
		if (t == Int || t == Real) {
			return true;
		}
		return false;
	}

	/* Check whether t is numeric type reference */
	def static boolean isNumeric(ConstrainedType t) {
		if (t == Int.type || t == Real.type) {
			return true;
		}
		return false;
	}

	def static HigherOrderType ct2hot(ConstrainedType type) {
		return createBasicType(type)
	}

}
