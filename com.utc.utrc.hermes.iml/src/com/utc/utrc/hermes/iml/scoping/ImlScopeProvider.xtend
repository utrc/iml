/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml.scoping

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTail
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.naming.IQualifiedNameProvider
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.scoping.impl.FilteringScope

import static extension com.utc.utrc.hermes.iml.typing.ImlTypeProvider.*
import static extension com.utc.utrc.hermes.iml.typing.TypingServices.*
import static extension org.eclipse.xtext.EcoreUtil2.*
import com.utc.utrc.hermes.iml.iml.InstanceConstructor
import com.utc.utrc.hermes.iml.iml.EnumRestriction
import com.utc.utrc.hermes.iml.iml.TermExpression
import java.util.Arrays
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula
import com.utc.utrc.hermes.iml.iml.ImplicitInstanceConstructor

/**
 * This class contains custom scoping description.
 * 
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#scoping
 * on how and when to use it.
 * 
 * @author Alessandro Pinto
 * @author Ayman Elkfrawy
 * 
 */
class ImlScopeProvider extends AbstractDeclarativeScopeProvider {

	@Inject extension IQualifiedNameProvider

	@Inject
	private IQualifiedNameConverter qualifiedNameConverter;

	override getScope(EObject context, EReference reference) {
		super.getScope(context, reference)
	}

	def boolean isImported(IEObjectDescription iod, Model context) {
		var qn = iod.qualifiedName
		var mqn = qualifiedNameConverter.toQualifiedName(context.name)
		if (qn.startsWith(mqn) && ! iod.name.startsWith(mqn)) {
			return true;
		}
		for (imp : context.imports) {
			var iqn = qualifiedNameConverter.toQualifiedName(imp.importedNamespace)
			var hasW = false;
			if (iqn.lastSegment.equals('*')) {
				hasW = true;
			}
			if (hasW) {
				iqn = iqn.skipLast(1);
				if (qn.startsWith(iqn)) {
					return true;
				}
			} else {
				if (qn.equals(iqn)) {
					return true;
				}
			}
		}

		return false;
	}

	def boolean shareSameContainer(EObject o1, EObject o2) {
		if (o1 === null)
			return false
		var containersOfO1 = new HashSet<EObject>()
		var cont = o1.eContainer
		while (cont !== null) {
			containersOfO1.add(cont)
			cont = cont.eContainer
		}
		var containersOfO2 = new HashSet<EObject>()
		cont = o2
		while (cont !== null) {
			containersOfO2.add(cont)
			cont = cont.eContainer
		}

		containersOfO1.retainAll(containersOfO2)
		return !containersOfO1.empty
	}

	// def IScope getGlobalScope (TypeReference context, EReference r) {
	def IScope getGlobalScope(EObject context, EReference r) {
		// val delegateScope = delegateGetScope(context, r)
		var global = delegateGetScope(context, r)

		val (IEObjectDescription)=>boolean filter = [ieod|ieod.isImported(context.getContainerOfType(typeof(Model)))]

		global = new FilteringScope(global, filter);

	// val (IEObjectDescription)=>boolean filter = [ieod|!shareSameContainer(ieod.EObjectOrProxy, context.eContainer)]
//		val (IEObjectDescription)=>boolean filter = [ ieod |
//			!ieod.EObjectURI.toString.startsWith(context.eResource.URI.toString)
//		]
//		val global = new FilteringScope(delegateScope, filter)
//		global
	// delegateScope	
	}

	def scope_SymbolReferenceTerm_symbol(SymbolReferenceTerm context, EReference r) {
		val container = context.eContainer
		if (container instanceof TermMemberSelection) {
			// We are in a term selection and we have parsed the member already
			// We are in the situation "ID.", thus we need to find the symbols in the
			// scope of the ID 
			if (container.member === context) {
				return scope_SymbolReferenceTerm_symbol(container, r)
			} else {
				val retval = buildNestedScope(context)
				return retval
			}
		} else if (container instanceof SignedAtomicFormula && container.eContainer instanceof ArrayAccess) {
			// Scope provider for Tuple array access
			val tupleScope = getScopeOfTupleAccess(container.eContainer as ArrayAccess)
			if (tupleScope !== null) {
				return tupleScope;
			}
		} else {
			return buildNestedScope(context)
		}

		var scope = getGlobalScope(context, r)

		val typeConstructor = getTypeConstructorType(context)
		if (typeConstructor !== null) { // Include type symbols inside a type constructor term
			scope = scopeOfConstrainedType(typeConstructor, scope)
		}

		if (context.getContainerOfType(ConstrainedType) === null) {
			return scope;
		}

		return scopeOfConstrainedType(context.getContainerOfType(ConstrainedType), scope)
	}

	protected def scopeOfConstrainedType(ConstrainedType type, IScope scope) {
		val superTypes = type.allSuperTypes
		var features = new HashSet
		for (level : superTypes.reverseView) {
			for (t : level) {
				features.addAll(t.symbols)
			}
		}
		return Scopes::scopeFor(features, scope)
	}

	def getScopeOfTupleAccess(ArrayAccess arrayAccess) {
		val symbolRef = arrayAccess.eContainer as SymbolReferenceTerm
		if (symbolRef.symbol instanceof SymbolDeclaration) {
			var type = getTypeWithoutTail(symbolRef)
			var break = false;
			for (SymbolReferenceTail tail : symbolRef.tails) {
				if (!break) {
					if (tail === arrayAccess) {
						if (type instanceof TupleType) {
							return Scopes::scopeFor(type.symbols);
						} else { // It is just normal array access not tuple
							break = true;
						}
					} else {
						type = ImlTypeProvider.accessTail(type, tail)
					}
				}
			}
		}
	}

	def getTypeWithoutTail(SymbolReferenceTerm term) {
// 		To Handle template type access
//		TODO : the problem here is we can't get the scope of in-memory symbols created by bind function
		if (term.eContainer instanceof TermMemberSelection &&
			(term.eContainer as TermMemberSelection).member === term) {
			val tms = term.eContainer as TermMemberSelection
			val receiverType = termExpressionType(tms.receiver)
			return getType(term, receiverType as SimpleTypeReference)
		} else {
			return (term.symbol as SymbolDeclaration).type
		}
//		return (term.symbol as SymbolDeclaration).type
	}

	def scope_SymbolReferenceTerm_symbol(TermMemberSelection context, EReference r) {
		var parentScope = IScope::NULLSCOPE
		val receiver = context.receiver

		if (receiver instanceof SymbolReferenceTerm) {
			val symb = (receiver as SymbolReferenceTerm).symbol
			if (symb instanceof ConstrainedType) {
				// The receiver is a constrained type
				// This is a reference to an enum
				val ct = (receiver as SymbolReferenceTerm).symbol as ConstrainedType
				if (! ct.restrictions.isEmpty) {
					val res = ct.restrictions.filter(EnumRestriction)
					if (! res.isEmpty) {
						return Scopes::scopeFor(res.get(0).literals);
					}
				}
			}
		}

		var receiverType = receiver.termExpressionType

		if (receiverType === null || receiverType.isPrimitive) {
			return parentScope
		}

		val superTypes = receiverType.allSuperTypes
		for (level : superTypes.reverseView) {
			var features = new HashSet
			for (t : level) {
				if (t instanceof SimpleTypeReference) {
					var theType = t.type;
					switch (theType) {
						ConstrainedType: features.addAll(theType.symbols)
					}
				}
			}
			parentScope = Scopes::scopeFor(features, parentScope)
		}
		return parentScope
	}

	def scope_SymbolReferenceTerm_symbol(ArrayAccess context, EReference r) {
		val tupleScope = getScopeOfTupleAccess(context)
		if (tupleScope !== null) {
			return tupleScope
		} else {
			return getScope(context.eContainer, r)
		}
	}

//	def dispatch computeScope(EObject container, EObject context, IScope scope) {
//		return computeScope(container.eContainer, context, scope)
//	}
//	def dispatch computeScope(InstanceConstructor constructor, EObject context, IScope scope) {
//		var newScope = scopeOfConstrainedType((constructor.ref as SimpleTypeReference).type, scope);
//		return computeScope(constructor.eContainer, context, newScope)
//	}
//	def dispatch computeScope(ConstrainedType type, EObject context, IScope scope) {
//		return scope;
//	}
	def IScope buildNestedScope(EObject o) {
		if (o === null) {
			return IScope::NULLSCOPE
		}
		switch (o) {
			ConstrainedType:
				return scopeOfConstrainedType(o, buildNestedScope(o.eContainer))
			InstanceConstructor:
				return Scopes::scopeFor(Arrays.asList(o.ref), buildNestedScope(o.eContainer))
			ImplicitInstanceConstructor: {
				var parentScope = IScope::NULLSCOPE
				val superTypes = o.ref.allSuperTypes
				for (level : superTypes.reverseView) {
					var features = new HashSet
					for (t : level) {
						if (t instanceof SimpleTypeReference) {
							var theType = t.type;
							switch (theType) {
								ConstrainedType: features.addAll(theType.symbols)
							}
						}
					}
					if (parentScope === IScope::NULLSCOPE)
						parentScope = Scopes::scopeFor(features,buildNestedScope(o.eContainer))
					else 
						parentScope = Scopes::scopeFor(features, parentScope)				
				}
				if (parentScope === IScope::NULLSCOPE)
					return buildNestedScope(o.eContainer)
				else 
					return parentScope
			}
			LambdaExpression:
				if (o.signature instanceof TupleType) {
					return Scopes::scopeFor((o.signature as TupleType).symbols, buildNestedScope(o.eContainer));

				} else
					return buildNestedScope(o.eContainer)
			QuantifiedFormula:
				return Scopes::scopeFor(o.scope, buildNestedScope(o.eContainer))
			Model:
				return Scopes::scopeFor(o.symbols, buildNestedScope(o.eContainer))
			default:
				return buildNestedScope(o.eContainer)
		}
	}

//	def scope_FolFormula(SymbolReferenceTerm context, EReference r) {
//		var parentScope = IScope::NULLSCOPE
//		
//		return parentScope
//	}
//	
//
//	def scope_TypeReference_type(TypeReference context, EReference r) {
//		val global = getGlobalScope(context, r)
//		// val global = delegateGetScope(context, r)
//		context.eContainer.computeScopeTypeRefType(context, global)
//	}
//
//	def scope_TypeReference_type(ConstrainedType context, EReference r) {
//		val global = getGlobalScope(context, r)
//		// val global = delegateGetScope(context, r)
//		context.eContainer.computeScopeTypeRefType(context, global)
//	}
//
//	def scope_TypeReference_stereotype(TypeReference context, EReference r) {
//		val global = getGlobalScope(context, r)
//		// val global = delegateGetScope(context, r)
//		context.eContainer.computeScopeTypeRefType(context, global)
//	}
//
//	// add ContrainedType in container and perform one more step of recursion
//	def dispatch IScope computeScopeTypeRefType(EObject cont, EObject o, IScope global) {
//		cont.eContainer.computeScopeTypeRefType(o.eContainer, global)
//	}
//
//
//	// this ends the recursion
//	def dispatch IScope computeScopeTypeRefType(Model cont, EObject o, IScope global) {
//		//Scopes::scopeFor(cont.elements.filter(typeof(ConstrainedType)), global)
//		global
//	}
//	
//	// add template type parameters if any and recurse to its parent
//	def dispatch IScope computeScopeTypeRefType(VariableDeclaration cont, EObject o, IScope global) {
//		var parentScope = cont.eContainer.computeScopeTypeRefType(cont, global)
//		parentScope
//	}
//
//	// add template type parameters if any and recurse to its parent
//	def dispatch IScope computeScopeTypeRefType(ConstrainedType cont, EObject o, IScope global) {
//		var parentScope = cont.eContainer.computeScopeTypeRefType(cont, global)
//		if (cont.template)
//			parentScope = Scopes::scopeFor(cont.typeParameter, parentScope)
//		Scopes::scopeFor(cont.elements.filter(typeof(ConstrainedType)), parentScope)
//	}
//
//	// notice that second argument is never used in this method
//	def scope_TermSymbol(TermMemberSelection sel, EReference r) {
//		var context = ct2tr(sel.getContainerOfType(ConstrainedType))
//		
//		var parentScope = IScope::NULLSCOPE
//		var typeref = sel.receiver.termExpressionType(context)
//
//		if (typeref.array) {
//			if (typeref.dimension.size > sel.index.size) {
////			var features = new HashSet
////			features.add(arraysize)
////			return Scopes::scopeFor(features, parentScope)
//				return parentScope;
//			}
//		}
//
//		if (typeref === null || typeref.primitive)
//			return parentScope
//		var supertypes = getAllSuperTypesReferences(typeref);
//		for (level : supertypes.reverseView) {
//			var features = new HashSet
//			for (t : level) {
//				var theType = t.type;
//				switch (theType) {
//					ConstrainedType: features.addAll(theType.elements.filter(typeof(TermSymbol)))
//				}
//			}
//			parentScope = Scopes::scopeFor(features, parentScope)
//		}
//		parentScope
//	}
//	
//	
//
//	def scope_SecondOrderTerm_member(SecondOrderTerm context, EReference r) {
//		val global = getGlobalScope(context, r)
//		var features = new HashSet
//		features.add(context.^var)
//		Scopes::scopeFor(features, global)
//	}
//
//	def scope_SymbolRef_ref(FolFormula context, EReference r) {
//		val global = getGlobalScope(context, r);
//		val retval = context.eContainer.computeScope(context, global)
//		return retval 
//	}
//	
//	def scope_PredicateDeclaration(FolFormula context, EReference r) {
//		var parentScope = getGlobalScope(context, r);
//		var container = context.getContainerOfType(typeof(ConstrainedType))
//		var supertypes = getAllSuperTypes(container);
//		for (level : supertypes.reverseView) {
//			var features = new HashSet
//			for (t : level) {
//				features.addAll(t.elements.filter(typeof(TermSymbol)))
//			}
//			parentScope = Scopes::scopeFor(features, parentScope)
//		}
//		return parentScope
//	}
//
//	def scope_SymbolRef_ref(TermExpression context, EReference r) {
//		val global = getGlobalScope(context, r)
//		val retval = context.eContainer.computeScope(context, global)
//		return retval
//	}
//
//	def scope_EnumRef_constant(TermExpression context, EReference r) {
//		val global = getGlobalScope(context, r)
//		context.eContainer.computeScope(context, global)
//	}
//
//
//
//	def scope_DomainLiteral(EnumLiteral context, EReference r) {
//		var parentScope = IScope::NULLSCOPE
//		// val global = getGlobalScope(context, r)
//		var features = new HashSet
//		if (context.type.finite) {
//			features.addAll(context.type.literals)
//		}
//		Scopes::scopeFor(features, parentScope)
//	}
//
////	def scope_StaticReference_element(StaticReference context, EReference r) {
////		val global = getGlobalScope(context, r)
////		var features = new HashSet
////		features.addAll(context.type.elements.filter(typeof(TermSymbol)))
////		Scopes::scopeFor(features, global)
////	}
//
//	def dispatch IScope computeScope(EnumLiteral container, EObject o, IScope global) {
//		var features = new HashSet
//		features.addAll(container.type.literals)
//		Scopes::scopeFor(features, container.eContainer.computeScope(o.eContainer, global))
//
//	}
//
//	def dispatch IScope computeScope(EObject container, EObject o, IScope global) {
//		container.eContainer.computeScope(o.eContainer, global)
//	}
//	
//	
//	def dispatch IScope computeScope(SecondOrderTerm container, FolFormula member, IScope global) {
//		var features = new HashSet
//		features.add(container.^var)
//		Scopes::scopeFor(features, container.eContainer.computeScope(member.eContainer, global))
//	}
//
//	def dispatch IScope computeScope(SecondOrderTerm container, TermExpression member, IScope global) {
//		var features = new HashSet
//		features.add(container.^var)
//		Scopes::scopeFor(features, container.eContainer.computeScope(member.eContainer, global))
//	}
//
//	def dispatch IScope computeScope(FolFormula container, FolFormula o, IScope global) {
//		Scopes::scopeFor(container.scope, container.eContainer.computeScope(o.eContainer, global))
//	}
//
//
//	def dispatch IScope computeScope(ConstrainedType container, NamedFormula o, IScope global) {
//		// var parentScope = container.eContainer.computeScope(container, global);
//		var parentScope = global;
//		var supertypes = getAllSuperTypes(container);
//		for (level : supertypes.reverseView) {
//			var features = new HashSet
//			for (t : level) {
//				features.addAll(t.elements.filter(typeof(Symbol)))
//			}
//			parentScope = Scopes::scopeFor(features, parentScope)
//		}
//		return parentScope
//	}
//
//	def dispatch IScope computeScope(ConstrainedType container, ConstrainedType o, IScope global) {
//		var parentScope = container.eContainer.computeScope(container, global);
//		var supertypes = getAllSuperTypes(container);
//		for (level : supertypes.reverseView) {
//			var features = new HashSet
//			for (t : level) {
//				features.addAll(t.elements.filter(typeof(Symbol)))
//			}
//			parentScope = Scopes::scopeFor(features, parentScope)
//		}
//		return parentScope
//	}
//
//	def dispatch IScope computeScope(Model container, ConstrainedType o, IScope global) {
//
//		// return global;
//		Scopes::scopeFor(container.elements.filter(typeof(Symbol)), global)
//	}
//
//	def dispatch IScope computeScope(Model container, NamedFormula o, IScope global) {
//
//		// return global;
//		Scopes::scopeFor(container.elements.filter(typeof(Symbol)), global)
//	}
//
//	def scope_VariableAssignment_key(Interpretation context, EReference r) {
//		// if the econtainer is a variable declaration, then get all the attributes
//		val container = context.eContainer
//		var parentScope = IScope::NULLSCOPE
//		var TypeReference typeref = null;
//		switch (container) {
//			VariableDeclaration: {
//				typeref = container.type
//			}
//			ConstantDeclaration: {
//				typeref = container.type
//			}
//			FunctionDefinition: {
//				typeref = container.type
//			}
//			
////			TermValue: {
////				if ((container.eContainer as VariableAssignment).key != null) {
////					typeref = (container.eContainer as VariableAssignment).key.type
////				}
////			}
//		}
//		if (typeref === null ){
//			return IScope::NULLSCOPE
//		} 
//		return typeref.getSuperclassScopes(parentScope)
//	}
//
//	def scope_EnumLiteral_type(FolFormula context, EReference r) {
//		var global = getGlobalScope(context, r)
//		// only report types and only the one that are enums
//		val (IEObjectDescription)=>boolean filter = [ieod|isEnum(ieod)]
//		global = new FilteringScope(global, filter);
//
//	}
//
//	def scope_StaticReference_type(FolFormula context, EReference r) {
//		var global = getGlobalScope(context, r)
//		// only report types and only the one that are enums
//		val (IEObjectDescription)=>boolean filter = [ieod|isStatic(ieod)]
//
//		global = new FilteringScope(global, filter);
//
//	}
//
//	def boolean isEnum(IEObjectDescription ieod) {
//		val obj = ieod.EObjectOrProxy
//		if (obj instanceof ConstrainedType){
//			if (obj.eIsProxy) {
//				return true;
//			}
//			if (obj.isFinite) {
//				return true;
//			}
//		}
//		return false;
//	}
//
//	def boolean isStatic(IEObjectDescription ieod) {
//		val obj = ieod.EObjectOrProxy
//		if (obj instanceof ConstrainedType) {
////			if (obj.isStatic) {
////				return true;
////			}
//		}
//		return false;
//	}
//
//	def getAllBoundVariables(TermExpression context) {
//		val variables = <Symbol>newArrayList()
//		var f = context.getContainerOfType(typeof(FolFormula))
//		while (f !== null && f.symbol !== null) {
//
//			if (f.symbol == "Forall" || f.symbol == "Exists") {
//				variables.addAll(f.scope)
//			}
//			f = f.getContainerOfType(typeof(FolFormula))
//		}
//		variables
//	}
//
//	def getSuperclassScopes(TypeReference typeref, IScope parentScope) {
//		var IScope computed
//		if (typeref === null || typeref.primitive)
//			return parentScope
//		var supertypes = getAllSuperTypesReferences(typeref);
//		var first = true;
//		for (level : supertypes.reverseView) {
//			var features = new HashSet
//			for (t : level) {
//				var theType = t.type;
//				switch (theType) {
//					ConstrainedType: features.addAll(theType.elements.filter(typeof(Symbol)))
//				}
//			}
//			if (first) {
//				computed = Scopes::scopeFor(features, parentScope)
//				first = false;
//			} else {
//				computed = Scopes::scopeFor(features, computed)
//
//			}
//		}
//		return computed
//	}
}
