#!/bin/bash

aws secretsmanager get-secret-value --secret-id my-test-secret --region "us-east-1"
