
## Getting employee database up and running

Vagrant is used to spin up an ubuntu VM with mysql. Chef is used to provision the VM. Use librarian-chef to install cookbooks:

    cd chef
    librarian-chef install

Then, launch the vm with vagrant:

    vagrant up

## Loading the employee database

ssh into the VM:

    vagrant ssh

then, run the following scripts

    cd /vagrant
    ./download_employee_database
    ./create_employee_database
    ./validate_employee_database

these are broken apart so you can re-use them later, to say recreate the database

## ...

flyway parts coming later
