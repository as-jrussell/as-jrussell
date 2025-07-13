#!/bin/bash
psql -U jrussell -d DBA -h localhost -v ON_ERROR_STOP=1 -f deploy_all.sql