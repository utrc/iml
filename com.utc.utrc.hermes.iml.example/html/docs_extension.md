# Extending the IML Documentation

Extending the IML documentation is a good place for documenting any of the custom extensions that users might have. For example, the user can create a help extension to describe a custom library and how an end user can use such library. All these contributions to the documentation are created using the method described below and can be found under the example extension project `com.utc.utrc.hermes.iml.example`. 

## Setting up a documentation project
1. *Create a new eclipse plugin project or use an existing one*: `File` > `New` > `Project` and select from `Plug-in Development` > `Plug-in Project`.
1. *Create Table Of Content (TOC) file*: inside the main project directory, create `toc.xml` file.
1. *Contribute to the extension point*: Go to the `META-INF` > `MANIFEST.MF` then select `Extensions` tab. Click `Add` and select `"org.eclipse.help.toc"` extension point from the list. Under that extension point, right click and select `New` > `toc` then provide the name of the `toc.xml` file and set `primary` to `true`.

## Writing the documentation
After setting up the documentation project as in the previous section, you will need to change the `toc.xml` file to provide the layout of your documentation menu and files. The main outline for the `toc.xml` file should be as follows:
```xml
<toc label=""  link_to="../com.utc.utrc.hermes.docs/toc.xml#extensions">
	<topic label="[MAIN_PAGE_MENU_LABEL]" href="[MAIN_PAGE.html]">
	   <topic label="[SUBPAGE_1_MENU_LABEL]" href="[SUBPAGE_1.html]"> </topic>
	   <topic label="[SUBPAGE_2_MENU_LABEL]" href="[SUBPAGE_2.html]"> </topic>
	</topic>
</toc>
```
The `link_to` reference to `../com.utc.utrc.hermes.docs/toc.xml#extensions` will place the  custom documentation under the main `HERMES Documentation` menu. Although the user can choose the most suitable method to generate the HTML file for the different topics, we recommend the following method:
1. Create a directory called `html` which will contains markdown (`.md`) files for each topic.
1. Generate the HTML files from `.md` files using tools like `GFM Viewer` here: [https://github.com/satyagraha/gfm_viewer]. After installing that tool, right-click on the `html` folder and press `Generate Markdown Preview`. This feature requires internet access.
1. For each markdown file, the `GFM Viewer` tool will generate an `.html` file with name `.[original_file_name].md.html`. This name can be used inside the `href` property as in `href=".main.md.html"`.

## Using custom documentation
Custom extension documentation can be used by installing the plugin in an Eclipse IDE or an Eclipse custom product. The documentation can be accessed through the `Help` menu, under `Help Contents`. If the standard IML documentation is already installed (`com.utc.utrc.hermes.docs`), the contributed documentation will be found under the `HERMES Documentation` section.