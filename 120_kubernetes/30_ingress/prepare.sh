#!/bin/bash

# Please install uniget from https://github.com/uniget-org/cli

uniget install kind kubectl helm

kind create cluster --config kind.yaml