package com.utc.utrc.hermes.iml.encoding;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.utc.utrc.hermes.iml.iml.Alias;
import com.utc.utrc.hermes.iml.iml.ConstrainedType;
import com.utc.utrc.hermes.iml.iml.Extension;
import com.utc.utrc.hermes.iml.iml.HigherOrderType;
import com.utc.utrc.hermes.iml.iml.RelationInstance;
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference;
import com.utc.utrc.hermes.iml.iml.Symbol;
import com.utc.utrc.hermes.iml.iml.SymbolDeclaration;
import com.utc.utrc.hermes.iml.util.ImlUtils;
/**
 * Encodes IML types in a way that guarantee that each unique type has a unique ID
 * This should hide the way it generates the unique id for each IML object
 *
 * @author Ayman Elkfrawy (elkfraaf@utrc.utc.com)
 * @author Gerald Wang (wangg@utrc.utc.com)
 */
public class EncodedId {
	
	private QualifiedName container;
	private String name;
	
	EObject imlObject;

	public static QualifiedName DEFAULT_CONTAINER = QualifiedName.create("__unnamed__");
	
	/**
	 * Create a unique EncoderId for each unique IML Object. The same IML type should return same EncoderID
	 * for example: {@code Int ~> Real}type declared in different symbols should return the same EncoderId (eId1.equals(eId2) is true)
	 * Current implementation uses the string of the actual type to generate unique id, for example the type {@code Int ~> Real}
	 * will generate string id with "Int~>Real"
	 * @param imlEObject
	 * @param qnp
	 */
	public EncodedId(EObject imlEObject, IQualifiedNameProvider qnp) {
		this.imlObject = imlEObject;
		if (imlEObject instanceof ConstrainedType) {
			container = qnp.getFullyQualifiedName(imlEObject.eContainer());
			name = ((Symbol) imlEObject).getName();
		} else if (imlEObject instanceof HigherOrderType) {
			// use the serialization as name 
			if (imlEObject instanceof SimpleTypeReference && ((SimpleTypeReference) imlEObject).getTypeBinding().size() == 0) {
				ConstrainedType type = ((SimpleTypeReference) imlEObject).getType();
				container = qnp.getFullyQualifiedName(type.eContainer());
				name = type.getName();
			} else {
				container = DEFAULT_CONTAINER;
//				container = qnp.getFullyQualifiedName(((SimpleTypeReference) imlEObject).getType().eContainer());					
				// Use the name exactly as declared 					
				name = ImlUtils.getTypeNameManually((HigherOrderType) imlEObject, qnp);
			}
		} else if (imlEObject instanceof RelationInstance) {
			container = qnp.getFullyQualifiedName(imlEObject.eContainer());
			if (imlEObject instanceof Alias) {
				name = "alias_" + qnp.getFullyQualifiedName(((SimpleTypeReference)((Alias)imlEObject).getTarget()).getType());
			} else if (imlEObject instanceof Extension) {
				name = "extends_" + qnp.getFullyQualifiedName(((SimpleTypeReference)((Extension)imlEObject).getTarget()).getType());
			}
		} else if (imlEObject instanceof SymbolDeclaration) {
			container = qnp.getFullyQualifiedName(imlEObject.eContainer());
			name = ((SymbolDeclaration) imlEObject).getName();
		}
	}
	
	public EObject getImlObject() {
		return imlObject;
	}

	public void setImlObject(EObject imlObject) {
		this.imlObject = imlObject;
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
