#!/bin/bash -eux

rpm -qa | grep -q git || yum install -y git
