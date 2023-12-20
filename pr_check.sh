#!/bin/bash
# Copyright 2023 Red Hat, Inc
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# --------------------------------------------
# Options that must be configured by app owner
# --------------------------------------------
export APP_NAME="ccx-data-pipeline"  # name of app-sre "application" folder this component lives in
export COMPONENT_NAME="dvo-writer"
export IMAGE="quay.io/cloudservices/dvo-writer"
export COMPONENTS="dvo-writer"  # space-separated list of components to laod
export COMPONENTS_W_RESOURCES="dvo-writer"  # component to keep
export CACHE_FROM_LATEST_IMAGE="true"

export IQE_PLUGINS="ccx"
export IQE_MARKER_EXPRESSION=""
# There are no tests for this service yet, just checking deployability
export IQE_FILTER_EXPRESSION="test_plugin_accessible"
export IQE_REQUIREMENTS_PRIORITY=""
export IQE_TEST_IMPORTANCE=""
export IQE_CJI_TIMEOUT="30m"


function build_image() {
    source "$CICD_ROOT"/build.sh
}

function deploy_ephemeral() {
    source "$CICD_ROOT"/deploy_ephemeral_env.sh
}

function run_smoke_tests() {
    source "$CICD_ROOT"/cji_smoke_test.sh
    source "$CICD_ROOT"/post_test_results.sh  # publish results in Ibutsu
}


# Install bonfire repo/initialize
CICD_URL=https://raw.githubusercontent.com/RedHatInsights/bonfire/master/cicd
curl -s $CICD_URL/bootstrap.sh > .cicd_bootstrap.sh && source .cicd_bootstrap.sh
echo "creating PR image"
build_image

echo "deploying to ephemeral"
deploy_ephemeral

echo "running PR smoke tests"
run_smoke_tests
