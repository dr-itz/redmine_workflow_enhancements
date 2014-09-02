# Redmine Workflow Enhancements

**Warning: this is only lightly tested**

Add various enhancements to workflow editing. Currently this consists of these:

  * Visualization with dagre-d3:

	* Workflow edit
	* Tracker edit
	* Issue edit (behind the little question mark next to "Issue Status")

Planned features:

  * Ability to pre-define association between tracker and issue statuses for
	better overview.


Requirements:

  * Redmine 2.2 or higher
  * Ruby 1.9.3 or higher

## Installation

Installing the plugin requires these steps. From within the Redmine root
directory:

 1. **Get the plugin**

	```
	cd plugins
	git clone git://github.com/dr-itz/redmine_workflow_enhancements.git
	```
 2. **Run bundler**

	Run excatly the same as during Redmine installation. This might be:

	```
	bundle install --without development test
	```

 3. **Restart Redmine**

	The second step is to restart Redmine. How this is done depends on how Redmine is
	setup. After the restart, configuration of the plugin can begin.

## Uninstallation

Uninstalling the plugin is easy as well. Basically it means removing the plugin
directory. Again, execute from within the Redmine root directory.

 1. **Removing the plugin directory**

	```
	rm -r plugins/redmine_workflow_enhancements
	```

 2. **Restart Redmine**

	The second step is to restart Redmine. Once restarted, the plugin will be gone.

## Usage

* Go to Administration -> Workflow, select a single workflow and click 'Edit'
* Go to Administration -> Tracker, select a tracker
* In the issue edit form, click on the "?" next to the issue status


## Development and test

To run the tests, an additional Gem is required for code coverage: simplecov. If
bundler was initially run with `--without developmen test`, run again without
these arguments to install *with* the development and test gems.

To run the tests:

````
bundle exec rake redmine:plugins:test NAME=redmine_workflow_enhancements
````


## License and thanks

Since this is a Redmine plugin, Redmine is licensed under the GPLv2 and the
GPLv2 is very clear about derived work and such, this plugin is licensed under
the same license.

This plugin borrows an extension to ActiveView that provides a `render :super`
from ActiveScaffold, https://github.com/activescaffold/active_scaffold
