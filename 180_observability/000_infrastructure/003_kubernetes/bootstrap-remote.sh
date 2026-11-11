#!/bin/bash
set -o errexit -o pipefail

kind delete cluster
kind create cluster --config=kind.yaml
