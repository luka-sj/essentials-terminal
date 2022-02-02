# Essentials Terminal

Terminal for Essentials debugging
(still a very early WIP)

## Usage

1. Fork this repo
2. Clone your forked repo into a directory on your local machine

You can now pull the changes from this repo locally whenever significant development is made, or open Pull Requests to contribute to the development.

The provided `.bat` and `.sh` files are just there as easily runnable instances of the application.

To use this application, you need to have Ruby (at least 3.0.0) installed on your local machine.

Using the `cd` command, navigate to a directory containing your Essentials project and run the command `essentials load`.

### Terminal Commands

This terminal is not actually running of your local CLI instance, but instead is wrapped in a Ruby layer to handle all the logic.
Hence not all terminal commands you may be familiar with are available. In fact, no traditional commands are available unless specifically recreated for the purposes of this application.

All the scripts for the various commands live in the `src/app/commands` directory.
