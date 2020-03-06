package com.utc.utrc.hermes.iml.custom;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.eclipse.emf.codegen.ecore.genmodel.GenModel;
import org.eclipse.xtext.xtext.generator.ecore.EMFGeneratorFragment2;

public class EmfGeneratorWithCustomToString extends EMFGeneratorFragment2 {
	
	static final String IMPL_DIR = "com/utc/utrc/hermes/iml/iml/impl";
	
	@Override
	protected void doGenerate(GenModel genModel) {
		super.doGenerate(genModel);
		try {
			Files.walk(Paths.get(".." + genModel.getModelDirectory(), IMPL_DIR))
				.filter(it -> Files.isRegularFile(it))
				.forEach(it -> replaceToStringMethod(it.toFile()));
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

	private void replaceToStringMethod(File file) {
		StringBuilder content = new StringBuilder(readFileContent(file));
		int startIndex = content.indexOf("public String toString()");
		int endIndex = 0;
		if (startIndex != -1) {
			endIndex = content.indexOf("}", startIndex) + 1; // FIXME Potential problem if the method body contains }, it is not the case till now
		} else {
			startIndex = content.lastIndexOf("}") - 1;
			endIndex = startIndex;
		}
		content.replace(startIndex, endIndex, getCustomToStringMethod());
		writeFileContent(file, content.toString());
	}
	
	private String getCustomToStringMethod() {
		return "public String toString() {\n"
				+ "    if (eIsProxy()) return super.toString();\n"
				+ "    \n"
				+ "    return com.utc.utrc.hermes.iml.util.ImlModelPrinter.print(this);\n"
				+ "  }";
	}

	private static String readFileContent(File file) {
		try {
			return new String(Files.readAllBytes(file.toPath()));
		} catch (IOException e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public static void writeFileContent(File file, String content) {
		try {
			Files.write(file.toPath(), content.getBytes());
		} catch (IOException e) {
			e.printStackTrace();
		}
	}

}
