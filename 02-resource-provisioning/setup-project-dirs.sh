#!/bin/sh

# setups up project directories
NUM_PROJECTS=10
PROJECT_ROOT=`pwd`    # please change to actual project root directory

for i in $(seq 1 $NUM_PROJECTS)
do
    mkdir -p $PROJECT_ROOT/project-$i
    (cd terraform; tar --exclude='.terraform*' --exclude='terraform.tfstate*' -cvf - *) | (cd $PROJECT_ROOT/project-$i; tar -xvf - )
done
