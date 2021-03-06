#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script executes all hive metastore upgrade scripts on an specific
# database server in order to verify that upgrade scripts are working
# properly.

# This script is run on jenkins only, and it creates some LXC containers
# in order to execute the metastore-upgrade-tests for different
# server configurations.

set -e
cd $(dirname $0)

OUT_LOG="/tmp/$(basename $0).log"
rm -f $OUT_LOG

log() {
        echo "$@"
        echo "$@" >> $OUT_LOG
}


fail() {
	echo $@
	exit 1
}

[[ $# != 4 ]] && fail "Usage: $0 --patch PATH_URL --branch BRANCH"

PATCH_URL=
BRANCH=
while [[ $# -gt 0 ]]; do
	if [[ $1 = "--patch" ]]; then
		PATCH_URL=$2
	elif [[ $1 = "--branch" ]]; then
		BRANCH=$2
	fi

	shift 2
done

test -n "$BRANCH" || fail "--branch value is required."
test -n "$PATCH_URL" || fail "--patch value is required."

get_supported_dbs() {
	ls dbs/ -1
}

lxc_get_ip() {
	 lxc-ls -f "^$1$" | tail -1 | awk '{print $3}' | tr -d ,
}

lxc_exists() {
	lxc-ls "^$1$" | grep $1 >/dev/null
}

lxc_create() {
	lxc-create -n $1 -t download -- --dist "ubuntu" --release "trusty" --arch "amd64"
	lxc-attach -n $1 -- apt-get update
	lxc-attach -n $1 -- apt-get install -y openssh-server subversion
	printf "root\nroot" | sudo lxc-attach -n $1 -- passwd
	lxc-attach -n $1 -- sed -i /etc/ssh/sshd_config 's/^PermitRootLogin without-password/PermitRootLogin yes/'
	lxc-attach -n $1 -- service ssh restart
}

lxc_running() {
	lxc-ls -f "^$1$" | tail -1 | awk '{print $2}' | grep "RUNNING" >/dev/null
}

lxc_start() {
	lxc-start -n $1 --daemon
	lxc-wait -n mysql -s RUNNING
	sleep 10 # wait a little longer
}

lxc_prepare() {
	echo "Downloading hive source code from SVN, branch='$BRANCH' ..."
	lxc-attach -n $1 -- rm -rf /tmp/hive
	lxc-attach -n $1 -- mkdir /tmp/hive

	lxc-attach -n $1 -- svn co http://svn.apache.org/repos/asf/hive/$BRANCH /tmp/hive >/dev/null

	lxc-attach -n $1 -- wget $PATCH_URL -O /tmp/hive/hms.patch
	lxc-attach -n $1 -- patch -s -N -d /tmp/hive -p1 -i /tmp/hive/hms.patch
}

lxc_print_metastore_log() {
	lxc-attach -n $1 -- cat /tmp/metastore-upgrade-test.sh.log
}

run_tests() {
	lxc-attach -n $1 -- bash /tmp/hive/testutils/metastore/metastore-upgrade-test.sh --db $1
}

# Install LXC packages if needed
if ! which lxc-create >/dev/null; then
	apt-get update
	apt-get -y install lxc || exit 1
fi

for d in $(get_supported_dbs)
do
	name=$(basename $d)

	# Create container
	if ! lxc_exists $name; then
		log "LXC $name is not found. Creating new container..."
		lxc_create $name || exit 1
		log "Container created."
	else
		log "LXC $name found."
	fi

	# Start container
	if ! lxc_running $name; then
		log "LXC $name is not started. Starting container..."
		lxc_start $name || exit 1
		log "Container started."
	fi

	# Prepare container
	log "Preparing $name container..."
	lxc_prepare $name || exit 1
	log "Container prepared."

	# Execute metastore upgrade tests
	echo "Running metastore upgrade tests for $name..."
	run_tests $name
	log "$(lxc_print_metastore_log $name)"
done
