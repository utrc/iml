package com.utc.utrc.hermes.iml.generator.infra;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.google.inject.Inject;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.FolFormula;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.Model;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;

public class SrlSymbolId {

	@Inject
	IQualifiedNameProvider qnp;

	private QualifiedName container;
	private String name;

	public static QualifiedName DEFAULT_CONTAINER = QualifiedName.create("__unnamed__");
	public static String RELATION_PREFIX = "rel_";
	
	public SrlSymbolId() {
		container = DEFAULT_CONTAINER;
		name = "";
	}
	
	public SrlSymbolId(EObject imlEObject) {
		if (imlEObject == null) {
			container = DEFAULT_CONTAINER;
			name = "";
		} else {
			setId(imlEObject);
		}
	}

	public void setId(EObject imlEObject) {
		if (imlEObject instanceof Model) {
			name = "";
			container = qnp.getFullyQualifiedName(imlEObject);
		} else {
			if (imlEObject instanceof ConstrainedType || imlEObject instanceof SymbolDeclaration) {
				container = qnp.getFullyQualifiedName(imlEObject.eContainer());
				name = ((Symbol) imlEObject).getName();
			} else if (imlEObject instanceof HigherOrderType) {
				// use the serialization as name
				container = DEFAULT_CONTAINER;
				//name to be determined
			} else if (imlEObject instanceof RelationInstance) {
				// use rel_<integer position>
				ConstrainedType type = (ConstrainedType) imlEObject.eContainer() ;
				container = qnp.getFullyQualifiedName(type);
				name = RELATION_PREFIX + type.getRelations().indexOf(imlEObject);
			} else if (imlEObject instanceof FolFormula) {
				container = qnp.getFullyQualifiedName(imlEObject);
				//name to be determined
			}
		}
	}
	
	public void setContainer(EObject o) {
		container = qnp.getFullyQualifiedName(o);
	}
	public void setName(String n) {
		name = n;
	}
	
	public EObject getEObject(Model m) {

		return null;
	}


	public QualifiedName getContainer() {
		return container;
	}

	public String getName() {
		return name;
	}

	@Override
	public int hashCode() {
		return container.hashCode();
	}

	@Override
	public boolean equals(Object obj) {
		if (obj instanceof SrlSymbolId) {
			if (container.equals(((SrlSymbolId)obj).getContainer()) && name.equals(((SrlSymbolId)obj).getName())) {
				return true;
			}
		}
		return false;
	}
	
	

}
