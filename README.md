# Redmine Workflow Enhancements

Add various enhancements to workflow editing. Currently this consists of these:

  * Visualization with dagre-d3:

	* Workflow edit
	* Tracker edit
	* Issue edit (behind the little question mark next to "Issue Status")

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

 3. **Run plugin migrations**

	```
	bundle exec rake redmine:plugins NAME=redmine_workflow_enhancements RAILS_ENV=production
	```

 4. **Restart Redmine**

	The second step is to restart Redmine. How this is done depends on how Redmine is
	setup. After the restart, configuration of the plugin can begin.

## Uninstalling

Uninstalling the plugin is easy as well:

 1. **Reverse plugin migrations**

	```
	bundle exec rake redmine:plugins NAME=redmine_workflow_enhancements  RAILS_ENV=production VERSION=0
	```

 2. **Removing the plugin directory**

	```
	rm -r plugins/redmine_workflow_enhancements
	```

 3. **Restart Redmine**

	The second step is to restart Redmine. Once restarted, the plugin will be gone.

## Usage

* Go to Administration -> Workflow, select a single workflow and click 'Edit'
* Go to Administration -> Tracker, select a tracker
* For each role that should be able to display the workflow graph in the issue form:

	* Go to Administration -> Roles and permissions, select the desired role
	* Check "View workflow graph" in the category "Issue Tracking"

* In the issue edit form, click on the "?" next to the issue status

### What is displayed

The generated graph always includes the full workflow of a tracker. To
differentiate things:

**Transitions:**

  * Black

	The transition is possible with the current roles

  * Grey

	The transition is not possible by the current role

  * Dashed line

	The transition is only possible when the user is the author of the issue

  * Red line

	The transition is only possible when the user is the assignee of the issue


**Statuses:**

  * Green background

	The issue is closed in this state

  * Red background

	This is a status a new issues is can have. The default status for a new
	issues is displayed with bold text.

	Notes:

	  * The default issue status for a tracker is configurable since Redmine
		3.0. Older versions of Redmine always use "New".

	  * The possible statuses for a new issue is configurable since Redmine 3.2.
		Older versions of Redmine allow the default status and all directly
		reachable statuses. The highlighting only shows the new Redmine 3.2
		configuration.

  * Grey border

	In issue edit form, this is the current selected status

  * Blue border

	In issue edit form, these are the next possible statuses in the workflow


### How the association between Tracker and Statuses works

The idea is to control what's showed in "Administration" -> "Workflow" ->
"Status transitions" -> "Edit". With a lot of different statuses and creating a
new tracker, things get messy. The default is to only show statuses that are
included in the workflow ("Only display statuses that are used by this tracker"
checked). With a new tracker there are none. Unchecking said checkbox displays
all statuses which makes it hard to find the relevant ones. It also involves a
lot of scrolling on small screens.

The plugin solves this with the pre-defined association in the tracker. It
changes the behavior when "Only display statuses that are used by this tracker"
is checked. It will display all statuses involved in the actual workflow (normal
behavior) but also includes all the pre-defined ones. The behavior with that
checkbox unchecked is unchanged, it will display all the statuses.


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
