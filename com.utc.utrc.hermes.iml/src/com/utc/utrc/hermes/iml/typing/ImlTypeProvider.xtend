package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.TermExpression
import java.util.List
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import java.util.ArrayList
import java.util.HashMap
import org.eclipse.xtext.nodemodel.ICompositeNode
import org.eclipse.xtext.nodemodel.util.NodeModelUtils
import java.util.regex.Pattern
import java.util.regex.Matcher
import com.utc.utrc.hermes.iml.iml.This
import static extension org.eclipse.xtext.EcoreUtil2.*
import com.utc.utrc.hermes.iml.iml.IteTermExpression
import com.utc.utrc.hermes.iml.iml.Addition
import com.utc.utrc.hermes.iml.iml.Multiplication
import com.utc.utrc.hermes.iml.iml.FolFormula
import java.util.Map
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.HigherOrderType

import static extension com.utc.utrc.hermes.iml.typing.TypingServices.*
import com.utc.utrc.hermes.iml.iml.TruthValue
import com.utc.utrc.hermes.iml.iml.ParenthesizedExpression
import com.utc.utrc.hermes.iml.iml.AtomicTerm
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference

public class ImlTypeProvider {

	public static val Any = createBasicType('Any')

	public static val Int = createBasicType('Int')

	public static val Null = createBasicType('Null')

	public static val Real = createBasicType('Real')

	public static val Bool = createBasicType('Bool')

	def static HigherOrderType termExpressionType(FolFormula t, HigherOrderType context) {
		if (t instanceof TermExpression) {
			return termExpressionType((t as TermExpression), context)
		}
		return Bool;
	}

	/* Compute the type of a TermExpression 
	 * This is the most important function in the type provider. 
	 * Given a term expression, this function returns a type reference
	 * that contains stereotypes, type and type binding information
	 * for the term. 
	 * */
	def static HigherOrderType termExpressionType(TermExpression t, HigherOrderType context) {

		switch (t) {
			// If the expression is "this", then its type is the 
			// type of the container type.
			This: {
				return bindTypeRefWith(createBasicType(t.getContainerOfType(ConstrainedType)), context)
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
				return termExpressionType(t.member, termExpressionType(t.receiver,context))
			}
			AtomicTerm: {

				if (t.symbol instanceof ConstrainedType) {
					// Reference to a literal
					return createBasicType(t.symbol as ConstrainedType)
				} else {
					// Reference to a symbol
					var term_type = (t.symbol as SymbolDeclaration).type.bindTypeRefWith(context);
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

	
	// This function creates a map that resolves all template bindings
	// The map is created by navigating the type hierarchy. Each template
	// parameter is then bound to a concrete type.
	def static HigherOrderType bindTypeRefWith(HigherOrderType t, HigherOrderType ctx) {
		return clone(t)
		/* 
		if(ctx === null) return t;
		var map = new HashMap<ConstrainedType, TypeReference>();
		var List<List<TypeReference>> hierarchy = ctx.allSuperTypesReferences;
		for (level : hierarchy) {
			for (st : level) {
				// This is a supertype of the context
				if (st.type.typeParameter.size != st.typeBinding.size)
					return nullTypeRef;
				// go over all template binding information
				for (i : 0 ..< st.typeBinding.size) {
					var TypeReference tr = null;
					if (map.containsKey(st.typeBinding.get(i).type)) {
						tr = map.get(st.typeBinding.get(i).type);
					} else {
						tr = st.typeBinding.get(i).cloneTypeReference
					}

//					// If the type bound to a parameter is a template type
//					// the its actual type must be already in the map
//					if(st.typeBinding.get(i).isTemplateParameter) {
//						tr = map.get(st.typeBinding.get(i).type)
//					} else {
//						// otherwise it is a concrete type and we just
//						// clone the type reference
//						tr = st.typeBinding.get(i).cloneTypeReference
//					}
					map.put(st.type.typeParameter.get(i), tr.bindTypeRefWith(map))
				}
			}
		}
		// At this point we have a map from template parameters for the context
		// Now just bind the type reference using the map 
		var c = bindTypeRefWith(t, map);
		return c
		
		*/
	}

	// Given a type reference and a map from type parameters to actual 
	// types, compute the actual type reference
	def public static HigherOrderType bindTypeRefWith(HigherOrderType t, Map<ConstrainedType, HigherOrderType> map) {
		return clone(t)
		/*
		if (t === null) {
			return nullTypeRef;
		}
		if (t.isTemplateParameter) {
			val tr = map.get(t.type);
			if (tr !== null) {
				return tr;
			} else {
				return t;
			}
		} else {
			var retval = ImlFactory.eINSTANCE.createTypeReference;
			retval.type = t.type;
			// retval.stereotypes.addAll(t.stereotypes)
			for (i : 0 ..< t.typeBinding.size()) {
				retval.typeBinding.add(t.typeBinding.get(i).bindTypeRefWith(map))
			}
			retval.array = t.array;
			for (TermExpression te : t.dimension) {

				retval.dimension.add(te.cloneTermExpression)
			}
			return retval;
		}
		
		*/
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
	

	

}
