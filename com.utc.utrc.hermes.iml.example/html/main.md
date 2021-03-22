# How to extend the IML language and framework
The IML language can be extended by defining dedicated domain models. A domain model consists of two elements:

1. A standard library that defines an ontology of reusable symbols to build domain models.
2. Several tools that manipulate domain models. 

The ontology contains symbols to help end users construct models in a specific domain. For example, the library for a domain dedicated to the modeling of electric circuits would contain IML types for resitors, capcitors, and generators. Several tools can then be provided such as model validation, translation to other languages, and domain specific solvers.   

We have provided several facilities to extend the IML language using [Eclipse extension points](https://wiki.eclipse.org/FAQ_What_are_extensions_and_extension_points%3F). In particular, we provide the following extension mechanisms:

1. *Extending IML Libraries*: developers can extend the IML language by providing custom library to support specific domains.
2. *Extending IML Validators*: developers can write custom model validation rules for any IML construct or custom IML libraries as defined in the previous point. Model validation can be effectively used to restrict the class of valid models within a domain in addition to the basic rules already provided by the IML language such as typing.
3. *Extending IML Generators*: developers can write custom code generation algorithms from IML (or any library they have provided) to other languages. Generators are typically used to perform analysis or transformation of models using external tools, but they can be used in general to synthesis new models starting from IML.
4. *Extending IML Documentation*: developers can provide documentations for any of the custom extensions mentioned before.

We have provided an example project `com.utc.utrc.hermes.iml.example` and associated test project `com.utc.utrc.hermes.iml.example.test` as reference to developers who may want to implement any of the extensions mentioned above. In fact, this documentation is part of this example project for extending IML documentation.