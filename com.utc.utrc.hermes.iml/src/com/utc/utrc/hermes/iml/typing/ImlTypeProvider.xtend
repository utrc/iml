package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.AtomicTerm
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.FolFormula
import com.utc.utrc.hermes.iml.iml.HigherOrderType
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.ParenthesizedExpression
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
import java.util.List
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.TupleType
import java.util.AbstractMap.SimpleEntry
import javax.management.openmbean.SimpleType
import com.utc.utrc.hermes.iml.services.ImlGrammarAccess.SimpleTypeReferenceElements
import javax.naming.ldap.ExtendedRequest
import com.utc.utrc.hermes.iml.iml.AtomicExpression

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
			AtomicTerm: {

				if (t.symbol instanceof ConstrainedType) {
					// Reference to a literal
					return createBasicType(t.symbol as ConstrainedType)
				} else {
					// Reference to a symbol
					var term_type = getType(t.symbol as SymbolDeclaration,context);
					if (t instanceof ArrayAccess && term_type instanceof ArrayType) {
						term_type = accessArray(term_type as ArrayType, (t as ArrayAccess).index.size)
					}
					return term_type;
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
			ParenthesizedExpression: {
				return termExpressionType(t.subformula, context)
			}
			// If it is a parenthesized expression
			// then recourse.
			default: {
				return Null
			}
		}

	}
	
	
	def static HigherOrderType getType(SymbolDeclaration s, SimpleTypeReference ctx) {
		if ( ctx.ref.symbols.contains(s)) {
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
	
	def static bind(SymbolDeclaration s, SimpleTypeReference ctx) {
		return bind(s.type,ctx)
	}
	
	def static bind(HigherOrderType t, SimpleTypeReference ctx){
		
		var ctxbinds = new HashMap<ConstrainedType, HigherOrderType>();
		
		for(i : 0 ..< ctx.ref.typeParameter.size) {
			ctxbinds.put(ctx.ref.typeParameter.get(i),ctx.typeBinding.get(i))
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
				for(h : t.types) {
					retval.types.add(remap(h,map))
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
		
		if (t == (Int.domain as SimpleTypeReference).ref || t == (Real.domain as SimpleTypeReference).ref) {
			return true;
		}
		return false;
	}
	
	def static HigherOrderType ct2hot(ConstrainedType type) {
		return createBasicType(type)
	}
	

}
