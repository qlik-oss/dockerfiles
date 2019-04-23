#!/bin/bash
# Copyright 2018 Mirantis
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

# DIND_ROOT=$(dirname "${BASH_SOURCE}")/..
DIND_BUILD="$( cd "$(dirname "$0")" ; pwd -P )"
DIND_ROOT="$( cd "$(dirname "$DIND_BUILD")" ; pwd -P )"
source "$DIND_BUILD/funcs.sh"

dind::build-base
dind::build-image "${image_name}:local"
