package com.utc.utrc.hermes.iml.custom

import com.utc.utrc.hermes.iml.util.FileUtil
import java.nio.file.Files
import java.nio.file.Paths
import org.eclipse.emf.codegen.ecore.genmodel.GenModel
import org.eclipse.xtext.xtext.generator.ecore.EMFGeneratorFragment2

class EmfGeneratorWithCustomToString extends EMFGeneratorFragment2 {
	
	static final String IMPL_DIR = "com/utc/utrc/hermes/iml/iml/impl"
	
	override void doGenerate(GenModel genModel) {
		super.doGenerate(genModel)
		Files.walk(Paths.get(".." + genModel.modelDirectory, IMPL_DIR)).filter[Files.isRegularFile(it)].forEach[
			replaceToString(it.toFile.absolutePath)
		]
	}
	
	def replaceToString(String fileUrl) {
		val content =new StringBuilder(FileUtil.readFileContent(fileUrl));
		var startIndex = content.indexOf("public String toString()")
		var endIndex = 0
		if (startIndex != -1) {
			endIndex = content.indexOf("}", startIndex) + 1 // FIXME Potential problem if the method body contains }, it is not the case till now
		} else {
			startIndex = content.lastIndexOf("}") - 1
			endIndex = startIndex
		}
		content.replace(startIndex, endIndex, getCustomToStringMethod())
		FileUtil.writeFileContent(fileUrl, content.toString)
	}
	
	def getCustomToStringMethod() {
		return '''public String toString() {
    if (eIsProxy()) return super.toString();
    
    return com.utc.utrc.hermes.iml.util.ImlModelPrinter.print(this);
  }
  
		'''
	}
	
}
