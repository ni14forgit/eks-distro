#!/usr/bin/env bash
# Copyright 2020 Amazon.com Inc. or its affiliates. All Rights Reserved.
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


set -x
set -o errexit
set -o nounset
set -o pipefail

RELEASE_BRANCH="$1"
BASE_IMAGE="$2"
DOCKERFILE="$3"
REPOSITORY_BASE="$4"
COMPONENT="$5"
IMAGE_TAG="$6"
PUSH="$7"
SKIP_ARM=${8-false}

MAKE_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"

source "${MAKE_ROOT}/build/lib/images.sh"

OUTPUT_DIR="_output"
BIN_DIR=${OUTPUT_DIR}/bin/coredns

if [ ! -d ${BIN_DIR} ]; then
    echo "${BIN_DIR} not present! Run 'make binaries'"
    exit 1
fi

if [ "$PUSH" != "true" ]; then
    echo "Placing images under in $BIN_DIR"
    build::images::release_image_tar $RELEASE_BRANCH $BASE_IMAGE $DOCKERFILE $REPOSITORY_BASE $COMPONENT $IMAGE_TAG $MAKE_ROOT $SKIP_ARM
else
    build::images::push $RELEASE_BRANCH $BASE_IMAGE $DOCKERFILE $REPOSITORY_BASE $COMPONENT $IMAGE_TAG $MAKE_ROOT
fi

