/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */

package com.utc.utrc.hermes.iml

import org.eclipse.xtext.testing.util.ParseHelper
import com.utc.utrc.hermes.iml.iml.Model
import com.google.inject.Inject
import java.nio.file.Files
import java.nio.file.Paths
import org.eclipse.emf.common.util.URI
import org.eclipse.emf.ecore.resource.ResourceSet
import javax.inject.Provider
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import org.eclipse.xtext.testing.validation.ValidationTestHelper
import java.util.List
import org.eclipse.xtext.validation.Issue
import java.util.ArrayList
import org.eclipse.xtext.diagnostics.Severity
import com.utc.utrc.hermes.iml.util.FileUtil
import org.eclipse.core.runtime.Platform
import org.eclipse.core.runtime.FileLocator
import java.net.URISyntaxException
import java.io.IOException

class ImlParseHelper {

	@Inject
	private ParseHelper<Model> parseHelper;
	
	@Inject 
	private Provider<ResourceSet> rsp;
	
	@Inject
	private ValidationTestHelper validationTestHelper;
	
	@Inject
	private ImlStdLib stdLib;
	
	private ResourceSet stdRs;
	
	
	def parse(CharSequence modelText) {
		parse(modelText, true)
	}
	
	def parse(CharSequence modelText, boolean loadStdLib) {
		if (loadStdLib) {
			parseHelper.parse(modelText, loadStdLibs)
		} else {
			parseHelper.parse(modelText)
		}
	}
	
	def parse(CharSequence modelText, ResourceSet rs) {
		parseHelper.parse(modelText, rs)
	}
	
	def ResourceSet loadStdLibs() {
		if (stdRs === null) {
			val imlLibUrl = getImlLibUrl();
			stdRs = rsp.get
			Files.walk(Paths.get(imlLibUrl)).filter[Files.isRegularFile(it) && it.toFile().getName().endsWith(".iml")]
					.forEach[
						stdRs.createResource(URI.createFileURI(it.toFile.absolutePath)).load(stdRs.loadOptions)
					]
			stdLib.populateLibrary(stdRs)
		}
		return stdRs;
	}
	
	def private getImlLibUrl() {
		var java.net.URI imlLibUrl = null;
		if (this.getClass().classLoader.getResource("./iml/") !== null) {
			imlLibUrl = this.getClass().classLoader.getResource("./iml/").toURI
		} else {
			// Get lib folder for plugin
			val bundle = Platform.getBundle("com.utc.utrc.hermes.iml.lib");
			var fileURL = bundle.getEntry("iml/");
			if (fileURL === null) { // It might be in development environment
				fileURL = bundle.getEntry("src/iml/")
			}
			try {
				val resolvedFileURL = FileLocator.toFileURL(fileURL);
			   // We need to use the 3-arg constructor of URI in order to properly escape file system chars
			   imlLibUrl = new java.net.URI(resolvedFileURL.getProtocol(), resolvedFileURL.getPath(), null);
			} catch (URISyntaxException e1) {
			    e1.printStackTrace();
			} catch (IOException e1) {
			    e1.printStackTrace();
			}
		}
		if (imlLibUrl === null) {
			throw new IllegalStateException("Couldn't retrieve the standard library path")
		} else {
			return imlLibUrl
		}
	}
	
	/**
	 * Parse given list of texts together and return the resource set that includes all of them parsed
	 * @param texts list of models text to be parsed
	 * @return
	 */
	def ResourceSet parse(List<String> models, boolean loadStdLib) {
		var rs = rsp.get
		if (loadStdLib) {
			rs = loadStdLibs
		}
		for (modelText : models) {
			parse(modelText, rs)
		}
		return rs
	}
	
	def ResourceSet parseDir(String dirUrl, boolean loadStdLib) {
		return parse(FileUtil.readAllFilesUnderDir(dirUrl), loadStdLib);
	}
	
	def private List<Issue> getErrors(Model model) {
		val errors = new ArrayList<Issue>();
		val issues = validationTestHelper.validate(model);
		for (Issue issue : issues) {
			if (issue.getSeverity() == Severity.ERROR) {
				errors.add(issue);
			}
		}
		return errors;
	}
	
	def List<Issue> checkErrors(ResourceSet rs) {
		val errors = new ArrayList<Issue>();
		for (r : rs.getResources()) {
			if (!r.getContents().isEmpty() && r.getContents().get(0) instanceof Model) {
				errors.addAll(getErrors(r.getContents().get(0) as Model));
			}
		}
		return errors;
	}
	
	def List<Issue> checkErrors(Model model) {
		return checkErrors(model.eResource().getResourceSet());
	}
	
	def void assertNoErrors(ResourceSet resourceSet) {
		resourceSet.resources.forEach[validationTestHelper.assertNoErrors(it.contents.get(0))]
	}
	
}