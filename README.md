# Redmine Workflow Enhancements

**Warning: this is only lightly tested**

Add various enhancements to workflow editing. Currently this consists of these:

  * Visualization with dagre-d3

Planned features:

  * Ability to pre-define association between tracker and issue statues or better
	overview


Requirements:

  * Redmine 2.2 or higher
  * Ruby 1.9.3 or higher

## Installation

Installing the plugin requires these steps:

 1. **Get the plugin**

	```
	cd plugins
	git clone git://github.com/dr-itz/redmine_workflow_enhancements.git
	```

 2. **Restart Redmine**

	The second step is to restart Redmine. How this is done depends on how Redmine is
	setup. After the restart, configuration of the plugin can begin.

## Uninstallation

Uninstalling the plugin is easy as well. Basically it means removing the plugin
directory. Again, execute from withing the Redmine root directory.

 1. **Removing the plugin directory**

	```
	rm -r plugins/redmine_workflow_enhancements
	```

 2. **Restart Redmine**

	The second step is to restart Redmine. Once restarted, the plugin will be gone.

## Usage

Go to Administration -> Workflow, select a single workflow and click 'Edit'.


## License and thanks

This plugin uses a nice helper to provide a @render_super()@ method in the
views, found in a similar plugin by Tristan Harris:
https://github.com/tristanharris/workflow_viz

Since this is a Redmine plugin, Redmine is licensed under the GPLv2 and the GPL
is very clear about derived work and such, this plugin is licensed under the
same license.
