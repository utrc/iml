package com.utc.utrc.hermes.iml.tests

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.iml.Model
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.Test
import org.junit.runner.RunWith
import com.utc.utrc.hermes.iml.ImlParseHelper

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ExamplesTest {
	@Inject extension ImlParseHelper
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Test
	def void finiteAssertExampleTest(){
		val model = '''
			package p;
			type Choice finite 4 ; 
			assert "Choice 0 and 4 are the same" {Choice(0) = Choice(3)} ;
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void enumAssertExampleTest(){
		val model = '''
			package p;
			type RGB enum {red , green , blue} ;
			assert "Green and blue are different" {RGB.green != RGB.blue};
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void typeIsExampleTest(){
		val model = '''
			package p;
			type Queue<T>;
			type Map<T,U>;
			type A;
			
			type TestType1 is Queue<A> ;
			type TestType2 is Map<Int, Real> ;
			type TestType4 is Int->Real;
			type TestType5 is Int->Int->Real;
			type TestType6 is (Int->Int)->Real;
			type TestType7 is (A, A) -> Bool;
			type TestType8 is Int[] ;
			type TestType9 is Real[5][2] ;
			type TestType10 is () ;
			type TestType11 is Tuple(Int) ;
			type TestType12 is (Int,Real) ;
			type TestType13 is (A,A) ;
			type TestType14 is (Int,String,Int) ;
			type TestType15 is {age:Int,weight:Real} ;
			type TestType16 is (Real->Int)[10] ;
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void variableDeclarationExampleTest(){
		val model = '''
			package p;
			type Map<T,U>;
			v : Int;
			v1 : Int;
			v2 : Int[][];
			v3 : (Int[][],Int,Int)->Int;
			
			<T>a : T[ ] ;
			<S ,T>b : Map<S ,T> ;
			<T>f : T -> T ;
			<T>g : (T, T) -> Bool ;
		'''.parse
		
		model.assertNoErrors
	}
	
	@Test
	def void someOneOfExampleTest(){
		val model = '''
			package iml.notes ;
			type Date ;
			type Employee {
				level : Int;
				supervisor : Employee;
				salary : Date -> Int; 
			};
			sup : Employee ;
			aEmployee : Employee := some(x:Employee) { x.level = 4 && x.supervisor = sup } ;

		'''.parse
		
		model.assertNoErrors
	}
	
	
	@Test
	def void stackModelTest() {
		val model = '''
			package iml.notes.stackmodel ;
						
			type Stack<T> {
			  top: T;
			  rest : Stack<T>;
			  isEmpty: Bool;
			  pop : () -> Stack<T> := fun (x:()) {
			     if (!isEmpty) { 
			       some (s1: Stack<T>) { (s1.top = s1.rest.top && 
			                 s1.rest = s1.rest.pop()) &&
			                 s1.isEmpty = s1.rest.isEmpty
			                 } 
			    }
			  } ;
			  push : T -> Stack<T> := fun (x:T) {
			    some(s1 :Stack<T>) { s1.top = x && s1.rest = self && s1.isEmpty = false } 
			  } ;
			} ;
			
			<T>emptyStack : Stack<T> := some(s1:Stack<T>) { s1.isEmpty = true };
			
			e : Stack<Int> := <Int>emptyStack ;
			
			s : Stack<Int> := e.push(1).push(2).push(3) ;
			
			//We support the syntax Stack<Int> -> Int -> Stack<Int>
			//but type checking at the moment does not interpret this as 
			//being the same as (Stack<Int> , Int) -> Stack<Int>
			push1 : (Stack<Int> , Int) -> Stack<Int> := fun(x:Stack<Int>,y:Int):Stack<Int>{
				x.push(y)
			} ;
			
			
			s1: Stack<Int> := push1(push1(push1(e,1),2),3) ;
			//Not sure what the syntax Stack<Int>.push(s)(n) means
			//We don't support symbol without type (no type inference)
			//push2 := fun (s:Stack<Int>, n:Int){ s.push(n) };
			//s2: Stack<Int> := push2(push2(push2(e, 1), 2), 3);
		'''.parse

		
		model.assertNoErrors
	}
	
}