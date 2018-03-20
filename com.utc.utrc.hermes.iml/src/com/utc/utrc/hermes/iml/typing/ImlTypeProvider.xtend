package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.iml.TermExpression
import java.util.List
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import org.eclipse.emf.ecore.EObject
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.NumberLiteral
import com.utc.utrc.hermes.iml.iml.FloatNumberLiteral
import com.utc.utrc.hermes.iml.iml.SymbolRef
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
import com.utc.utrc.hermes.iml.iml.Ite
import com.utc.utrc.hermes.iml.iml.FolFormula
import java.util.Map
import com.utc.utrc.hermes.iml.iml.Symbol
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.HigherOrderType

import static extension com.utc.utrc.hermes.iml.typing.TypingServices.*
import javax.swing.text.Highlighter

public class ImlTypeProvider {
	
	public static val Any = createBasicType('Any')

	public static val Int = createBasicType('Int')
	
	public static val Null = createBasicType('Null')
	
	public static val Real = createBasicType('Real')
	
	public static val Bool = createBasicType('Bool')


	def static HigherOrderType termExpressionType(FolFormula t, HigherOrderType context) {

		if (t.symbol !== null || t.neg || t instanceof AtomicExpression) {
			return Bool ;
		}
		if (t instanceof TermExpression) {
			return termExpressionType((t as TermExpression), context)
		}
		return t.left.termExpressionType(context)
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
				} else if (t.left.termExpressionType(context).isEqual(Int) ||
					t.right.termExpressionType(context).isEqual(Int)) {
					return Int
				} else {
					return Int
				}
			}
			// For reminder and modulo, the result is integer
			// For multiplication and division, the result is numeric
			// Multiplication of integers is an integer, otherwise the result
			// is a real number.
			Multiplication: {

				if (t.sign == '%' || t.sign == 'mod') {
					return integerTypeRef;
				}

				// note that in csl grammar, multiplication includes both "x" and "/".
				if (t.left.termExpressionType(context).isEqual(realTypeRef) ||
					t.right.termExpressionType(context).isEqual(realTypeRef)) {
					return realTypeRef
				} else if (t.left.termExpressionType(context).isEqual(integerTypeRef) ||
					t.right.termExpressionType(context).isEqual(integerTypeRef)) {
					if (t.sign == '*' || t.sign == '/') {
						return integerTypeRef
					} else {
						// TOREFINE: constant
						return realTypeRef
					}
				} else {
					if (t.sign == '*') {
						return integerTypeRef
					} else {
						// TOREFINE: constant
						return realTypeRef
					}
				}
			}
			// Compute the actual type reference which 
			// depends on the types of the change of member selections
			TermMemberSelection: {
				return getTypeRef(t, context)
			}
			SymbolRef: {

				if (t.ref instanceof NamedFormula ||
					( t.ref instanceof FunctionDefinition && ! (t.ref as FunctionDefinition).ret)) {
					return boolTypeRef
				} else if (t.ref instanceof TermSymbol) {
					var tref = t.ref as TermSymbol

					var ret = ImlFactory.eINSTANCE.createTypeReference;
					// ret.stereotypes.addAll(t.symbol.type.stereotypes);
					ret.type = tref.type.type;
					for (TypeReference tr : tref.type.typeBinding) {
						ret.typeBinding.add(tr.cloneTypeReference);
					}
					var accesslength = 0;
					if (t.index != null) {
						accesslength = t.index.length;
					}
					var typedimension = 0;
					if (tref.type.dimension != null) {
						typedimension = tref.type.dimension.length;
					}
					if (accesslength < typedimension) {
						ret.array = true;
					}
					for (i : accesslength ..< typedimension) {
						ret.dimension.add(tref.type.dimension.get(i).cloneTermExpression)
					}
					return bindTypeRefWith(ret, context);
				} else {
					return nullTypeRef
				}
			}
			// The type is the type associated with the 
			// constant of the enum.
			EnumRef: {
				return ct2tr(t.constant.type)
			}
			// Compute the type of the static reference
//			StaticRef: {
//				return termExpressionType(t.ref.element)
//			}
			// A number literal is always an integer
			NumberLiteral: {
				return integerTypeRef;

			}
			FloatNumberLiteral: {
				return realTypeRef;

			}
			// TODO : handle aggregate expression
			Aggregate: {
				return realTypeRef
			}
			Ite: {
				return termExpressionType(t.ite, context)
			}
			IteTermExpression: {
				return termExpressionType(t.left, context)
			}
			// If it is a parenthesized expression
			// then recourse.
			default:
				if (t.subformula !== null) {
					return t.subformula.termExpressionType(context)
				} else if (t.TRUE !== null || t.FALSE !== null) {
					return boolTypeRef
				} else {
					return nullTypeRef
				}
		}

	}

	def static TypeReference getTypeRef(TermMemberSelection tms, TypeReference context) {
		// For a term member selection t1::...::tn
		// this first part computes a ordered list of terms as follows:
		// t1, t1::t2,...., t1::...::tn-1
		var List<TermExpression> telist = new ArrayList<TermExpression>();
		var TermExpression te = tms.receiver;
		while (!(  (te instanceof SymbolRef) || (te instanceof This) || (te instanceof IteTermExpression) ||
			(te.subformula !== null) )) {
			telist.add(0, te);
			te = (te as TermMemberSelection).receiver;
		}
		// This list needs to be processed 
		// to incrementally determine the type
		// of all sub-term-expressions
		telist.add(0, te);

		// We can now process the list
		var TypeReference tre = context;
		for (TermExpression e : telist) {
			// Compute the type reference of e 
			// in the context of tre
			tre = getTypeReference(tre, e);
		}
		// compute the type reference of the 
		// entire tms in the context of tre
		return getTypeReference(tre, tms);
	}

	// Given a context type reference, compute the type of the term expression tms
	// For example, for a term member selection t1::...::tn, we could 
	// ask to compute the type of t1::...::tk in the context t1::....::tk-1
	def static TypeReference getTypeReference(TypeReference ctx, TermExpression tms) {
		switch (tms) {
			// If the term member selection is a symbol reference
			// then we are at the beginning of a list and we should know the type
			SymbolRef: {
				if (tms.ref instanceof NamedFormula) {
					return boolTypeRef
				}
				var tmsref = tms.ref as TermSymbol
				var TypeReference retval = ImlFactory.eINSTANCE.createTypeReference;
				retval.type = tmsref.type.type
				// retval.stereotypes.addAll(tms.symbol.type.stereotypes)
				for (TypeReference tr : tmsref.type.typeBinding) {
					retval.typeBinding.add(tr.cloneTypeReference)
				}
				// Take care of arrays
				if (tms.isArrayindex) {
					retval.array = true
					// discount the array accesses
					for (i : tms.index.length ..< tmsref.type.dimension.length) {
						retval.dimension.add(tmsref.type.dimension.get(i).cloneTermExpression)
					}
				}
				return bindTypeRefWith(retval, ctx);
			}
			This: {
				var TypeReference retval = ImlFactory.eINSTANCE.createTypeReference;
				val theType = tms.getContainerOfType(typeof(ConstrainedType))
				retval.type = theType
				// retval.stereotypes.addAll(theType.stereotypes)
				return retval;
			}
			// For term member selections,
			// get the name of the member and look for the symbol 
			// in the type hierarchy. Take the type reference of that 
			// symbol and bind it with all the actual typing information 
			// of the context
			TermMemberSelection: {
				// get the last token which is the name of the member
				// To get the last, navigate through the chain
				var currenttms = tms;
				while (currenttms.member instanceof TermMemberSelection) {
					currenttms = currenttms.member as TermMemberSelection;
				}
				val ICompositeNode n = NodeModelUtils.findActualNodeFor(tms);
				var ntext = n.text.replaceAll("\\s+", "") // remove all the whitespaces
				val String re = "\\([^()]*\\)"; // regular expression for unnested brackets
				val Pattern p = Pattern.compile(re);
				var Matcher m = p.matcher(ntext);
				while (m.find()) { // repeat till no brackets remain
					ntext = m.replaceAll(""); // remove i-th level of unnested brackets
					m = p.matcher(ntext);
				}
				val tokens = ntext.split("\\->");
				var membername = tokens.last;
				membername = membername.split('\\(').get(0);
				val member = findSymbol(ctx, membername)
//				if (member == null)
//					return nullTypeRef
				// Bind the type reference with the actual 
				// type of the context
				// member.type.bindTypeRefWith(ctx)
				// Added for arrays
				val tr = tms.member.type.bindTypeRefWith(ctx);
				var retval = tr.cloneTypeReference
				// Take care of arrays
				var startindex = 0
				if (tms.isArrayindex) {
					startindex = tms.index.length
				}
				if (tms.member.type.array) {
					// discount the array accesses
					for (i : startindex ..< tms.member.type.dimension.length) {
						retval.array = true;
						retval.dimension.add(tms.member.type.dimension.get(i).cloneTermExpression)
					}
				}
				return retval;
			// /
			// return tms.member.type.bindTypeRefWith(ctx);
			}
			default: {
				return nullTypeRef
			}
		}
	}

	// Given a type reference and name of a symbol
	// get all the attributes of the context type (navigating through the 
	// extension hierarchy) and try to find the symbol. If the symbol
	// is not found, then return null.
	def static TermSymbol findSymbol(TypeReference ctx, String name) {
		var List<TermSymbol> symbols = ctx.allAttributes;
		for (TermSymbol s : symbols) {
			if (s.name.equals(name)) {
				return s;
			}
		}
		return null;
	}

	// This function creates a map that resolves all template bindings
	// The map is created by navigating the type hierarchy. Each template
	// parameter is then bound to a concrete type.
	def static HigherOrderType bindTypeRefWith(HigherOrderType t, HigherOrderType ctx) {
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
	}

	// Given a type reference and a map from type parameters to actual 
	// types, compute the actual type reference
	def public static TypeReference bindTypeRefWith(TypeReference t, Map<ConstrainedType, TypeReference> map) {
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
	}

	def static getAllAttributes(TypeReference ctx) {
		var List<TermSymbol> tlist = <TermSymbol>newArrayList()
		var List<List<TypeReference>> hierarchy = ctx.allSuperTypesReferences;
		for (level : hierarchy) {
			for (st : level) {
//				for (Element e : st.type.elements) {
//					if (e instanceof TermSymbol) {
//						tlist.add(e);
//					}
//				}
			}
		}
		return tlist;
	}

	def static getAllElements(TypeReference ctx) {
		var List<Element> tlist = <Element>newArrayList()
		var List<List<TypeReference>> hierarchy = ctx.allSuperTypesReferences;
		for (level : hierarchy) {
			for (st : level) {
//				for (Element e : st.type.elements) {
//
//					tlist.add(e);
//
//				}
			}
		}
		return tlist;
	}

	/* Compute all super types of a ContrainedType  */
	def static getAllSuperTypes(ConstrainedType ct) {
		val closed = <ConstrainedType>newArrayList()
		val retVal = new ArrayList<List<ConstrainedType>>()
		retVal.add(new ArrayList<ConstrainedType>());
		retVal.get(0).add(ct); // A type is a super type of itself
		var index = 0;
		while (retVal.get(index).size() > 0) {
			val toAdd = <ConstrainedType>newArrayList();
			for (current : retVal.get(index)) {
//				for (sup : current.superType) {
//					if (!closed.contains(sup.type)) {
//						toAdd.add(sup.type)
//					}
//				}
				closed.add(current)
			}
			if (toAdd.size() > 0) {
				retVal.add(toAdd)
				index = index + 1
			} else {
				return retVal;
			}
		}
		return retVal
	}

	def static getAllSuperTypesReferences(ConstrainedType t) {
		var TypeReference virtualtf = ImlFactory.eINSTANCE.createTypeReference;
		virtualtf.type = t;
		return getAllSuperTypesReferences(virtualtf);

	}

	/* Compute all super type references of a TypeReference */
	def static getAllSuperTypesReferences(TypeReference tf) {
		val closed = <TypeReference>newArrayList()
		val retVal = new ArrayList<List<TypeReference>>()
		retVal.add(new ArrayList<TypeReference>());
		retVal.get(0).add(tf); // A type is a super type of itself
		var index = 0;
		while (retVal.get(index).size() > 0) {
			val toAdd = <TypeReference>newArrayList();
			for (current : retVal.get(index)) {
//				for (sup : current.type.superType) {
//					if (!closed.contains(sup)) {
//						toAdd.add(sup)
//					}
//				}
				closed.add(current)
			}
			if (toAdd.size() > 0) {
				retVal.add(toAdd)
				index = index + 1
			} else {
				return retVal;
			}
		}
		return retVal
	}


	
	/* Check whether actual paramemter's type is compatible with formal/signature parameter's type.
	 * If the flag checkStereotypes is true, then also compare stereotypes. 
	 * */
	def static boolean isCompatible(TypeReference actual, TypeReference sig, boolean checkStereotypes) {
		if (actual.array || sig.array) {
			if (actual.dimension.size != sig.dimension.size) {
				return false;
			}

		}
		if (sig.type.name == 'Any')
			return true
		if (sig.numeric && actual.numeric) {
			if ((sig.type.name == 'Real') || (sig.type.name == 'Int' && actual.type.name != 'Real'))
				return true
			else
				return false
		}
		if (sig.isEqual(actual))
			return true
		// if (checkStereotypes && ! actual.stereotypes.containsAll(sig.stereotypes))
		// return false
		if (! sig.type.isSuperType(actual.type))
			return false;

		var str = sig.allSuperTypesReferences;
		for (level : str) {
			for (tr : level) {
				if (tr.type == actual.type) {
					var TypeReference bounded = tr.bindTypeRefWith(sig)
					if (bounded.typeBinding.size != actual.typeBinding.size) {
						return false;
					}
					for (i : 0 ..< bounded.typeBinding.size) {
						if (! bounded.typeBinding.get(i).isEqual(actual.typeBinding.get(i))) {
							return false;
						}
					}
				}
			}
		}
		return true;
	}

	def static boolean isSuperType(TypeReference t, TypeReference sub, boolean checkStereotypes) {
		var str = sub.allSuperTypesReferences;
		for (level : str) {
			for (tr : level) {
				if (tr.type == t.type) {
					var TypeReference bounded = tr.bindTypeRefWith(sub)
					if (bounded.typeBinding.size == t.typeBinding.size) {
						var found = true;
						for (i : 0 ..< bounded.typeBinding.size) {
							if (! bounded.typeBinding.get(i).isEqual(t.typeBinding.get(i))) {
								found = false;
							}
						}
						if (found) {
							return true;
						}
					}
				}
			}
		}
		return false;
	}

	/* Check whether one ConstrainedType is a super type of the other */
	def static boolean isSuperType(ConstrainedType t, ConstrainedType sub) {

		if (t.name == 'Any')
			return true;
		if (t == sub)
			return true;

		val closed = <ConstrainedType>newArrayList()
		val retval = new ArrayList<List<ConstrainedType>>()
		retval.add(new ArrayList<ConstrainedType>());
		retval.get(0).add(sub);
		var index = 0;
		while (retval.get(index).size() > 0) {
			val toadd = <ConstrainedType>newArrayList();
			for (current : retval.get(index)) {
//				for (sup : current.superType) {
//					if (!closed.contains(sup.type)) {
//						if (sup.type.isEqual(t)) {
//							return true;
//						}
//						toadd.add(sup.type)
//					}
//				}
				closed.add(current)
			}
			if (toadd.size() > 0) {
				retval.add(toadd)
				index = index + 1
			} else {
				return false;
			}
		}
		return false
	}

	/* A non-template type without stereotype is a pure type */
	def static boolean isPureType(TypeReference t) {
		return ( /*t.stereotypes.size() == 0 &&*/ t.typeBinding.size() == 0)
	}

	/* Check whether t is primitive type */
	def static boolean isPrimitive(TypeReference t) {
		return ( t == nullTypeRef || t == integerTypeRef || t == realTypeRef || t == boolTypeRef || t == anyTypeRef)
	}

	/* Check whether t is numeric type reference */
	def static boolean isNumeric(TypeReference t) {
		if (t.dimension.size() > 0) {
			return false;
		}
		if (t == integerTypeRef || t == realTypeRef || t.type.name == 'Real' || t.type.name == 'Int') {
			return true;
		}
//		for (st : t.type.superType) {
//			if (st.isNumeric) {
//				return true;
//			}
//		}
		return false;
	}

	/* Check whether t is numeric type */
	def static boolean isNumeric(ConstrainedType t) {
		if (t == integerTypeRef || t == realTypeRef || t.name == 'Real' || t.name == 'Int') {
			return true;
		}
//		for (st : t.superType) {
//			if (st.isNumeric) {
//				return true;
//			}
//		}
		return false;
	}

	/* Check whether t is a template parameter  */
	def static boolean isTemplateParameter(TypeReference t) {
		if (t === null || t.type === null) {
			return false;
		}
		if (t.type.eContainer === null) {
			return false
		} else if (!(t.type.eContainer instanceof Model)) {
			// We do not allow nested types
			return true
		}
		return false
	}

	/* Check whether a constrained type is a template  */
	def static boolean isTemplate(ConstrainedType ct) {
		return ct.template;
	}

	/* compute what type t is used to bind a term which is declared in parametric constrainedtype container and is being used in instantiated constrainedtype c */
	def static TypeReference getBindingContainerType(ConstrainedType container, ConstrainedType c) {
		var supertypes = getAllSuperTypesReferences(c)
		for (level : supertypes.reverseView) {
			for (st : level) {
				if (st.type == container) {
					return st
				}
			}
		}
		return nullTypeRef;
	}

	def static TypeReference getBindingContainerType(ConstrainedType container, TypeReference t) {
		var supertypes = getAllSuperTypesReferences(t)
		for (level : supertypes.reverseView) {
			for (st : level) {
				if (st.type == container) {
					return st
				}
			}
		}
		return nullTypeRef;
	}

	def static TypeReference getBindingContainerTypeRef(ConstrainedType container, TypeReference t) {
		var supertypes = getAllSuperTypesReferences(t)
		for (level : supertypes.reverseView) {
			for (st : level) {
				if (st.type == container) {
					val boundedt = bindTypeRefWith(st, t)
					return boundedt
				}
			}
		}
		return nullTypeRef;
	}

	def static TypeReference ct2tr(ConstrainedType c) {
		var ret = ImlFactory.eINSTANCE.createTypeReference
		ret.type = c
		return ret
	}

	def static TypeReference cloneTypeReference(TypeReference tr) {
		var ret = ImlFactory.eINSTANCE.createTypeReference;
		// ret.stereotypes.addAll(tr.stereotypes);
		ret.type = tr.type;
		for (TypeReference t : tr.typeBinding) {
			ret.typeBinding.add(t.cloneTypeReference);
		}
		for (TermExpression te : tr.dimension) {
			ret.dimension.add(te.cloneTermExpression)
		}
		return ret;
	}

	def static TypeReference selectTypeRef(TypeReference tr) {
		var ret = ImlFactory.eINSTANCE.createTypeReference;
		// ret.stereotypes.addAll(tr.stereotypes);
		ret.type = tr.type;
		for (TypeReference t : tr.typeBinding) {
			ret.typeBinding.add(t.cloneTypeReference);
		}
		for (i : 0 ..< tr.dimension.size - 1) {
			ret.array = true;
			ret.dimension.add(tr.dimension.get(i).cloneTermExpression)
		}
		return ret;
	}

	// TODO This cloning function should be revisited
	def static TermExpression cloneTermExpression(TermExpression te) {
		switch (te) {
			SymbolRef: {
				var ret = ImlFactory.eINSTANCE.createSymbolRef
				ret.symbol = te.symbol
				return ret
			}
			NumberLiteral: {
				var ret = ImlFactory.eINSTANCE.createNumberLiteral
				ret.value = te.value
				return ret
			}
			FloatNumberLiteral: {
				var ret = ImlFactory.eINSTANCE.createFloatNumberLiteral
				ret.value = te.value
				return ret
			}
			TermMemberSelection: {
				var ret = ImlFactory.eINSTANCE.createTermMemberSelection
				ret.receiver = te.receiver.cloneTermExpression
				ret.member = te.member
				return ret
			}
			default:
				null
		}
	}

	def static boolean isTermExpressionLiteralPosInt(TermExpression te) {
		switch (te) {
			NumberLiteral: {
				return !te.neg
			}
			default:
				return false
		}
	}

	def static boolean isTermExpressionLiteralPosNum(TermExpression te) {
		switch (te) {
			NumberLiteral: {
				return !te.neg
			}
			FloatNumberLiteral: {
				return !te.neg
			}
			default:
				return false
		}
	}

	/* Print information of a type reference */
	def static String printTypeReference(TypeReference t) {
		var String s = ''
//		for (st : t.stereotypes) {
//			s = s + st.name + ' '
//		}
		s = s + t.type.name
		if (t.typeBinding.size() > 0) {
			s += '< '
			for (i : 0 ..< t.typeBinding.size()) {
				s += t.typeBinding.get(i).printTypeReference + ' '
			}
			s += '>'
		}
		for (i : t.dimension) {
			s += '[';
			switch (i) {
				NumberLiteral: s += i.value
			}
			s += ']';
		}
		return s
	}

	def static qualifiedName(Symbol elem) {
		var EObject e = elem.eContainer;
		var StringBuffer s = new StringBuffer()
		s.append(elem.name);
		while (e !== null) {
			if (e instanceof Model) {
				s.insert(0, e.name.replace('.', '::') + '::');
			} else if (e instanceof ConstrainedType) {
				s.insert(0, e.name + '::');
			}
			e = e.eContainer;
		}
		return s.toString
	}

	def static isExtension(ConstrainedType t, String qname) {
		if (qualifiedName(t).equals(qname)) {
			return true;
		}
		var extensions = getAllSuperTypes(t);
		for (l : extensions) {
			for (sup : l) {
				if (sup.qualifiedName.equals(qname)) {
					return true;
				}
			}
		}
		return false;
	}

}
