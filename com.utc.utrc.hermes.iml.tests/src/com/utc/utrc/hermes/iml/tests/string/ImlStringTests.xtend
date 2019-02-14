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
		'''.parse(stdlib.eResource.resourceSet).assertNoErrors
	
	}
	
	def loadStdLib() {
	'''
	package iml.lang;
	
	type Int;
	type Real;
	type Bool;
	type String;
	type Char ;
	'''.parse
	}
	
		
	
	
}