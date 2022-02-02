/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.tests.scoping

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.ArrayAccess
import com.utc.utrc.hermes.iml.iml.ImlPackage
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration
import com.utc.utrc.hermes.iml.iml.SymbolReferenceTerm
import com.utc.utrc.hermes.iml.iml.TailedExpression
import com.utc.utrc.hermes.iml.iml.TermMemberSelection
import com.utc.utrc.hermes.iml.scoping.ImlScopeProvider
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.utc.utrc.hermes.iml.tests.TestHelper
import java.util.Arrays
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.EReference
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.*
import com.utc.utrc.hermes.iml.ImlParseHelper
import com.utc.utrc.hermes.iml.iml.TupleConstructor

/**
 * 
 * @author Ayman Elkfrawy
 */
@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ImlScopeProviderTest {
	
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension ImlScopeProvider
	
	@Inject extension TestHelper
	
	
	@Test
	def scopeForMemberSelection() {
		val model = '''
			package p;
			type t1 {
				var1 : Int;
			};
			
			type t2 {
				var2 : t1;
				varx : Int := var2.var1;
			};
		'''.parse;
		model.assertNoErrors ;
		((model.symbols.last as NamedType).symbols.last.definition.left as TermMemberSelection) => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, Arrays.asList("var1"))
		];
		return
	}
	
	@Test
	def scopeForMemberSelection_WithExtension() {
		val model = '''
			package p;
			type Parent {
				varp : Int;
			};
			type t1 includes (Parent) {
				var1 : Int;
			};
			
			type t2 {
				var2 : t1;
				varx : Int := var2.var1;
			};
		'''.parse;
		model.assertNoErrors ;
		((model.symbols.last as NamedType).symbols.last.definition.left as TermMemberSelection) => [
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
			};
			type t1 includes (Parent) {
				var1 : Int;
				varx : Int := varp;
			};
		'''.parse(false);
		
		((model.symbols.last as NamedType).symbols.last.definition.left as SymbolReferenceTerm) => [
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
		'''.parse(false);
		
		model = '''
			package p2;
			import p1.*;
			type Int;
			type P2T1 {
				var1 : Int;
				varx : Int := var1;
			}
		'''.parse(model.eResource.resourceSet)
		
		((model.symbols.last as NamedType).symbols.last.definition.left as SymbolReferenceTerm) => [
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
			type t1 {
				var1 : {e1: Int, e2:Real};
				varx : Real := var1.e2;
			}
		'''.parse
		model.assertNoErrors;
		
		((model.symbols.last as NamedType).symbols.last.definition.left 
		   as TermMemberSelection).member => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e1", "e2"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTail() {
		val model = '''
			package p;
			type t1 {
				var1 : (Int, {e1: Int, e2:Real});
				varx : Real := var1[1].e2;
			}
		'''.parse
		model.assertNoErrors;
		
		((model.symbols.last as NamedType).symbols.last.definition.left 
		   as TermMemberSelection).member => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e1", "e2"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTailWithTemplates() {
		val model = '''
			package p;
			
			type t2 <T> {
				vT : T;
			}
			
			type t1 {
				var1 : t2<(Int, {e1: Int, e2:Real})>;
				varx : Real := var1.vT[1].e2;
			}
		'''.parse
		model.assertNoErrors;
		
		((model.symbols.last as NamedType).symbols.last.definition.left 
		   as TermMemberSelection).member => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e1", "e2"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTailWithTemplates2() {
		val model = '''
			package p;
			
			type t3 <P>{
				vP : P;
			}
			
			type t2 <T> {
				vT : t3<(Int, {e1: Int, e2: T})>;
			}
			
			type t1 {
				var1 : t2<{e3: Real, e4: Int}>;
				varx : Int := var1.vT.vP[1].e2.e4;
			}
		'''.parse
		model.assertNoErrors;
		
		((model.symbols.last as NamedType).symbols.last.definition.left 
		   as TermMemberSelection).member => [
			assertScope(ImlPackage::eINSTANCE.symbolReferenceTerm_Symbol, 
				Arrays.asList("e3", "e4"))
		];
		return
	}
	
	@Test
	def scopeForTupleAccess_ComplexTail_Invalid() {
		val model = '''
			package p;
			type t1 {
				var1 : (Int, {e1: Int, e2:Real});
				varx : Int := var1[e1][1];
			}
		'''.parse
		model.validate
		val errors = model.eResource.errors
		assertEquals(1, errors.size)
		assertEquals("Couldn't resolve reference to Symbol 'e1'.", errors.get(0).message)
	}
	
	@Test
	def scopeInsideProgram() {
		val model = '''
			package p;
			
			type T1 {
				var1 : Int;
			}
			
			type T2 {
				prog: Int := {
					var t1 : T1;
					t1.var1;	
				};
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def scopeForTypeConstructor() {
		val model = '''
			package p;
			
			type T1 {
				var1 : Int;
				var2 : SubT;
			}
			
			type T2 {
				vv : T1 := some(a:T1) {a.var1 = vvv && a.var2.vsub=5};
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
			
			type T1 <T> {
				var1 : Int;
				var2 : T;
			}
			
			type T2 {
				vv : T1<SubT> := some(t: T1<SubT>) {t.var1 = vvv && t.var2.vsub = 5};
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
			type A {
				b: Int;
			}
			
			type B {
				b: Int;
				a : A := some( x:A ) {x.b = b};
			}
		'''.parse
		model.assertNoErrors
		val ab = (model.findSymbol("A") as NamedType).findSymbol("b");
		val bb = (model.findSymbol("B") as NamedType).findSymbol("b");
		//val assignment = (((model.findSymbol("B") as NamedType).findSymbol("a").definition.left as InstanceConstructor)
		//			.init as SequenceTerm).relations.get(0).left as AtomicExpression;
		
		//assertEquals(((assignment.left as TermMemberSelection).member as SymbolReferenceTerm).symbol, ab)
		//assertEquals((assignment.right as SymbolReferenceTerm).symbol, bb)
	}
	
	@Test
	def scopeForEnumReference() {
		val model = '''
		package iml.notes ;
		type RGB enum {red , green , blue} ;
		assert "Green and blue are different" { RGB.green != RGB.red };
		'''.parse
		model.assertNoErrors
		return
	}
	
	@Test
	def scopeForInstanceConstructor() {
		val model = '''
		package iml.notes ;
		type Date ;
		type Employee {
			level : Int;
			supervisor : Employee;
			salary : Date -> Int; 
		};
		sup : Employee ;
		aEmployee : Employee := some(x:Employee) { x.level = 4 && x.supervisor = sup} ;
		'''.parse
		//Let's get all the elements and compute their scopes
		val aEmployee = model.symbols.last as SymbolDeclaration
		model.assertNoErrors
		return
	}
	
	@Test 
	def scopeForRefinement() {
		val model = '''
			package p;
			trait Tr {
				a : Int;
			}
			
			trait Tr2 refines(Tr) {
				b : Int := a;
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test 
	def scopeForRefinement2() {
		val model = '''
			package p;
			trait Tr {
				a : Int;
			}
			
			trait Tr2 refines(Tr) {
				b : Int := a;
			}
			type T1 exhibits(Tr2) {
				x : Int := a;
				y : Int := b;
			}
		'''.parse
		model.assertNoErrors
	}
	
	@Test
	def scopeForExhibitsWithTemplates() {
		val model = '''
			package p;
			trait Tr<T> {
				spec : T;				
			}
			
			type Tx {
				x : Int;
			};
			
			type Ty exhibits(Tr<Tx>) {
				y : Int := spec.x;
			}
		'''.parse
		
		model.assertNoErrors
	}
	
	def private assertScope(EObject context, EReference ref, List<String> expected) {
		context.assertNoErrors
		val scope = context.getScope(ref).allElements.map[name.toString].toList
		assertEquals(expected.size, scope.size)
		assertTrue(expected.containsAll(scope))
	}
	
	@Test
	def scopeForTypeInit() {
		val model = '''
			package p;
			type T1 {
				a : Int;
				b: Real;				
			}
			
			t1 : T1(a := 5, b := 2.5);
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def scopeForTypeInitParentSymbol() {
		val model = '''
			package p;
			trait P1 {
				x: Int;
			}
			type T1 exhibits (P1) {
				a : Int;
				b: Real;				
			}
			
			t1 : T1(a := 5, b := 2.5, x := 10);
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def scopeForTypeInitPartialInit() {
		val model = '''
			package p;
			type T1 {
				a : Int;
				b: Real;				
			}
			
			t1 : T1(a := 5);
		'''.parse
		
		model.assertNoErrors
	}
	
}