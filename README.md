
## Getting employee database up and running

Vagrant is used to spin up an ubuntu VM with mysql. Chef is used to provision the VM. Use librarian-chef to install cookbooks:

    cd chef
    librarian-chef install

Then, launch the vm with vagrant:

    vagrant up

## Loading the employee database

ssh into the VM:

    vagrant ssh

Then, load some functions to prepare the employees database for flyway migrations:

    cd /vagrant
    source transition_scripts

To create the [employees database](https://launchpad.net/test-db/employees-db-1):

    download_employee_database
    create_employee_prod_database
    validate_employee_prod_database

These are broken apart so you can re-use them later, to say recreate the database.

## Transitioning to flyway

We need to baseline the production database

    baseline_employee_prod

Then we can create a dev database from the baseline

    create_dev_database_from_baseline

In reality, dev and prod already existed and we'd want to make sure they are aligned. At this point we're making sure dev contains everything in production. Anything added to prod, but not dev, should be added to dev since these objects are part of the baseline. You can compare to find differences:

    compare_dev_to_prod

Feel free to use your own tools to compare too. 

In reality, a development database may also have changes not yet in prod. Those can be scripted out later and eventually applied to production. Once you're happy with the baseline, you can move on to incorporating flyway.

## Adding in flyway

There are a second set of scripts to start working with flyway

    source scripts_with_flyway

Go ahead and try out running flyway against your new employee database `flyway_info_prod`. After baselining prod, we should mark it as baselined with `flyway_init_prod`. This will mark production as v1, as if the v1 baseline were used to create it. Use `flyway_info_prod` to see what happened.

We can now create new databases (say a development database) from the baseline with flyway. Use `create_dev_database_from_migrations` to try that out. Look at what's in the database. Run `flyway_info_dev` and observe the output.

We can even create other databases on the fly, like a comparison database in dev `create_dev_compare_database_from_migrations`. This is useful when changing our development database, to have another to compare it to, to see what we changed. Many times this serves as a great way to double check our work. A few comparison tasks to play around with `compare_dev_to_prod` and `compare_dev_to_dev_compare`. Think about how you might use these in your own work.

I create a few wrapper commands to point at different database flyway configurations: `flyway_dev` `flyway_prod` and `flyway_compare`. You can use these to run any flyway commands with the appropriate configuration:

    flyway_dev info
    flyway_dev validate
    flyway_dev migrate
    flyway_prod info
    flyway_prod migrate

Try adding a migration V2,V3,V4 from the sqlsamples folder to the sql folder. Or write your own. Then migrate the dev database, and then the prod database.

## Backup, restore and workflows to create change scripts

Having the ability to backup/restore databases succinctly can enable many workflows to help confidently and quickly create database migrations

I added the ability to easily backup dev and prod and to easily restore to dev to enable the following workflow:

- Backup dev `backup_dev`, backs up to employees_dev.sql.gz
- Develop change
  - Change dev willy nilly. If you like your sql tools you can keep them
  - Write tests, perhaps drive your changes with tests
  - Settle on a design
  - Reverse engineer your changes from last hour or two, not a big deal to do
  - Collaborate with DBAs or others more knowledgeable
- Generate change script
  - put into sql/VX__description.sql 
  - create the migration sql file for flyway
  - see workflow below to generate change script
  - Collaborate with DBAs or others more knowledgeable
- Test change script
  - Backup changed dev database `backup_changed_dev`
    - A safety net if you fail to reverse engineer your changes, backs up to employees_changed_dev.sql.gz
  - Restore dev from before making your changes `restore_dev`
    - restores from employees_dev.sql.gz
  - `flyway_dev migrate`
    - will apply your proposed migration script
  - review things
  - run tests
  - If there are issues
    - You can restore your changed database if needed `restore_dev employees_changed_dev.sql.gz`
- Commit change script and share with others

This workflow might help create the migration script:

- Before changing dev, clone dev to dev_compare
  - `clone_dev_to_dev_compare` uses employees_dev_to_dev_compare.sql.gz
- Develop change
- When building the migration script, run it against dev_compare since it's a clone of dev. 
  - Restore dev_compare from dev backup at any point to wipe the slate in the compare db `restore_dev_compare employees_dev_to_dev_compare.sql.gz`
  - Can diff dev / dev_compare to review if your migration script synchronizes schemas/data properly 
    - use any tool you like here for comparison/diff
- Follow above workflow (Test change script) to do one last test of your migration in your dev db
