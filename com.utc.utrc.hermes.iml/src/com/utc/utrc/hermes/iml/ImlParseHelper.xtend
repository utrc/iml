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
import java.nio.file.FileSystem
import java.nio.file.FileSystems
import java.util.HashMap
import java.util.stream.Collectors
import java.io.File
import java.util.jar.JarFile

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
	
	Object Collections
	
	
	def parse(CharSequence modelText) {
		parse(modelText, true)
	}
	
	def parse(CharSequence modelText, boolean loadLibs) {
		if (loadLibs) {
			parseHelper.parse(modelText, loadAllLibraries)
		} else {
			parseHelper.parse(modelText)
		}
	}
	
	def parse(CharSequence modelText, ResourceSet rs) {
		parseHelper.parse(modelText, rs)
	}
	
	def ResourceSet loadAllLibraries() {
		stdLib.reset()
		var ResourceSet rs = loadStdLibs;
		val registry = Platform.getExtensionRegistry();
  		if (registry !== null) {
	   		val extensions = registry.getConfigurationElementsFor("com.utc.utrc.hermes.iml.lib");
	   		for (libExtension : extensions) {
//	   			val libDir = libExtension.namespace + '/' + libExtension.getAttribute("lib_directory")
				val libExtentionUrl = getLibFolderFromPlugin(libExtension.namespaceIdentifier)
	   			rs = getRsFromFolder(libExtentionUrl, rs);
	   		}
		}
		
		return rs;
	}
	
	def ResourceSet loadStdLibs() {
		stdRs = getStandardRs()
		return stdRs;
	}
	
	def getStandardRs() {
		var java.net.URI imlLibUrl = null;
		val jarFile = new File(getClass().getProtectionDomain().getCodeSource().getLocation().getPath());
		if (jarFile.isFile) {
			return getRsFromJar(jarFile)
		} else if (this.getClass().classLoader.getResource("./iml/") !== null) {
			imlLibUrl = this.getClass().classLoader.getResource("./iml/").toURI
			if (imlLibUrl.getScheme().equals("jar")) {
	            val fileSystem = FileSystems.newFileSystem(imlLibUrl, new HashMap());
	            val path = fileSystem.getPath(".");
	         	
	         	val libFiles = Files.walk(path).filter[Files.isRegularFile(it) && it.toFile().getName().endsWith(".iml")]
					.map[new String(Files.readAllBytes(it))].collect(Collectors.toList())
				return parse(libFiles, false);
            }
		} else {
			// Get lib folder for plugin
			imlLibUrl = getLibFolderFromPlugin("com.utc.utrc.hermes.iml.lib")
		}
		if (imlLibUrl === null) {
			throw new IllegalStateException("*** Couldn't retrieve the standard library path ***")
		} else {
			return getRsFromFolder(imlLibUrl, null)
		}
	}
	
	def getLibFolderFromPlugin(String pluginNs) {
		val bundle = Platform.getBundle(pluginNs);
		var fileURL = bundle.getEntry("iml/");
		if (fileURL === null) { // It might be in development environment
			fileURL = bundle.getEntry("src/iml/")
		}
		try {
			val resolvedFileURL = FileLocator.toFileURL(fileURL);
		   // We need to use the 3-arg constructor of URI in order to properly escape file system chars
		   return new java.net.URI(resolvedFileURL.getProtocol(), resolvedFileURL.getPath(), null);
		} catch (URISyntaxException e1) {
		    e1.printStackTrace();
		} catch (IOException e1) {
		    e1.printStackTrace();
		}
		return null
	}
	
	def getRsFromFolder(java.net.URI imlLibUrl, ResourceSet rs) {
		var initRs = rs
		if (initRs === null) {
			initRs = rsp.get
		}
		val result = initRs
		Files.walk(Paths.get(imlLibUrl)).filter[Files.isRegularFile(it) && it.toFile().getName().endsWith(".iml")]
			.forEach[
				result.createResource(URI.createFileURI(it.toFile.absolutePath)).load(result.loadOptions)
			]
		return result
	}
	
	def getRsFromJar(File file) {
		val jar = new JarFile(file);
		val entries = jar.entries(); //gives ALL entries in jar
		val libFiles = new ArrayList<String>()
		while(entries.hasMoreElements()) {
		    val entry = entries.nextElement();
		    if (entry.name.startsWith("iml/") && entry.name.endsWith(".iml")) { //filter according to the path
		    	val is = jar.getInputStream(entry)
		    	libFiles.add(FileUtil.convertStreamToString(is))
		    	is.close
		    }
		}
		jar.close();
		return parse(libFiles, false)
	}
	
	/**
	 * Parse given list of texts together and return the resource set that includes all of them parsed
	 * @param texts list of models text to be parsed
	 * @return
	 */
	def ResourceSet parse(List<String> models, boolean loadLibs) {
		var rs = rsp.get
		if (loadLibs) {
			rs = loadAllLibraries
		}
		for (modelText : models) {
			parse(modelText, rs)
		}
		return rs
	}
	
	def ResourceSet parseDir(String dirUrl, boolean loadLibs) {
//		return parse(FileUtil.readAllFilesUnderDir(dirUrl), loadLibs);
		var rs = rsp.get
		if (loadLibs) {
			rs = loadAllLibraries
		}
		return getRsFromFolder(new File(dirUrl).toURI, rs);
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