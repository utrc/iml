package com.utc.utrc.hermes.iml.encoding;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.util.ImlUtils;
/**
 * Encodes IML types in a way that guarantee that each unique type has unique ID
 *
 */
public class EncodedId {
	
	private QualifiedName container;
	private String name;

	public static QualifiedName DEFAULT_CONTAINER = QualifiedName.create("__unnamed__");
	
	public EncodedId(EObject imlEObject, IQualifiedNameProvider qnp) {
		if (imlEObject instanceof ConstrainedType) {
			container = qnp.getFullyQualifiedName(imlEObject.eContainer());
			name = ((Symbol) imlEObject).getName();
		} else if (imlEObject instanceof HigherOrderType) {
			// use the serialization as name 
			if (imlEObject instanceof SimpleTypeReference && ((SimpleTypeReference) imlEObject).getTypeBinding().size() == 0) {
				container = qnp.getFullyQualifiedName(((SimpleTypeReference) imlEObject).getType().eContainer());
				name = ((SimpleTypeReference) imlEObject).getType().getName();
			} else {
				container = DEFAULT_CONTAINER;
//				container = qnp.getFullyQualifiedName(((SimpleTypeReference) imlEObject).getType().eContainer());					
				// Use the name exactly as declared 					
				name = ImlUtils.getTypeNameManually((HigherOrderType) imlEObject, qnp);
			}
		}
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((container == null) ? 0 : container.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof EncodedId))
			return false;
		if (!container.equals(((EncodedId) obj).getContainer()))
			return false;
		if (!name.equals(((EncodedId) obj).getName()))
			return false;
		
		return true;
	}

	public QualifiedName getContainer() {
		return container;
	}

	public void setContainer(QualifiedName container) {
		this.container = container;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
	public String stringId() {
		return (container.toString() + "." + name);
	}
	
}
