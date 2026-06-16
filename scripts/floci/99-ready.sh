#!/bin/bash

function is_ready() {
  # test-reports
  awslocal s3 ls s3://reports || return 1

  # trade-imports-gmr-finder
  awslocal s3 ls s3://trade-imports-gmr-finder-search-results || return 1
  awslocal sns list-topics --query "Topics[?ends_with(TopicArn, ':trade_imports_matched_gmrs')].TopicArn" || return 1
  awslocal sqs get-queue-url --queue-name trade_imports_matched_gmrs_processor || return 1
  awslocal sqs get-queue-url --queue-name trade_imports_data_upserted_gmr_finder || return 1

  # trade-imports-gmr-processor
  awslocal sqs get-queue-url --queue-name trade_imports_data_upserted_gmr_processor_gto || return 1
  awslocal sqs get-queue-url --queue-name trade_imports_matched_gmrs_gmr_processor_eta || return 1
  awslocal sqs get-queue-url --queue-name trade_imports_matched_gmrs_gmr_processor_gto || return 1
  awslocal sqs get-queue-url --queue-name trade_imports_matched_gmrs_gmr_processor_match || return 1

  return 0
}

while ! is_ready; do
  echo "Waiting until ready"
  sleep 1
done
