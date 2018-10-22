#!/bin/bash
pmset -g ps|awk 'NR==2 {gsub(";","",$3);print $3}'
