package com.utc.utrc.hermes.iml.tests.string

import org.junit.runner.RunWith
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.google.inject.Inject
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import com.utc.utrc.hermes.iml.tests.TestHelper
import com.utc.utrc.hermes.iml.iml.Model
import org.junit.Test

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)

class ImlStringTests {
	
	@Inject extension ParseHelper<Model> 
	@Inject extension ValidationTestHelper
	@Inject extension TestHelper
	
	@Test
	def void testStringsCompatible(){
		val stdlib = loadStdLib 
		'''
		package p ;
		import iml.lang.* ;
		
		x : String ;
		y : String ;
		z : Int ;
		assert a { x = y };
		'''.parse(stdlib.eResource.resourceSet).assertNoErrors
	
	}
	
	@Test
	def void testStringsNotCompatible(){
		val stdlib = loadStdLib 
		'''
		package p ;
		import iml.lang.* ;
		
		x : String ;
		y : String ;
		z : Int ;
		assert a { x = z };
		'''.parse(stdlib.eResource.resourceSet).assertNoErrors
	
	}
	
	@Test
	def void testStringCharTerm(){
		val stdlib = loadStdLib 
		'''
		package p ;
		import iml.lang.* ;
		
		x : String := "hermes";
		y : String ;
		z : Char := 'a' ;
		assert a { x = y };
		assert b { x.length = 6} ;
		assert c { x.charAt(0) = 'h' } ;
		'''.parse(stdlib.eResource.resourceSet).assertNoErrors
	
	}
	
	
	@Test
	def testStdLib(){
		val model = loadStdLib ;
		model.assertNoErrors ;
	}
	
	def loadStdLib() {
	val model  = '''
	package iml.lang;
	
	type Int;
	type Real;
	type Bool;
	type Char ;
	type String { 
		concat : String -> String ;
		length : Int ;
		contains : String -> Bool ;
		indexOf : (String,Int) -> Int ;
		replace : (String,String) -> String ;
		replaceAll : (String,String) -> String ;
		charAt : Int -> Char ;
		subStr : (Int,Int) -> String ;
		prefixOf : String -> Bool ;
		suffixOf : String -> Bool ;
		int2str : Int -> String ;
		re2str : Real -> String ; 
	};
	str2int : String -> Int ;
	str2re : String->Real ;
	emptyString : String  ; 
	'''.parse ;
	
	return model ;
	}
	
		
	
	
}