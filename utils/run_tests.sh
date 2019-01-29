#!/bin/sh -e

cd "$(dirname "$0")/.."

echo "=== Nuking old .pyc files..."
find vumi/ -name '*.pyc' -delete
echo "=== Erasing previous coverage data..."
coverage erase
echo "=== Running trial tests..."
# only check the module that we care about
coverage run `which trial` --reporter=subunit vumi.transports.smpp | subunit-1to2 | tee results.txt | subunit2pyunit
subunit2junitxml <results.txt >test_results.xml
rm results.txt
echo "=== Processing coverage data..."
coverage xml
echo "=== Checking for PEP-8 violations..."
# only check the module that we care about
flake8 vumi/transports/smpp | tee pep8.txt
echo "=== Done."
