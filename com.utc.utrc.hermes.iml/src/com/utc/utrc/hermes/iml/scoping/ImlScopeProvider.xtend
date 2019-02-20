/*
 * generated by Xtext 2.12.0
 */
package com.utc.utrc.hermes.iml.scoping

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.EnumRestriction
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.iml.InstanceConstructor
import com.utc.utrc.hermes.iml.iml.LambdaExpression
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.QuantifiedFormula
import com.utc.utrc.hermes.iml.iml.SequenceTerm
import com.utc.utrc.hermes.iml.iml.SignedAtomicFormula
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.TupleType
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import java.util.Arrays
import java.util.HashSet
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.naming.IQualifiedNameConverter
import org.eclipse.xtext.resource.IEObjectDescription
import org.eclipse.xtext.scoping.IScope
import org.eclipse.xtext.scoping.Scopes
import org.eclipse.xtext.scoping.impl.AbstractDeclarativeScopeProvider
import org.eclipse.xtext.scoping.impl.FilteringScope

import static extension org.eclipse.xtext.EcoreUtil2.*
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.TailedExpression
import com.utc.utrc.hermes.iml.typing.ImlTypeProvider
import com.utc.utrc.hermes.iml.typing.TypingServices

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

	@Inject
	private IQualifiedNameConverter qualifiedNameConverter;
	
	@Inject
	private ImlStdLib stdLib

	@Inject extension ImlTypeProvider
	
	@Inject extension TypingServices
	

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

	def IScope getGlobalScope(EObject context, EReference r) {
		var global = delegateGetScope(context, r)

		val (IEObjectDescription)=>boolean filter = [ieod|ieod.isImported(context.getContainerOfType(typeof(Model)))]

		global = new FilteringScope(global, filter);
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
			scope = scopeOfNamedType(typeConstructor, scope)
		}

		if (context.getContainerOfType(NamedType) === null) {
			return scope;
		}

		return scopeOfNamedType(context.getContainerOfType(NamedType), scope)
	}

	protected def scopeOfNamedType(NamedType type, IScope scope) {
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
		val tailedExpr = arrayAccess.eContainer as TailedExpression
		var type = termExpressionType(tailedExpr.left)
		if (type instanceof TupleType) {
			return Scopes::scopeFor(type.symbols);
		}

//		var break = false;
//		for (ExpressionTail tail : tailedExpr.tails) {
//			if (!break) {
//				if (tail === arrayAccess) {
//					if (type instanceof TupleType) {
//						return Scopes::scopeFor(type.symbols);
//					} else { // It is just normal array access not tuple
//						break = true;
//					}
//				} else {
//					type = ImlTypeProvider.accessTail(type, tail)
//				}
//			}
//		}
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
	}

	def scope_SymbolReferenceTerm_symbol(TermMemberSelection context, EReference r) {
		var parentScope = IScope::NULLSCOPE
		val receiver = context.receiver

		if (receiver instanceof SymbolReferenceTerm) {
			val symb = (receiver as SymbolReferenceTerm).symbol
			if (symb instanceof NamedType) {
				// The receiver is a constrained type
				// This is a reference to an enum
				val ct = (receiver as SymbolReferenceTerm).symbol as NamedType
				if (! ct.restrictions.isEmpty) {
					val res = ct.restrictions.filter(EnumRestriction)
					if (! res.isEmpty) {
						return Scopes::scopeFor(res.get(0).literals);
					}
				}
			}
		} 

		var receiverType = receiver.termExpressionType

		if (receiverType === null) {
			return parentScope
		}

		val superTypes = receiverType.allSuperTypes
		for (level : superTypes.reverseView) {
			var features = new HashSet
			for (t : level) {
				if (t instanceof SimpleTypeReference) {
					var theType = t.type;
					switch (theType) {
						NamedType: features.addAll(theType.symbols)
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

	def IScope buildNestedScope(EObject o) {
		if (o === null) {
			return IScope::NULLSCOPE
		}
		switch (o) {
			NamedType:
				return scopeOfNamedType(o, buildNestedScope(o.eContainer))
			InstanceConstructor:
				return Scopes::scopeFor(Arrays.asList(o.ref), buildNestedScope(o.eContainer))
			LambdaExpression:
				if (o.signature instanceof TupleType) {
					return Scopes::scopeFor((o.signature as TupleType).symbols, buildNestedScope(o.eContainer));

				} else
					return buildNestedScope(o.eContainer)
			QuantifiedFormula:
				return Scopes::scopeFor(o.scope, buildNestedScope(o.eContainer))
			SequenceTerm:
				return Scopes::scopeFor(o.defs, buildNestedScope(o.eContainer))
			Model:
				return Scopes::scopeFor(o.symbols, getGlobalScope(o,ImlPackage::eINSTANCE.model_Symbols))
			default:
				return buildNestedScope(o.eContainer)
		}
	}
}
