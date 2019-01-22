package com.utc.utrc.hermes.iml;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.testing.util.ParseHelper;
import org.eclipse.xtext.testing.validation.ValidationTestHelper;
import org.eclipse.xtext.validation.Issue;

import com.google.inject.Inject;
import com.google.inject.Injector;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.util.FileUtil;

/**
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 *
 */
public class ImlParseHelper extends ParseHelper<Model> {
	
	@Inject
	private ValidationTestHelper validationTestHelper;
	
	private List<Issue> getErrors(Model model) {
		List<Issue> errors = new ArrayList<Issue>();
		List<Issue> issues = validationTestHelper.validate(model);
		for (Issue issue : issues) {
			if (issue.getSeverity() == Severity.ERROR) {
				errors.add(issue);
			}
		}
		return errors;
	}
	
	public List<Issue> checkErrors(ResourceSet rs) {
		List<Issue> errors = new ArrayList<Issue>();
		for (Resource r : rs.getResources()) {
			if (!r.getContents().isEmpty() && r.getContents().get(0) instanceof Model) {
				errors.addAll(getErrors((Model) r.getContents().get(0)));
			}
		}
		return errors;
	}
	
	public List<Issue> checkErrors(Model model) {
		return checkErrors(model.eResource().getResourceSet());
	}
	
	public void assertNoErrors(ResourceSet resourceSet) {
		List<Issue> errors = checkErrors(resourceSet);
		if (!errors.isEmpty()) {
			for (Issue issue : errors) {
				System.err.println(issue);
			}
			assert false;
		}
	}
	
	/**
	 * Parse given list of texts together and return the resource set that includes all of them parsed
	 * @param texts list of models text to be parsed
	 * @return
	 */
	public ResourceSet parse(List<String> texts) {
		ResourceSet rs = null;
		if (!texts.isEmpty()) {
			try {
				rs = parse(texts.remove(0)).eResource().getResourceSet();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		for (String s : texts) {
			try {
				parse(s, rs);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return rs;
	}
	
	public ResourceSet parseDir(String dirUrl) {
		return parse(FileUtil.readAllFilesUnderDir(dirUrl));
	}
	
}
