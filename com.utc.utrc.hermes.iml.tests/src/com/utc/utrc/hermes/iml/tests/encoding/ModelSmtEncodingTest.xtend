package com.utc.utrc.hermes.iml.tests.encoding

import com.google.inject.Inject
import com.utc.utrc.hermes.iml.encoding.ImlSmtEncoder
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleFunDeclaration
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleSmtFormula
import com.utc.utrc.hermes.iml.encoding.simplesmt.SimpleSort
import com.utc.utrc.hermes.iml.iml.Model
import com.utc.utrc.hermes.iml.tests.ImlInjectorProvider
import com.utc.utrc.hermes.iml.tests.TestHelper
import org.eclipse.xtext.testing.InjectWith
import org.eclipse.xtext.testing.XtextRunner
import org.eclipse.xtext.testing.util.ParseHelper
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import org.junit.runner.RunWith
import org.junit.Test
import static extension org.junit.Assert.*
import java.util.stream.Collectors
import com.utc.utrc.hermes.iml.util.FileUtil
import org.eclipse.emf.ecore.resource.ResourceSet

@RunWith(XtextRunner)
@InjectWith(ImlInjectorProvider)
class ModelSmtEncodingTest {
	
	@Inject extension ParseHelper<Model>
	
	@Inject extension ValidationTestHelper
	
	@Inject extension TestHelper
	
	@Inject ImlSmtEncoder<SimpleSort, SimpleFunDeclaration, SimpleSmtFormula> encoder
	
	@Test
	def void testTest1GeneratedModelEncoder() {
		
		val files = FileUtil.readAllFilesUnderDir("./res/test1");
		var ResourceSet rs;
		for (file : files) {
			if (rs !== null) {
				rs = file.parse(rs).eResource.resourceSet			 
			} else {
				rs = file.parse.eResource.resourceSet
			}
		}
		var Model swModel = null;
		for (resource : rs.resources) {
			if (resource.contents !== null && resource.contents.size > 0) {
				val model = resource.contents.get(0);
				if (model instanceof Model) {
					model.assertNoErrors
					if ((model as Model).name.equals("SWIMLAnnex")) {
						swModel = model;
					}
				}
				
			}
		}
		if (swModel !== null) {
			encoder.encode(swModel as Model)
			println(encoder.toString)
		}
		
	}
	
	def encode(String modelString, String ctName) {
		val model = modelString.parse;
		model.assertNoErrors
		if (ctName !== null) {
			encoder.encode(model.findSymbol(ctName))
		} else {
			encoder.encode(model)
		}
		// TODO make sure names are unique
		val distinctSorts = encoder.allSorts.map[it.name].stream.distinct.collect(Collectors.toList)
		assertEquals(distinctSorts.size, encoder.allSorts.size)
		val distinctFuncDecls = encoder.allFuncDeclarations.map[it.name].stream.distinct.collect(Collectors.toList)
		assertEquals(distinctFuncDecls.size, encoder.allFuncDeclarations.size)
		return model
	}
	
	@Test
	def void testLoopProblem() {
		encode('''
			package p;
			type Int;
			type T1 {
				var1 : Int := globalVar(5);
			}
			
			globalVar : Int -> Int;
		''', null)
			println(encoder.toString)
	}
	
	
}