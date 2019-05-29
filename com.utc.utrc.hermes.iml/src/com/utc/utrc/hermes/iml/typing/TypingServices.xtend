/*
 * Copyright (c) 2019 United Technologies Corporation. All rights reserved.
 * See License.txt in the project root directory for license information. */
package com.utc.utrc.hermes.iml.typing

import com.utc.utrc.hermes.iml.custom.ImlCustomFactory
import com.utc.utrc.hermes.iml.iml.Alias
import com.utc.utrc.hermes.iml.iml.ArrayType
import com.utc.utrc.hermes.iml.iml.FunctionType
import com.utc.utrc.hermes.iml.iml.ImlType
import com.utc.utrc.hermes.iml.iml.NamedType
import com.utc.utrc.hermes.iml.iml.PropertyList
import com.utc.utrc.hermes.iml.iml.SimpleTypeReference
import com.utc.utrc.hermes.iml.iml.TraitExhibition
import com.utc.utrc.hermes.iml.iml.TupleType
import java.util.ArrayList
import java.util.List
import org.eclipse.emf.ecore.EObject
import org.eclipse.emf.ecore.util.EcoreUtil
import com.google.inject.Inject
import com.utc.utrc.hermes.iml.lib.ImlStdLib
import com.utc.utrc.hermes.iml.iml.SelfType
import com.utc.utrc.hermes.iml.iml.RecordType
import com.utc.utrc.hermes.iml.util.ImlUtil
import com.utc.utrc.hermes.iml.iml.ImlFactory
import com.utc.utrc.hermes.iml.iml.Inclusion
import org.eclipse.xtext.EcoreUtil2

class TypingServices {
	
	@Inject
	extension ImlStdLib
	
	def <T extends EObject> T clone(T eObject) {
	  	return EcoreUtil.copy(eObject)
	}
	
	def boolean isEqual(ImlType left, ImlType right) {
		// We almost always wants to resolve aliases
		return isEqual(normalizeType(left), normalizeType(right), false);
	}

	/**
	 * Check whether two type are the same or at least are compatible if compatiblityCheck was true
	 */
	def boolean isEqual(ImlType left, ImlType right, boolean compatibilityCheck) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
		}
				
		if (left instanceof TupleType && (left as TupleType).types.size == 1) {
			return isEqual((left as TupleType).types.get(0), right, compatibilityCheck)
		}
		
		if (right instanceof TupleType && (right as TupleType).types.size == 1) {
			return isEqual(left, (right as TupleType).types.get(0), compatibilityCheck)
		}
		
		if (left.class != right.class) {
			return false
		}
		
		if (left instanceof RecordType) {
			if (!isEqual(left as RecordType, right as RecordType, compatibilityCheck)) {
				return false
			}
		}

		if (left instanceof SimpleTypeReference) {
			if (!isEqual(left as SimpleTypeReference, right as SimpleTypeReference, compatibilityCheck)) {
				return false
			}
		}

		if (left instanceof ArrayType) {
			if (!isEqual(left as ArrayType, right as ArrayType, compatibilityCheck)) {
				return false
			}
		}

		if (left instanceof TupleType) {
			if (!isEqual(left as TupleType, right as TupleType, compatibilityCheck)) {
				return false
			}
		}
		
		if (left instanceof FunctionType) {
			if (!isEqual(left.domain, (right as FunctionType).domain, compatibilityCheck)) {
				return false
			}
	
			if (!isEqual(left.range, (right as FunctionType).range, compatibilityCheck)) {
				return false
			}
		}

		return true
	}

	/* Check whether two type references are the same */
	def boolean isEqual(ArrayType left, ArrayType right, boolean compatibilityCheck) {
		if (left === null && right === null) {
			return true
		} else if (left === null || right === null) {
			return false
		}

		if (!isEqual(left.type, right.type, compatibilityCheck)) {
			return false
		}

		if (left.dimensions.size != right.dimensions.size) {
			return false
		}

		return true
	}

	def boolean isEqual(TupleType left, TupleType right, boolean compatibilityCheck) {
		if (left.types.length != right.types.length) {
			return false
		} else {
			for (i : 0 ..< left.types.length) {
				if (!isEqual(left.types.get(i), right.types.get(i), compatibilityCheck)) {
					return false
				}
			}
		}
		return true
	}
	
	def boolean isEqual(RecordType left, RecordType right, boolean compatibilityCheck) {
		if (left.symbols.length != right.symbols.length) {
			return false
		} else {
			for (leftSymbol : left.symbols) {
				var found = false
				for (rightSymbol : right.symbols) {
					if (leftSymbol.name == rightSymbol.name && isEqual(leftSymbol.type, rightSymbol.type, compatibilityCheck)) {
						found = true
					}
				}
				if (found == false) {
					return false;
				}
			}
		}
		return true
	}

	//TODO Equal means that the definitions are also equal
	def boolean isEqual(PropertyList left, PropertyList right, boolean compatibilityCheck) {
		if (left.properties.size != right.properties.size) {
			return false;
		}

		for (i : 0 ..< left.properties.size) {
			if (! isEqual(left.properties.get(i).ref, right.properties.get(i).ref, compatibilityCheck)) {
				return false
			}
		}

		return true
	}

	/* Check whether two type references are the same */
	def boolean isEqual(SimpleTypeReference left, SimpleTypeReference right, boolean compatibilityCheck) {
		// Check pre condition for primitives
		if (compatibilityCheck) {
			if (left.isNumeric && right.isNumeric) {
				if (left.isReal || (left.isInt && right.isInt)) {
					return true;
				}
			}
			if (right.allSuperTypes.flatten.exists[isEqual(it, left)]) {
				return true; // Found compatible super type
			}
		}
		
		if (left.isPrimitive || right.isPrimitive) {
			return left.type.name.equals(right.type.name)
		}
		
		if (!left.type.isEqual(right.type)) {
			return false
		} else if (left.typeBinding.size != right.typeBinding.size) {
			return false
		} else {
			for (i : 0 ..< left.typeBinding.size) {
				if (! left.typeBinding.get(i).isEqual(right.typeBinding.get(i), compatibilityCheck)) {
					return false
				}
			}
		}
		return true
	}

	// Checks whether two types are equal
	def boolean isEqual(NamedType left, NamedType right) {
		if (left == right)
			return true;
		return false;
	}

	/* Compute all super types of a ContrainedType  */
	def getAllSuperTypes(NamedType nt) {
		getSuperTypes(ImlCustomFactory.INST.createSimpleTypeReference(nt)).map[it.map[it.type]]
	}

	/* Compute all super type references of a TypeReference */
	def getAllSuperTypes(ImlType imlType) {
		if (imlType instanceof SimpleTypeReference) {
			return getSuperTypes(imlType)
		} else {
			return new ArrayList<List<SimpleTypeReference>>()
		}
	}

	def getSuperTypes(SimpleTypeReference tf) {
		val closed = <NamedType>newArrayList()
		val retVal = new ArrayList<List<SimpleTypeReference>>()
		retVal.add(new ArrayList<SimpleTypeReference>());
		retVal.get(0).add(tf); // A type is a super type of itself
		var index = 0;
		while (retVal.get(index).size() > 0) {
			val toAdd = <SimpleTypeReference>newArrayList();
			for (current : retVal.get(index)) {
				val ctype = current.type
				if (ctype.relations !== null) {
					for (rel : ctype.relations.filter(Inclusion)) {
						for(twp : rel.inclusions){
							if (twp.type instanceof SimpleTypeReference) {
								if (! closed.contains((twp.type as SimpleTypeReference).type)) {
									toAdd.add(twp.type as SimpleTypeReference)
								}
							}
						}
						
					}
					for (rel : ctype.relations.filter(Alias)) {
						if (rel.type.type instanceof SimpleTypeReference) {
							if (! closed.contains((rel.type.type as SimpleTypeReference).type)) {
								toAdd.add(rel.type.type as SimpleTypeReference)
							}
						}
					}
					for (rel : ctype.relations.filter(TraitExhibition)) {
						for(twp : rel.exhibitions){
							if (twp.type instanceof SimpleTypeReference) {
								if (! closed.contains((twp.type as SimpleTypeReference).type)) {
									toAdd.add(twp.type as SimpleTypeReference)
								}
							}
						}
						
					}
				}

				closed.add(current.type)
			}
			if (toAdd.size() > 0) {
				retVal.add(toAdd)
				index = index + 1
			} else {
				return retVal;
			}
		}
		return retVal
	}
	
	def ImlType accessArray(ArrayType type, int dim) {
		if (dim == type.dimensions.size) {
			return type.type
		} else {
			var ret = ImlFactory::eINSTANCE.createArrayType();
			// TODO We are not cloning the property list here
			ret.type = clone(type.type);

			for (i : 0 ..< (type.dimensions.size() - dim)) {
				// TODO : Should we clone the term expressions?
				ret.dimensions.add(ImlFactory::eINSTANCE.createOptionalTermExpr => [
					term = ImlFactory::eINSTANCE.createNumberLiteral => [value = 0];
				])
			}
			return ret
		}
	}
	

	/* Check if two types are compatible or not
	 * */
	def boolean isCompatible(ImlType expected, ImlType actual) {
		return isEqual(normalizeType(expected), normalizeType(actual), true)
	}

	def getAliasType(NamedType type) {
		getAliasType(ImlCustomFactory.INST.createSimpleTypeReference(type))
	}
	
	def ImlType getAliasType(SimpleTypeReference r) {
		if (ImlUtil.isAlias(r)){
			var alias = r.type.relations.filter(Alias).get(0).type.type
			val env = new TypingEnvironment(r)
			return env.bind(alias)
		}
		return r // if it is not alias return the original type
	}

	/**
	 * Normalize type by resolving aliases and Self type in case a container was provided
	 */
	def ImlType normalizeType(ImlType type) {
		if (type instanceof SimpleTypeReference) {
			if (ImlUtil.isAlias(type)) {
				return normalizeType(getAliasType(type))
			} else {
				return clone(type)
			}
		}
		if (type instanceof SelfType) {
			if (EcoreUtil2.getContainerOfType(type, NamedType) !== null) {
				return ImlCustomFactory.INST.createSimpleTypeReference(EcoreUtil2.getContainerOfType(type, NamedType))
			} else {
				return type
			}
		}
		if (type instanceof TupleType) {
			return ImlCustomFactory.INST.createTupleType(type.types.map[normalizeType(it)])
		}
		if (type instanceof RecordType) {
			return ImlCustomFactory.INST.createRecordType => [
				it.symbols.addAll(type.symbols.map[
					ImlCustomFactory.INST.createSymbolDeclaration(it.name, normalizeType(it.type))	
				])
			]
		}
		if (type instanceof ArrayType) {
			return ImlCustomFactory.INST.createArrayType => [
				it.type = normalizeType(type.type)
				it.dimensions.addAll(type.dimensions.map[ImlCustomFactory.INST.createOptionalTermExpr])
			]
		}
		if (type instanceof FunctionType) {
			return ImlCustomFactory.INST.createFunctionType => [
				domain = normalizeType(type.domain)
				range = normalizeType(type.range)
			]
		}
	}
	
}
