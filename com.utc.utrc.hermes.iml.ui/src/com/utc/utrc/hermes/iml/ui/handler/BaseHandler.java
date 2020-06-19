package com.utc.utrc.hermes.iml.ui.handler;

import java.util.List;

import org.eclipse.core.commands.AbstractHandler;
import org.eclipse.core.commands.ExecutionEvent;
import org.eclipse.core.resources.IProject;
import org.eclipse.core.resources.IResource;
import org.eclipse.jface.viewers.IStructuredSelection;
import org.eclipse.swt.widgets.Shell;
import org.eclipse.ui.PlatformUI;
import org.eclipse.ui.handlers.HandlerUtil;
/**
 * 
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 *
 */
public abstract class BaseHandler extends AbstractHandler {
	
	protected IProject getSelectedProject(ExecutionEvent event) {
		Object element = HandlerUtil.getCurrentStructuredSelection(event).getFirstElement();
		if (element instanceof IResource) {
			return ((IResource) element).getProject();
		} else if (element instanceof IProject) {
			return (IProject) element;
		}
		return null;
	}

	protected List<Object> getSelectedElements(ExecutionEvent event) {
		IStructuredSelection selectedBlock = HandlerUtil.getCurrentStructuredSelection(event);
		return selectedBlock.toList();
	}
	
	protected Shell getShell() {
		return PlatformUI.getWorkbench().getActiveWorkbenchWindow().getShell();
	}
}
