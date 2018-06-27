package com.utc.utrc.hermes.iml;

import java.util.ArrayList;
import java.util.List;

import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.resource.ResourceSet;
import org.eclipse.xtext.diagnostics.Severity;
import org.eclipse.xtext.testing.util.ParseHelper;
import org.eclipse.xtext.testing.validation.ValidationTestHelper;
import org.eclipse.xtext.validation.Issue;

import com.google.inject.Injector;
import com.utc.utrc.hermes.iml.iml.Model;

/**
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 *
 */
public class ImlStandaloneParseHelper {
	
	private static ImlStandaloneParseHelper instance;

	private ParseHelper<Model> parseHelper;
	private ValidationTestHelper validationTestHelper;
	
	private Injector injector;
	
	public static synchronized ImlStandaloneParseHelper getInstance() {
		if (instance == null) {
			instance = new ImlStandaloneParseHelper();
		}
		return instance;
	}
	
	private ImlStandaloneParseHelper() {
		injector = new ImlStandaloneSetup().createInjectorAndDoEMFRegistration();
		parseHelper = injector.getInstance(ParseHelper.class);
		validationTestHelper = injector.getInstance(ValidationTestHelper.class);
	}
	
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
	
	/**
	 * Parse given list of texts together and return the resource set that includes all of them parsed
	 * @param texts list of models text to be parsed
	 * @return
	 */
	public ResourceSet parse(List<String> texts) {
		ResourceSet rs = null;
		if (!texts.isEmpty()) {
			rs = parse(texts.remove(0)).eResource().getResourceSet();
		}
		for (String s : texts) {
			parse(s, rs);
		}
		return rs;
	}
	
	public Model parse(String modelText, ResourceSet rs) {
		try {
			return parseHelper.parse(modelText, rs);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public Model parse(String modelText) {
		try {
			return parseHelper.parse(modelText);
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
}
