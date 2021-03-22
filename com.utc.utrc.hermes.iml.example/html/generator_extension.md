# Extending IML Generators

A generator is a tool that converts an IML model into another model. This is typically used to encode IML models into a target format used by a solver. For example, the `com.utc.utrc.hermes.iml.gen.smt` plugin project contains a generator from IML to SMT-Lib that enables formal analysis by a variety of solvers such as Z3 and CVC4. 

## Setting up custom IML Generators
1. *Create a new eclipse plugin project or use an existing one*: `File` > `New` > `Project` and select from `Plug-in Development` > `Plug-in Project`.
1. *Create a generator class*: create a Java or Xtend class that implements `com.utc.utrc.hermes.iml.gen.common.IImlGenerator` interface.
1. *Contribute to the extension point*: open `META-INF` > `MANIFEST.MF`, then select the `Extensions` tab. Click `Add` and select `com.utc.utrc.hermes.iml.gen` extension point from the list. Under that extension point, right click and select `New` > `generator` then provide the fully qualified name for the generator class.
1. If you didn't find `com.utc.utrc.hermes.iml.gen` extension point in the list from previous step, you can directly add/modify `plugin.xml` by adding the following (change the class value to your generator class):
  ```xml
  <extension point="com.utc.utrc.hermes.iml.gen">
      <generator class="com.utc.utrc.hermes.iml.example.generator.ExampleGenerator"> </generator>
   </extension>
  ```
## Implementing custom generators
As mentioned in the previous section, any custom generator should implement `IImlGenerator` interface. This interface defines the following API that needs to be implemented:
1. `canGenerate(Symbol query): boolean`: users need to implement this method to determine if a given symbol can be handled by this generator or not. Typically, the user would check the symbol type or some properties on the symbol to determine that.
1. `generate(): ImlGeneratorResult`: the user should implement this method for generating compatible symbols into target model. The result of this method should be an object of `ImlGeneratorResult` class which is defined below.
1. `canRunSolver(): boolean`: this method should return true if the generator can run a solver over the generated model.
1. `runSolver(String generatedModel): String`: if the generator support running a solver, this method should be implemented to run the solver over a generated model. The return of this method String as the result from the solver.

As stated earlier, the result of `generate()` method is an object of `ImlGeneratorResult`. Such object should be created and maintained during the generation of the model. While generating new elements, the user should use `addMapping(String originalName, String generatedName)` method to map the generated element name with the original name from IML. This can be used later by calling `getOriginalNameOf(String generatedName)` or `getGeneratedNameOf(String originalName)` to get the corresponding mapped name. Maintaining such map is important when providing an explanation to the end user where the result should in term of the original model names and not in the generated names.

At the end of the model generation, the user need to set the actual generated model as String using `setGeneratedModel(String generatedModel): void`.

## Using custom generator