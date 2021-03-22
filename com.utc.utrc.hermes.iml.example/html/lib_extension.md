# Extending IML Libraries
IML comes with a set of standard libraries that include constructs for commonly used domains. Users can extend these libraries for supporting new domains or solvers. In a standard library, the user can define custom types, traits, and their related properties. End-users can then re-use these elements by importing the corresponding library. 

## Setting up an IML Custom Library
1. *Create a new eclipse plugin project or use an existing one*: `File` > `New` > `Project` and select from `Plug-in Development` > `Plug-in Project`.
1. *Create an IML package*: Under the `src` folder, create package named `iml`.
1. Write your IML library files under that package directory.
1. Each IML module package name must start with `iml.`. I.e. the first line of each library must be `package iml.<Your_library_name_here>;`
1. *Export the `iml` package*: open `META-INF` > `MANIFEST.MF` then select the `Runtime` tab. Under `Exported Packages` click `Add...`, check `Show non-Java packages`, select `iml`, then press `Add`.
1. *Contribute to the extension point*: Go to the `META-INF` > `MANIFEST.MF` then select the `Extensions` tab. Click `Add` and select `com.utc.utrc.hermes.iml.lib` extension point from the list. Under that extension point, right click and select `New` > `library`, then provide the relative library directory (i.e. `src/iml/`).
1. If you didn't find `com.utc.utrc.hermes.iml.lib` extension point in the list from previous step, you can directly add/modify `plugin.xml` by adding the following:
  ```xml
  <extension point="com.utc.utrc.hermes.iml.lib">
      <library lib_directory="src/iml/"> </library>
   </extension>
  ```

## Using the IML custom library
After setting up and defining a library as described in the previous section, users can leverage it in multiple ways. In the following sections, we describe two common methods. In both cases, the user will need to add the library as a project dependency in `META-INF` > `MANIFEST.MF` > `Dependencies`, under under `Required Plug-ins`. 

### Parsing IML file programmatically
This method is typically used in standalone applications or in testing projects (see `com.utc.utrc.hermes.iml.example.test` project for an example). Users or developer can write IML models that import a library, and the use the method `ImlParseHelper.parse(String)` from `com.utc.utrc.hermes.iml` package to load such models. This method takes care of looking at all contributions to the extension point `com.utc.utrc.hermes.iml.lib` and automatically loading their related IML files. 

### Modeling withing the Eclipse IDE
This is the preferred method to use the Eclipse IDE as IML editor. In this case, the library used must install the custom library plugin inside an Eclipse IDE instance with IML already installed, or as part of a feature. An example is to install the plugin inside the `HERMES Reasoning` eclipse product. After the custom library has been installed, users can create a new IML project (`File` > `New` > `IML` > `IML Project`), and the wizard will load the new library and make it available for building new IML models by simply importing the corresponding package.

## Generating Service classes for a custom library
Traversing and processing an IML model that uses custom libraries can be tedious. To address this issue, we provide a method to generate service classes for custom libraries. These service classes contain utility methods to easily process the IML model. For instance, you can use these classes while writing a validator or generator for your library as described in the next sections.

To generate these classes, you need to run the main method of Java class `com.utc.utrc.hermes.iml.lib.LibraryServicesGenerator` with the following arguments `<iml_library_src_folder> <output_folder>`. After running the main method, the `<out_folder>` will contain `xtend` classes (one per `.iml` file) with commonly used utility methods for processing the model. 

The generated classes have the same structure for service classes generated for IML standard libraries under `com.utc.utrc.hermes.iml.lib.gen` package. They can also be used in the same fashion by injecting them inside your custom code using the `@Inject` keyword. 