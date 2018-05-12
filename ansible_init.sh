#!/bin/bash

# Ansible project init script
# KP, 4/21/17
# v1.2 - 8/24/17

clear

# Prompt for project name
echo 'What is the project name?'
read project

# Prompt for server role
echo 'What is the server role?'
read role

while true; do

  # Bonus: init git repo if one exists
  echo 'Does a git repo exist? [y/n]'
  read exist

  case "$exist" in
    y|Y)
      echo 'Paste URL to git repo'
      read repo
      break
    ;;
    n|N)
      break
    ;;
    *)
      echo 'Enter valid option'
    ;;
  esac
done

# Create Ansible vars
a_base=~/ansible
a_tree=(defaults files handlers tasks vars)
p_base=$a_base/$project
r_base=$p_base/roles/$role

if [[ ! -e "$a_base" ]]; then
  mkdir $a_base
fi

mkdir -p $r_base
mkdir $p_base/logs

# Create project base var
p_base=$a_base/$project

# Create base ansible.cfg file
echo "[defaults]
pipelining=True
log_path=./logs/$project.log" > $p_base/ansible.cfg

# Create directory tree
for dir in ${a_tree[@]}; do
  mkdir -p $r_base/$dir
  touch $r_base/$dir/main.yml
done

if [[ -n "$repo" ]]; then
  cd $p_base
  git init
  git remote add origin $repo
  git add -A
  git commit -m "Initial commit"
  git push origin master:master
  echo "Initial push to git done"
fi

echo "Done. Project initialized in $p_base"
