# Extending IML Generators

Generator is a tool that converts an IML model into other model. This typically used to encode IML models into a target format of solver to use. For example, encoding IML into SMT-Lib (look at `com.utc.utrc.hermes.iml.gen.smt` plugin project) for SMT solvers such as Z3 and CVC4. 

## Setting up custom IML Generator
1. *Create new eclipse plugin project or use an existing one*: `File` > `New` > `Project` and select from `Plug-in Development` > `Plug-in Project`.
1. *Create generator class*: create normal Java or Xtend class that implements `com.utc.utrc.hermes.iml.gen.common.IImlGenerator` interface.
1. *Contribute to the extension point*: Go to the `META-INF` > `MANIFEST.MF` then select `Extensions` tab. Click `Add` and select `com.utc.utrc.hermes.iml.gen` extension point from the list. Under that extension point, right click and click `New` > `generator` then provide the fully qualified name for the generator class.
1. If you didn't find `com.utc.utrc.hermes.iml.gen` extension point in the list from previous step, you can directly add/modify `plugin.xml` by adding the following (change the class value to your validator class):
  ```xml
  <extension point="com.utc.utrc.hermes.iml.gen">
      <generator class="com.utc.utrc.hermes.iml.example.generator.ExampleGenerator"> </generator>
   </extension>
  ```
## Implementing custom generator
As mentioned in the previous section, any custom generators should implement `IImlGenerator` interface. This interface defines the following API that need to be implemented:
1. `canGenerate(Symbol query): boolean`: user need to implement this method to determine if a given symbol can be used this generator or not. Typically, the user would check the symbol type or some properties on the symbol to determine that.
1. `generate(): ImlGeneratorResult`: the user should implement this method for generating compatible symbols into target model. The result of this method should be an object of `ImlGeneratorResult` class which is defined below.
1. `canRunSolver(): boolean`: this method should return true if the generator can run a solver over the generated model.
1. `runSolver(String generatedModel): String`: if the generator support running a solver, this method should be implemented to run the solver over a generated model. The return of this method String as the result from the solver.

As stated earlier, the result of `generate()` method is an object of `ImlGeneratorResult`. Such object should be created and maintained during the generation of the model. While generating new elements, the user should use `addMapping(String originalName, String generatedName)` method to map the generated element name with the original name from IML. This can be used later by calling `getOriginalNameOf(String generatedName)` or `getGeneratedNameOf(String originalName)` to get the corresponding mapped name. Maintaining such map is important when providing an explanation to the end user where the result should in term of the original model names and not in the generated names.

At the end of the model generation, the user need to set the actual generated model as String using `setGeneratedModel(String generatedModel): void`.

## Using custom generator