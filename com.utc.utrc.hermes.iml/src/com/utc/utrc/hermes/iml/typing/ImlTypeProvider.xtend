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
import com.utc.utrc.hermes.iml.iml.This
import com.utc.utrc.hermes.iml.iml.TruthValue
import java.util.Map

import static extension com.utc.utrc.hermes.iml.typing.TypingServices.*
import static extension org.eclipse.xtext.EcoreUtil2.*
import java.util.HashMap
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.TupleConstructor
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.Program
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import org.eclipse.xtext.EcoreUtil2

public class ImlTypeProvider {

	public static val Any = createBasicType('Any')

	public static val Int = createBasicType('Int')

	public static val Null = createBasicType('Null')

	public static val Real = createBasicType('Real')

	public static val Bool = createBasicType('Bool')

	
	def static HigherOrderType termExpressionType(FolFormula t) {
		termExpressionType(t, createSimpleTypeRef(t.getContainerOfType(ConstrainedType)))
	}

	def static HigherOrderType termExpressionType(TermExpression t) {
		termExpressionType(t, createSimpleTypeRef(t.getContainerOfType(ConstrainedType)))
	}

	def static HigherOrderType termExpressionType(FolFormula t, SimpleTypeReference context) {
		if (t instanceof TermExpression) {
			return termExpressionType((t as TermExpression), context)
		} if (t instanceof SignedAtomicFormula) {
			
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
			// If the expression is "this", then its type is the 
			// type of the container type.
			This: {
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
				val receiverType = termExpressionType(t.receiver,context)
				if (receiverType instanceof SimpleTypeReference) {
					return termExpressionType(t.member, receiverType)
				} else return null // TODO Should we raise an exception better?
				
			}
			SymbolReferenceTerm: {
				if (t.symbol instanceof ConstrainedType) {
					// Reference to a literal
					return createBasicType(t.symbol as ConstrainedType)
				} else if (t.symbol.eContainer instanceof ConstrainedType && 
					(t.symbol.eContainer as ConstrainedType).literals.contains(t.symbol)
				) { // Accessing specific literal
					return createBasicType(t.symbol.eContainer as ConstrainedType)
				} else {
					// Reference to a symbol
					return getSymbolReferenceType(t, context)
//					var term_type = getType(t.symbol as SymbolDeclaration,context);
//					if (term_type.domain !== null) {
//						if (t.tail !== null) {
//							return term_type.range
//						} else {
//							return term_type
//						}
//					}
//					if (t.arrayAccess) {
//						term_type = getArrayAccessType(term_type, t)
//					}
//					return term_type;
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
			TruthValue: {
				return Bool;
			}
			LambdaExpression: {
				return t.definition.termExpressionType(context)
			}
			TupleConstructor: {
				return ImlFactory.eINSTANCE.createTupleType => [
					symbols.addAll(t.elements.map[
						val ts = ImlFactory.eINSTANCE.createSymbolDeclaration;  
						ts.type = it.termExpressionType(context)
						ts
					]);
				]
			}
			Program: {
				return t.relations.last.termExpressionType(context)
			}
			default: {
				return Null
			}
		}
	}
	
	def static getSymbolReferenceType(SymbolReferenceTerm term, SimpleTypeReference context) {
		// If symbol reference is inside a type constructor
		val typeConstructor = getTypeConstructorType(term)
		var HigherOrderType term_type = null;
		if (typeConstructor !== null) {
			// TODO we try to get the type in context of the declared type
			term_type = getType(term.symbol as SymbolDeclaration, ImlFactory.eINSTANCE.createSimpleTypeReference => [ref = typeConstructor])
		}
		
		if (term_type === null) { // Get the type from normal container context
			term_type = getType(term.symbol as SymbolDeclaration, context);
		}
		
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
		type.dimension.remove(type.dimension.size - 1)
		if (type.dimension.isEmpty) {
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
				val indexValue = indexAtomic.value * (if (indexAtomic.neg) -1 else 1)
				if (indexValue >= 0 && indexValue < type.symbols.size) {
					return type.symbols.get(indexValue).type
				}
			}
		}
		return type
	}
	
	def static HigherOrderType getType(SymbolDeclaration s, SimpleTypeReference ctx) {
		if ( ctx.ref.symbols.contains(s) || symbolInsideLambda(s) || 
			symbolInsideProgram(s)
		) {
			return bind(s,ctx)
		}
		
		for(rel : ctx.ref.relations) {
			switch(rel){
				com.utc.utrc.hermes.iml.iml.Extension :{
					val target = rel.target
					if (target instanceof SimpleTypeReference) {
						var sup = bind(target,ctx) as SimpleTypeReference
						var retval = getType(s,sup);
						if (retval !== null) {
							return retval;
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
		return symbol.eContainer instanceof Program
	}
	
	/**
	 * Check if symbol declaration is defined inside a lambda signature
	 */
	def static symbolInsideLambda(SymbolDeclaration symbol) {
		return symbol.eContainer instanceof TupleType && 
			symbol.eContainer.eContainer instanceof LambdaExpression &&
			(symbol.eContainer.eContainer as LambdaExpression).signature == symbol.eContainer
	}
	
	def static getTypeConstructorType(TermExpression term) {
		val tupleParent = EcoreUtil2.getContainerOfType(term, TupleConstructor)
		if (tupleParent !== null) {
			val srt = EcoreUtil2.getContainerOfType(tupleParent, SymbolReferenceTerm)
			if (srt !== null && srt.symbol instanceof ConstrainedType) {
				return srt.symbol as ConstrainedType
			}
		}
	}
	
	def static bind(SymbolDeclaration s, SimpleTypeReference ctx) {
		return bind(s.type,ctx)
	}
	
	def static bind(HigherOrderType t, SimpleTypeReference ctx){
		var ctxbinds = new HashMap<ConstrainedType, HigherOrderType>();
		if (ctx.typeBinding.size == ctx.ref.typeParameter.size) {
			for(i : 0 ..< ctx.ref.typeParameter.size) {
				ctxbinds.put(ctx.ref.typeParameter.get(i),ctx.typeBinding.get(i))
			}
		}
		
		return remap(t,ctxbinds)	
	}
	
	def static HigherOrderType remap(HigherOrderType t, Map<ConstrainedType,HigherOrderType> map){
		switch(t){
			ArrayType:{
				var retval = ImlFactory.eINSTANCE.createArrayType ;
				retval.type = remap(t.type,map)	
				for(d : t.dimension) {
					//TODO : Should we clone the term expressions?
					retval.dimension.add(ImlFactory::eINSTANCE.createNumberLiteral => [value=0] ) ;
				}
				return retval				
			}
			SimpleTypeReference:{
				if (map.containsKey(t.ref)) {
					return map.get(t.ref)					
				}
				var retval = ImlFactory.eINSTANCE.createSimpleTypeReference ;
				retval.ref = t.ref
				for( h : t.typeBinding) {
					if(h instanceof SimpleTypeReference){
						if ((h as SimpleTypeReference).typeBinding.size === 0) {
							if (map.containsKey(h.ref)) {
								retval.typeBinding.add(clone(map.get(h.ref)))
							} else {
								retval.typeBinding.add(clone(h))
							}
						} else {
							retval.typeBinding.add(remap(h,map))
						}
					} else {
						retval.typeBinding.add(remap(h,map))
					} 
				}
				return retval;
			}
			TupleType:{
				var retval = ImlFactory.eINSTANCE.createTupleType ;
				for(s : t.symbols) {
					val ss = ImlFactory.eINSTANCE.createSymbolDeclaration
					ss.name = s.name
					ss.type = remap(s.type, map)
					retval.symbols.add(ss)
				}
				return retval; 
			}
			default:{
				var retval = ImlFactory.eINSTANCE.createHigherOrderType ;
				retval.domain = remap(t.domain,map)
				if (t.range !== null) {
					retval.range = remap(t.range,map)
				}
				return retval ;
			}
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
		if (t == Int.ref || t == Real.ref) {
			return true;
		}
		return false;
	}
	
	def static HigherOrderType ct2hot(ConstrainedType type) {
		return createBasicType(type)
	}
	

}
