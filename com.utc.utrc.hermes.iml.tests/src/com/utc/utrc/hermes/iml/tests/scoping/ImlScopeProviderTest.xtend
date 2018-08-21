package com.utc.utrc.hermes.iml.tests.scoping

import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.junit.runner.RunWith
import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import com.google.inject.Inject
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.junit.Test
import com.utc.utrc.hermes.iml.scoping.ImlScopeProvider
import com.utc.utrc.hermes.iml.iml.ConstrainedType
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.iml.ImlPackage
import org.eclipse.emf.ecore.EReference
import org.eclipse.emf.ecore.EObject
import static extension org.junit.Assert.*
import java.util.Arrays
import java.util.List
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.TypeConstructor
import com.utc.utrc.hermes.iml.iml.AtomicExpression
import com.utc.utrc.hermes.iml.iml.Program

/**
 * 
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlScopeProviderTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension ImlScopeProvider
	
	@Inject extension TestHelper
	
	
	@Test
	def scopeForMemberSelection() {
		val model = '''
			package p;
			type Int;
			type t1 {
				var1 : Int;
			}
			
			type t2 {
				var2 : t1;
				varx : Int := var2->var1;
			}
		'''.parse;
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as TermMemberSelection) => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, Arrays.asList("var1"))
		];
		return
	}
	
	@Test
	def scopeForMemberSelection_WithExtension() {
		val model = '''
			package p;
			type Int;
			type Parent {
				varp : Int;
			}
			type t1 extends Parent {
				var1 : Int;
			}
			
			type t2 {
				var2 : t1;
				varx : Int := var2->var1;
			}
		'''.parse;
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as TermMemberSelection) => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, Arrays.asList("var1", "varp"))
		];
		return
	}
	
	@Test
	def scopeForAtomicMember_WithParent() {
		val model = '''
			package p;
			type Int;
			type Parent {
				varp : Int;
			}
			type t1 extends Parent {
				var1 : Int;
				varx : Int := varp;
			}
		'''.parse;
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as SymbolReferenceTerm) => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("var1", "varp", "Int", "Parent", "Parent.varp", 
						"t1.var1", "t1.varx", "varx", "t1"))
		];
		return
	}
	
	@Test
	def scopeForAtomicMember_MutliplePackages() {
		var model = '''
			package p1;
			type P1T1;
		'''.parse;
		
		model = '''
			package p2;
			import p1.*;
			type Int;
			type P2T1 {
				var1 : Int;
				varx : Int := var1;
			}
		'''.parse(model.eResource.resourceSet)
		
		((model.symbols.last as ConstrainedType).symbols.last.definition.left as SymbolReferenceTerm) => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("var1", "varx", "P2T1", "P2T1.var1", "P2T1.varx", 
						"Int", "P1T1", "p1.P1T1"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : (e1: Int, e2:Real);
				varx : Real := var1[e2];
			}
		'''.parse
		model.assertNoErrors;
		
		(((model.symbols.last as ConstrainedType).symbols.last.definition.left 
		   as SymbolReferenceTerm).tails.get(0) as ArrayAccess).index.left => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e1", "e2"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTail() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : (Int, (e1: Int, e2:Real));
				varx : Real := var1[1][e2];
			}
		'''.parse
		model.assertNoErrors;
		
		(((model.symbols.last as ConstrainedType).symbols.last.definition.left 
		   as SymbolReferenceTerm).tails.get(1) as ArrayAccess).index.left => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e1", "e2"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTailWithTemplates() {
		val model = '''
			package p;
			type Int;
			type Real;
			
			type t2 <type T> {
				vT : T;
			}
			
			type t1 {
				var1 : t2<(Int, (e1: Int, e2:Real))>;
				// varx : Real := var1->vT[1][e2]; // We won't support named access
				varx : Real := var1->vT[1][1];
			}
		'''.parse
		model.assertNoErrors;
		
		((((model.symbols.last as ConstrainedType).symbols.last.definition.left 
		   as TermMemberSelection).member as SymbolReferenceTerm).tails.get(1) as ArrayAccess).index.left => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e1", "e2"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTailWithTemplates2() {
		val model = '''
			package p;
			type Int;
			type Real;
			
			type t3 <type P>{
				vP : P;
			}
			
			type t2 <type T> {
				vT : t3<(Int, (e1: Int, e2: T))>;
			}
			
			type t1 {
				var1 : t2<(e3: Real, e4: Int)>;
				varx : Int := var1->vT->vP[1][1][1];
			}
		'''.parse
		model.assertNoErrors;
		
		((((model.symbols.last as ConstrainedType).symbols.last.definition.left 
		   as TermMemberSelection).member as SymbolReferenceTerm).tails.get(2) as ArrayAccess).index.left => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e3", "e4"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTail_Invalid() {
		val model = '''
			package p;
			type Int;
			type Real;
			type t1 {
				var1 : (Int, (e1: Int, e2:Real));
				varx : Int := var1[e1][1];
			}
		'''.parse
		model.validate
		val errors = model.eResource.errors
		assertEquals(1, errors.size)
		assertEquals("Couldn't resolve reference to Symbol 'e1'.", errors.get(0).message)
	}
	
	@Test
	def scopeInsideLambda() {
		val model = '''
			package p;
			type Int;
			type Real;
			type Bool;
			
			type T1 {
				var1 : Int;
			}
			
			type T2 {
				fun : Int ~> Real;
				formul : Bool := {
					fun = lambda(x: T1) {
						x->var1 = x->var1;
					};
				};
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def scopeInsideProgram() {
		val model = '''
			package p;
			type Int;
			type Real;
			type Bool;
			
			type T1 {
				var1 : Int;
			}
			
			type T2 {
				fun : Int ~> Real;
				prog: Int := {
					var t1 : T1;
					t1->var1;	
				};
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def scopeForTypeConstructor() {
		val model = '''
			package p;
			type Int;
			type Real;
			type Bool;
			
			type T1 {
				var1 : Int;
				var2 : SubT;
			}
			
			type T2 {
				vv : T1 := new T1{var1 = vvv; var2->vsub=5;};
				vvv: Int;
			}
			
			type SubT {
				vsub: Int;
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def scopeForTypeConstructor_WithTemplate() {
		val model = '''
			package p;
			type Int;
			type Real;
			type Bool;
			
			type T1 <type T> {
				var1 : Int;
				var2 : T;
			}
			
			type T2 {
				vv : T1<SubT> := new T1<SubT>{var1 = vvv; var2->vsub=5;};
				vvv: Int;
			}
			
			type SubT {
				vsub: Int;
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def scopeInsidePrograms() {
		val model = '''
			package p;
			type Int;
			type A {
				b: Int;
			}
			
			type B {
				b: Int;
				a : A := new A {
						this->b = b;
					};
			}
		'''.parse
		model.assertNoErrors
		val ab = (model.findSymbol("A") as ConstrainedType).findSymbol("b");
		val bb = (model.findSymbol("B") as ConstrainedType).findSymbol("b");
		val assignment = (((model.findSymbol("B") as ConstrainedType).findSymbol("a").definition.left as TypeConstructor)
					.init as Program).relations.get(0).left as AtomicExpression;
		
		assertEquals(((assignment.left as TermMemberSelection).member as SymbolReferenceTerm).symbol, ab)
		assertEquals((assignment.right as SymbolReferenceTerm).symbol, bb)
	}
	
	
	def private assertScope(EObject context, EReference ref, List<String> expected) {
		context.assertNoErrors
		val scope = context.getScope(ref).allElements.map[name.toString].toList
		assertEquals(expected.size, scope.size)
		assertTrue(expected.containsAll(scope))
	}
	
}