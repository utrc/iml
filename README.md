# Introduction

# Reserved key-words

package

import

meta

type

finite

forall

exists

True

False

this

if

else

var

# Mathematical and Logical Operators

Addition: +

Subtraction: -

Multiplication: *

Division: /

Modulo: %, mod

And: &&

Or: ||

Implication: =>

Double Implication: <=>

Not: !


# Structure of an IML file

```java
package packageName;
import ClassNameToImport; 

type TypeName {
  variableName : int;
  typeName: TypeName;
  
  functionName(parameterName1: ParameterType1, ..., parameterNameN: ParameterTypeN) := {
    //Function Declaration
  };
  
  formulaName : Bool := (
  //Formula Declaration
  );
  

  // This is a comment
  /* This is a comment too */
  /* This is a
     multiline
     comment */
}
```

# Accessing type elements
Internal elements of a type can be accessed with . 


```java
type TypeWithElement {
  element : A;
}

accessTheElement : A = TypeWithElement.element;
```


# Functions and Programs

The following is an example of a type that implements a list. The type has two
elements head and tail and one function push that adds the new element x to a list.

```java
type List<type T>{
	head : T;
	tail : List<T>;
	
	push(x : T, l : List<T>) : List<T> := {
		var ret : List<T> := {head = x; tail = l;};
	};
}
```