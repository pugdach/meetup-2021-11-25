#!/bin/sh

# Puppet Task Name: upgrade_app

echo "Stoppen der Applikation"
puppet resource service app1 ensure=stopped
sleep 4

echo "Aktualisierung auf version $PT_version"
sleep 4

echo "Neustart"
puppet resource service app1 ensure=running
sleep 4

