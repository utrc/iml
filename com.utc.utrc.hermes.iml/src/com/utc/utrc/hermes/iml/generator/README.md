# Notes on the generator packages

The [com.utc.utrc.hermes.iml.generator.infra.Iml2Symbolic](./infra/Iml2Symbolic.java) class
shows how the different classes can be used.

The hierarchy that is used is the following

* The [com.utc.utrc.hermes.iml.generator.infra.SrlSymbolId](./infra/SrlSymbolId.java) class is meant to be a unique id associated with symbols at the srl level. Ideally, we can generate the id in such a way that given an iml model and an SrlSymbolId, we can search for the corresponding object in the model. 
* There are three classes of symbols: SrlTypeSymbol (for constrained types and for higher order types), SrlObjectSymbol (for symbol declarations), and SrlTerm (which will be used for formulas).
* The idea is to have the srl encoding with no reference to the original model except that the id contains a name from which we can uniquely identify an object. Such name is split into a container information (which is a qualified name) and a string which represents the name. In some case (e.g., ConstrainedTypes), the name is the name of the IML object. In other cases (e.g., higher order type which do not have a name), the name is a unique string generated from the IML object properties.

The code is not complete. The most complex function in [com.utc.utrc.hermes.iml.generator.infra.Iml2Symbolic](./infra/Iml2Symbolic.java) is 

```java
public SrlHigherOrderTypeSymbol encode(HigherOrderType t) {
		//TODO
		return null;
}
```

This is really the only function that will encode additional types when needed. For this to work, we still need to have a symbol table and avoid encoding the same type multiple times.





