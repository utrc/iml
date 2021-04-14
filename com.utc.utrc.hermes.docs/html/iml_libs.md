# IML Standard Libraries

The IML package comes with a list of standard library that have been developed under the DARPA CASE program. These libraries represent some examples of how specification domains can be exposed to users within the HERMES framework. 

## Introduction
IML alone would not be an effective intermediate language as it is too fined-grained. 
Achieving a unified representation of domain models requires building standard libraries on top of
the basic language. Ultimately, IML and standard libraries together provide an
articulation point, a real intermediate representation that breaks the gap
between the design domains and the solver domains. Bridging the gap, therefore, is
partitioned into translation algorithms from design domains to IML,
transformation of models in IML towards queries to be allocated to solvers, and
finally translation of those queries (that are still expressed in IML) to the
input language of the solver of choice. A standard library needs to be designed so
that the effort to develop algorithms for these three steps is small when
compared to the development of dedicated tool-chains for each design domain.
Clearly, the second and third steps are highly reusable since the representation
of models in IML does not change across design tools. However, there is a first
cost incurred in their development that should still be minimized. Furthermore,
the development of the libraries itself is a laborious process that can be
simplified only by keeping them as simple as possible. 

Standard libraries include the definition of traits, types, function symbols,
and their definitions through expressions. The traits, types and function
symbols are meant to be reused as standard concepts in the development of a
domain model. Given the semantics of IML, a domain models will also have its
formal semantics depending on the assertions that are written in the library.
However, capturing the semantics of a design domain through axioms in IML may
become a complex task. Furthermore, the selection of the basic symbols may be
influenced by the intended semantics, resulting in domain models that are
unnecessarily complex. These additional accidental complexity may in turn impact
the complexity of translators from domain models to IML, and from IML to
backend tools. In some cases, such complexity cannot be avoided, while in other it is artificially introduced in trying to use IML as a formal documentation tool (which is not the intended use-case). Briefly, axioms should be included only if the set of solvers we foresee being good candidates to analyze a domain model does not already know them. The following guidelines expand on this brief statement.

__Case 1: Induced query class and available solvers extend towards the domain.__
If the design domain defines queries always belonging to the same problem class,
and if all potential solvers that can address such problem class already
understand the symbols in the domain, there is no need to specify the semantics
of models in IML. For example, it is common practice to use state machines to
define discrete time behaviors, and to use a synchronous language to define the
behavior of control or signal processing systems. Verification in these domains
requires a model-checker which takes a model and a property as inputs and determines
whether the model satisfies the property. Model-checkers support standard
concepts that are found in the domain model such as states and transitions, and
also support very rich property languages such as Linear Temporal Logic. Thus,
all the axioms that might be contained in a standard IML library to define the
semantics of a state machine model would not be directly translated to the input
of a model checker, but they would only be used by the developer of the
translator. In this case, the semantics is better captured in a separate
document (more understandable to humans) without impacting the usefulness of the
standard library (which will still serve the purpose of unifying any state
machine or synchronous design domain in any design tool).

**Case 2: Induced queries class and available solvers as sub-languages of IML.** If
the class of solvers that we intend to use accept queries that are
specified over a generic signature of symbols, and if we intend to use these
solvers to address problems in some specific design domains that introduce
domain specific symbols, the corresponding standard library will need to
include axiomatic definitions of the symbols which will need to be translated
from IML to the input language of the solver selected to answer a query from the
domain model. For example, consider solving a design exploration or component
selection problem using a SAT solver, or a constraint programming solver. A
standard library for the design domain would include the notion of a component
as well as dependencies among components (e.g., exclusivity constraints). While
these symbols facilitate the creation of models in that domain (and therefore
simplify the development of translator from design tools to IML), they have no
meaning at the solver level. Thus, a standard library in this case would need to
include all the necessary axioms that define the semantics of a model.

With these cases in mind, we present a few libraries that are provided with HERMES. 
Notice that users can extend the framework with additional libraries as needed.

## The ```iml.systems``` library

This library is used to define a view of a system that comprises components components, ports and connections. The following traits and types are defined in the library:

```
type Direction enum {IN, OUT, INOUT} 
trait Connectable {}
trait Port refines (Connectable) {
    direction : Direction ;
}
trait In refines (Port){
    assert {direction = Direction.IN} ;
}
trait Out refines (Port) {
    assert {direction = Direction.OUT} ;
}
trait InOut refines (Port) {
    assert {direction = Direction.INOUT} ;
}
type InPort exhibits (In);
type OutPort exhibits (Out);
type InOutPort exhibits (InOut);
trait EventCarrier<EventType> {
    event : EventType ;
}
trait DataCarrier<DataType> {
    data : DataType ;
}
type InEventPort<EventType> exhibits(In, EventCarrier<EventType>);
....   
trait Component { };

type Connector<SourceType exhibits(Connectable),
                TargetType exhibits(Connectable)> {
	source : SourceType ;
	target : TargetType ;
};

type EqualityConnector<Type exhibits(Connectable)> {
	source : Type ;
	target : Type ;
	assert {source = target} ;
};

connect<SourceType exhibits(Connectable),
        TargetType exhibits(Connectable)> : 
          (SourceType,TargetType) -> Connector<SourceType,TargetType> :=
fun(source:SourceType, target:TargetType) {
	some(c:Connector<SourceType,TargetType>){
        c.source=source && c.target=target} ;
}
;

connectEqual<Type exhibits(Connectable)> : 
  (Type,Type) -> EqualityConnector<Type> :=
    fun(source:Type, target:Type) {
	some(c:EqualityConnector<Type>){c.source=source && c.target=target} ;
    }
;

delegate<PortType exhibits(Connectable)> : 
     (PortType,PortType) -> Connector<PortType,PortType> :=
  fun(source:PortType, target:PortType) {
	some(c:Connector<PortType,PortType>){c.source=source && c.target=target} ;
  }
;
```
Input, output and bidirectional ports are defined by a hierarchy of traits that start by introducing a ```Connectable``` trait. Ports have a ```direction``` field. Event carrier ports have a ```event``` field while data carrier ports have a ```data``` filed. The library defines several types that are combination of different directions, event carriers, data carriers, and both event and data carriers. A ```Component``` trait is also defined in the library. This trait is exhibited by a type that is a component and therefore may have sub-components, ports and internal connections. ```Connectors``` are defined as types with a ```source``` and a ```target``` that are both connectable elements. A special equality connector also establishes the equality of the source and the target field. Finally, the library defines several utility functions to connect ports. Notice that this library defines its function symbols as well as assertions since it is used also in the definition of queries for SMT solvers, and those axioms are needed to ensure that the generated model maintains the semantics of connections.

***Typical usage***. This library is used for the definition of components with a finite number of typed interfaces. These interfaces are used to define the interactions with other components. This is not the only way of defining components, interfaces, and interactions. However, many design domain tools include such concepts in their models which makes this library highly reusable across domains. 

***Example***.  In this simple example, we will define three components: `A`, `B`, and `C`. There will also be two connections linking the outputs of `A` and `B`, to the inputs of `C`. Furthermore, `C` can be implemented in several ways and should really be defined just as an interface. The system that instantiates and connects these components should be independent of the chosen implementation. Finally, for the sake of this example, we will use data types that resemble measurements from sensors including values and time stamps. 

First, let's define some useful types:

```
type Measurement<T> {
	value : T ;
	time : TimeStamp ; 
}
type CheckedMeasurement<T> includes(Measurement<T>){
	valid : Bool ;
}
```

The ```Measurement``` type is parametric as the actual type of the value associated with a measurement should be flexible (e.g., could be an integer or a real number, or any other type). A ```CheckedMeasurement``` includes a measurement and adds an extra field that specifies its validity. The ```TimeStamp``` type can be implemented in several ways, but it is outside the scope of this example.

The definition of components `A` and `B` is as follows:

```
type A exhibits(Component) {
	output : OutDataPort<Measurement<Real>> ;
	/*This component could have a physical input and the rest of its 
	 * description could include the relation between the physical quantity and
	 * the measured quantity in the form of an assertion 
	 */
}

type B exhibits(Component) {
	output : OutDataPort<Measurement<Real>> ;
	/*This component could have a physical input and the rest of its 
	 * description could include the relation between the physical quantity and
	 * the measured quantity in the form of an assertion 
	 */
}
```

These components have output data ports. They carry a datum which is a measurement represented as a real value. 

> Notice that the IML language and the ```iml.systems``` library do not provide any special semantics to the data carried by the ports. In this example, an instance of component ```A``` or ```B``` defines an instance of a port that carries an instance of a measurement as data. This model can still be useful to capture a snapshot of a system at a specific point in time and check perhaps some system level invariants. However, the user might be interested in a model where the inputs and outputs of a component are semantically defined as discrete time waveforms. In this case, output ports would have type
>
>```outDataPort< Int -> Measurement<Real> >```

For component `C`, we define an interface that can be redefined depending on the implementation:

```
trait C refines(Component) {
	input1 : InDataPort<Measurement<Real>> ;
	input2 : InDataPort<Measurement<Real>> ;
	output : OutDataPort<CheckedMeasurement<Real>>;
}
```

This trait defines the interfaces of the component. To define an implementation, users can simply define a type that exhibits a trait of being ```C```:

```
type Cimpl1 exhibits(C) {
	assert {  
		if ( input1.data.value = input2.data.value && 
			input1.data.time = input2.data.time) {
				output.data.value = input1.data.value &&
				output.data.time = input1.data.time &&
				output.data.valid = true
		} else {
			output.data.time = input1.data.time &&
			output.data.valid = false 
		}
	} ;
}
```

Component ```Cimpl1``` is a specific implementation where the output is a valid measurement only if the two inputs carry exactly the same value and timestamp. Otherwise, the measurement is considered invalid. Of course, many other implementations are possible, but they would all have to comply with the interface defined by ```C```.

Finally, these components can be interconnected into a higher-level component as follows:

```
type A_B_C<Cimpl exhibits(C)> exhibits(Component) {
	output : OutDataPort<CheckedMeasurement<Real>>;
	a : A ;
	b : B ;
	c : Cimpl ;
	a_c : Connector<OutDataPort<Measurement<Real>>, //Source type
					InDataPort<Measurement<Real>>> := //Target type
		connect<OutDataPort<Measurement<Real>>, 
					InDataPort<Measurement<Real>>>(a.output, c.input1) ;
	b_c : Connector<OutDataPort<Measurement<Real>>, //Source type
					InDataPort<Measurement<Real>>> := //Target type
		connect<OutDataPort<Measurement<Real>>, 
					InDataPort<Measurement<Real>>>(b.output, c.input1) ;
	c_out : Connector<OutDataPort<CheckedMeasurement<Real>>,
					  OutDataPort<CheckedMeasurement<Real>>> :=
		delegate<OutDataPort<CheckedMeasurement<Real>>>(c.output,output) ;					
}
```

The high-level component ```A_B_C``` is a parametric one. The type parameter is the specific implementation of ```C```. It includes an instance of ```A```, and instance of ```B```, and an instance of the chosen implementation of ```C```, and three connectors (from ```a``` to ```c```, from ```b``` to ```c``` and from the output of ```c``` to the output of the top-level component). 

> Notice that there are other ways to define component instances and connectors. For example, the connection between ```a.output``` and ```c.input1``` could be represented by an assertion ```assert{a.output = c.input1}```. Using assertions could be semantically correct and may not have an impact on the analysis to be carried out on the model. However, compiling connectors into assertion destroys the structure of the model. This is the reason why the library offers both the ```Connector``` type and the ```connect``` function. The structure of the system is in fact preserved, and recovering such structure can be done by simple syntactic analysis. 

Finally, an instance of the new component can be defined by binding a specific implementation for ```C```:

```
top : A_B_C<Cimpl1> ;
```



## The ```iml.contracts``` library

This library defines a single trait that a contract-based specification should exhibit. The main trait is the following:
```
trait Contract {
	assumption : Bool ;
	guarantee : Bool ;	
	contract : Bool ;
	assert {contract = (assumption => guarantee)};
} ;
```
The ```Contract``` trait includes three symbols which are called ```assumption```, ```guarantee```, and ```contract```, and that are all of type ```Bool```. The assumption and the guarantee are not defined by the trait. They will need to be defined by types that exhibit this trait. Their definition is a formula that involves symbols defined in the type such as input and output ports. 

>Notice that the user of this library is supposed to re-define the ```assumption``` and ```guarantee``` symbols. It is of course possible to define intermediate symbols to split the definition of assumptions and guarantees over multiple formulas as described in the following example.

***Example***. The following simple example shows how the ```Contract``` trait can be used:
```
type Node exhibits(Contract){
	incoming : Int ;
	outgoing : Int ;
	
	assumption1 : Bool := incoming > -10 && incoming < 10 ;
	assumption2 : Bool := incoming != 0 ;
	
	assumption : Bool := assumption1 && assumption2;
	
	guarantee : Bool := outgoing > incoming ;
}
```
The ```Node``` type has two variables that define the context over which assumptions and guarantees are expressed. The assumption is divided into two formulas ```assumption1``` and ```assumption2```. 

Another description of the same node uses a combination of both ports and contracts as follows:

```
type Node1 exhibits(Component,Contract){
	incoming : InDataPort<Int> ;
	outgoing : OutDataPort<Int> ;
	
	assumption1 : Bool := incoming.data > -10 && incoming.data < 10 ;
	assumption2 : Bool := incoming.data != 0 ;
	
	assumption : Bool := assumption1 && assumption2;
	
	guarantee : Bool := outgoing.data > incoming.data ;
}
```
This example shows how multiple traits can be combined to model systems with a combination of different views. In this case, the ```Node``` type is structurally modeled as a component with and input and an output port. In addition, the component is characterized by a contract.

>Notice that endowing a type with some traits serves different purposes. The type essentially inherits symbols and constraints. At the same time, traits provide indications on how fragments of a model (such as a type) should be processed by analysis tools or code generators.  


## The ```iml.synchdf.ontological``` library

This library helps users in modeling synchronous data flow systems. We opted for a shallow approach in the definition of the library that defines symbols used to define models, but not the full semantics associated with them. The reason is that the semantics of such symbols is well understood by the available solvers such as Kind2, JKind or Sally. If developers were interested in targeting other solvers, they would need to define a new library (perhaps called ```iml.synchdf.semantic```) which includes the necessary axioms to define the semantics of the library. 

>In principle, a synchronous component maps input streams to output stream. A library for these types of systems, therefore, could start by defining streams and operations over streams:
>```
>type Stream<T> is Int -> T;
>type RealStream is Int->Real;
>type IntStream is Int->Int;
>type BoolStream is Int->Bool;
>pre<T> : Stream<T> -> Stream<T> := 
>	fun(x:Stream<T>){ 
>		some(y:Stream<T>){ 
>			forall(i:Int){
>				y(i) = x(i-1)
>			}
>		} ;
>	};
>```
>In this example, we have modeled a ```Stream``` polymorphic type which is a function form the discrete time domain to the type of the stream. We have also defined the ```pre``` function that maps a stream into a shifted version of the stream. Similarly, it is possible to define other operators and eventually a fully axiomatized library.

We have defined the following library of symbols for synchronous data flow models:

```
annotation LocalVar  ;
annotation OutputVar ; 

trait Synchronous {}
pre<T> : T -> T ;
init<T> : (T,T) -> T ;
current<T> : (T,T) -> T ;
when<T> : (T,T) -> T ;
```

The library defines a trait that is used to endow a type with synchronous semantics. This trait is needed because the interpretation of the types of symbols defined within the scope of the trait would need to be lifted to streams. For example, a symbol of type ```Int``` defined in a type that exhibits the ```Synchronous``` trait should be interpreted as a synchronous stream of integers. Typical operators over streams are also defined int his library such as ```pre``` which delays a stream, ```init``` which initialized a stream, and others that are defined by the [Lustre language](https://www-verimag.imag.fr/The-Lustre-Programming-Language-and).

The library also defines annotations for local and output variables. These annotations are need to build models that do not rely on the ```iml.systems``` library, but where such structural information must be retained. 

***Example***.  We model a typical counter (see [this tutorial](http://cedric.cnam.fr/~crolardt/enseignement/SMB204/tutorial.pdf)). The counter can be modeled as a type as follows: 

```
type CounterWithAnnotations exhibits(Synchronous) {
	//Inputs
	i : Int ;
	incr : Int ;
	X : Bool ;
	reset : Bool ;
	//Outputs
	[OutputVar] C : Int ;
	//Local Variable
	[LocalVar] PC : Int ; 
	//Constraints
	assert { 
		PC = init<Int>(i, pre<Int>(C)) &&
		C = if (reset) {i} 
	           else { 
	           		if (X) {PC + incr} 
	           		else {PC}
			   } ;
	} ;
}
```

The fields defined in this type are the inputs, the outputs, and the local variables. The constraints are captured by assertions. In this case, the ```PC``` variable should be interpreted as a stream which is initialized by the input ```i```, and that follows as a shifted version of ```C``` (this essentially means that at each point in time, ```PC``` holds the previous value of ```C```, except at time 0 where the value of ```C``` is the value of ```i``` at time 0). When the counter is ```reset```, then the value of ```C``` is ```i```, otherwise, if the counter is asked to increment (i.e., ```X``` is equal to true), then the value of ```C``` is its previous value plus the increment, otherwise it is kept constant.

This type can be instantiated into another synchronous systems as follows:

```
type TopWithAnnotations exhibits(Synchronous) {
	oddCounter : CounterWithAnnotations :=
		some (c : CounterWithAnnotations) {
			c.i = 1 &&
			c.incr = 2 &&
			c.X = true &&
			c.reset = init<Bool>(true,false);
		};
	[OutputVar] oddNumbers : Int := oddCounter.C;
}
```

The ```TopWithAnnotations``` synchronous component includes a sub-component which is called ```oddCounter``` and that is instantiated using an instance constructor which is provided by the IML language. The ```TopWithAnnotations``` output should be interpreted as the sequence of odd numbers.

This library can be used in conjunction with other libraries. The following example shows how the counter can be modeled as a ```Component```:

```
type Counter exhibits(Component,Synchronous) {
	//Inputs
	i : InDataPort<Int> ;
	incr : InDataPort<Int>  ;
	X : InDataPort<Bool>  ;
	reset : InDataPort<Bool>  ;
	//Outputs
	C : OutDataPort<Int> ;
	//Local Variable
	PC : Int ; 
	//Constraints
	assert { 
		PC = init<Int>(i.data, pre<Int>(C.data)) &&
		C.data = if (reset.data) {i.data} 
	           else { 
	           		if (X.data) {PC + incr.data} 
	           		else {PC}
			   } ;
	} ;
}
```

In this case, inputs and outputs are represented structurally as ports using the ontology offered by ```iml.systems```. The constraints do not change much other than having to consider the ```data``` field of a port. Fields of the component type are not considered local. 


## The ```iml.sm``` library

For state machines, we have provided a full definition of the semantics of a transition, of traces, and of properties expressed in Linear Temporal Logic. 

>Notice that there could be several types of model checkers and analysis tools for state machines. Most of these tools see a state machine as a predicate that defines the set of possible initial states, and a predicate that defines the transition function. The semantics of the execution of a state machine is known to these tools and there is in principle no need to provide axioms that defines it. We provide this library as an example of the expressive power of the IML language. 

The library defines the structural elements of a state machine as the following trait:

```
trait StateMachine<S> {
    init : S->Bool ;
    transition : (S,S)->Bool ;
}
```

The type parameter ```S``` is the type of the state of the machine (such as a vector of bits, a categorical type, or any other module type). The trait contains a predicate ```init``` which defines possible initial states, and a relation ```transition``` between a state and its possible successors. The trait does not define any interpretation for these predicates. 

A valid transition of a state machine is defined as follows:

```
trait ValidTransition<S> refines(StateMachine<S>) {
    time : Int ;
    state : S ;
    next : S ;
    assert { time = 0 => init(state)} ;
    assert { transition(state,next)};
}
```

A valid transition has a ```time``` index (i.e., it occurs at a certain time in a trace of transitions), has a starting ```state```, and lands in a successor state ```next```. It is required that, if the transition is the first to occur in a trace, the starting state is an initial state, and that the pair (```state```, ```next```) is in the transition relation. While the ```StateMachine``` trait defines the set of possible initial states and the valid transitions from one state to another, the ```ValidTransition``` trait defines a valid transition within an ordered execution of reactions defined as follows:

```
type Execution<S, T exhibits(ValidTransition<S>)> is Int->T ;
assert { 
    forall<S,T exhibits(ValidTransition<S>)>(x:Execution<S,T>, i:Int){ 
        (x(i+1).time = x(i).time + 1) && (x(i+1).state = x(i).next) ;
    }
} ;
```

An execution is a function that maps time indices to transitions. The set of valid executions (i.e., the possible instances of such function type), are defined by an assertion that simply states that time advances one step at the time, and that the ```next``` state of a valid transition is the initial state of the subsequent one. Finally, given a valid execution, the corresponding trace of states is defined as follows:

```
stateTrace<S, T exhibits(ValidTransition<S>)> : Execution<S,T> -> Trace<S> := 
    fun ( x : Execution<S,T> ) {
        fun(i : Int){
            x(i).state ;
        }
    } ;
```

This library, which we use as reference library for specifying state machine components, precisely defines the allowed behavior of a state machine. Notice that the user of this library will define her own models which will inherit the properties and restrictions of the traits they will use.

***Example***. A user of the library can use the traits to define a component that behaves as a state machine. Towards this goal, the user should use the ```ValidTransition``` trait to model the one-step execution of the state machine. For example, consider the following model:

```
type RespondsState  enum { s0 , s1 , s2 } ;

type responds_once exhibits(Component, ValidTransition<RespondsState>) {
  a : InDataPort<Bool> ;
  b : InDataPort<Bool> ;
  init : RespondsState -> Bool := 
    fun(x:RespondsState) : Bool { x = RespondsState.s0 }; 
  transition : (RespondsState,RespondsState)->Bool := 
    fun(x:RespondsState, y:RespondsState) : Bool{ 
      y = case {
            x = RespondsState.s0 && b.data && !a.data :  RespondsState.s1 ;
            x = RespondsState.s0 && a.data :  RespondsState.s2 ;
            x = RespondsState.s1 && a.data : RespondsState.s0 ;
            true : x ;
        }	   
    } ;
  holds : OutDataPort<Bool> := 
    some(x:OutDataPort<Bool>) { 
      x.data = (state = RespondsState.s0 ||  state = RespondsState.s1) 
    };
}
```

Type ```responds_once``` defines a ```ValidTransition``` of a component with inputs ```a``` and ```b```, and output ```holds```. Notice that the transition relation also depends on the local inputs. The valid executions of this state machine must satisfy the constraints defined in the library. 


