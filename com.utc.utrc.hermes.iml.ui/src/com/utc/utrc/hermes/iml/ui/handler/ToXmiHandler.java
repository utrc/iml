package com.utc.utrc.hermes.iml.ui.handler;

import java.io.IOException;
import java.util.Date;
import java.util.List;


import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.commands.ExecutionException;
import org.eclipse.core.internal.resources.File;
import org.eclipse.emf.common.util.URI;
import org.eclipse.emf.ecore.resource.Resource;
import org.eclipse.emf.ecore.util.EcoreUtil;
import org.eclipse.ui.console.ConsolePlugin;
import org.eclipse.ui.console.IConsole;
import org.eclipse.ui.console.IConsoleManager;
import org.eclipse.ui.console.MessageConsole;
import org.eclipse.ui.console.MessageConsoleStream;
import org.eclipse.xtext.resource.XtextResourceSet;

import com.google.inject.Inject;

/**
 * This is a sample IML handler which converts IML files into XMI
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 *
 */
public class ToXmiHandler extends BaseHandler {

	@Inject
	XtextResourceSet xtextRs;
	
	final static String CONSOLE_NAME = "IML";

	@Override
	public Object execute(ExecutionEvent event) throws ExecutionException {
		List<Object> selectedObjects = getSelectedElements(event);

		for (Object selectedItem : selectedObjects) {
			if (selectedItem instanceof File && ((File) selectedItem).getFileExtension().equals("iml")) {
				convertSingleFile((File) selectedItem);
			} else {
				logToConsole("Selected file must be an IML file");
			}
		}

		return null;
	}

	private void convertSingleFile(File file) {
		XtextResourceSet rs = new XtextResourceSet();
		Resource xtextResource = rs.getResource(URI.createFileURI(file.getFullPath().toFile().getPath()), true);
		EcoreUtil.resolveAll(xtextResource);
		convertSingleFile(xtextResource);
	}

	private void convertSingleFile(Resource imlResource) {
		Resource xmiResource = imlResource.getResourceSet().createResource(URI.createURI(imlResource.getURI().path().replace(".iml", ".xmi")));
		xmiResource.getContents().add(imlResource.getContents().get(0));
		try {
			xmiResource.save(null);
			logToConsole("File converted successfully: " + xmiResource.getURI());
		} catch (IOException e) {
			logToConsole("Couldn't convert file: " + xmiResource.getURI());
		}
	}
	
	private void logToConsole(String message) {
		MessageConsole myConsole = findConsole(CONSOLE_NAME);
		MessageConsoleStream out = myConsole.newMessageStream();
		out.println("IML2XMI:" + new Date() + ": " + message);
	}

	private MessageConsole findConsole(String name) {
		ConsolePlugin plugin = ConsolePlugin.getDefault();
		IConsoleManager conMan = plugin.getConsoleManager();
		IConsole[] existing = conMan.getConsoles();
		for (int i = 0; i < existing.length; i++)
			if (name.equals(existing[i].getName()))
				return (MessageConsole) existing[i];
		// no console found, so create a new one
		MessageConsole myConsole = new MessageConsole(name, null);
		conMan.addConsoles(new IConsole[] { myConsole });
		return myConsole;
	}

}
