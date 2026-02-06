#!/bin/bash

function is_ready() {
  # test-reports
  aws --endpoint-url $LOCALSTACK_URL s3api head-bucket --bucket reports || return 1

  # trade-imports-gmr-finder
  aws --endpoint-url $LOCALSTACK_URL s3api head-bucket --bucket trade-imports-gmr-finder-search-results || return 1
  aws --endpoint $LOCALSTACK_URL sns list-topics --query "Topics[?ends_with(TopicArn, ':trade_imports_matched_gmrs')].TopicArn" || return 1
  aws --endpoint $LOCALSTACK_URL sqs get-queue-url --queue-name trade_imports_matched_gmrs_processor || return 1
  aws --endpoint $LOCALSTACK_URL sqs get-queue-url --queue-name trade_imports_data_upserted_gmr_finder || return 1

  # trade-imports-gmr-processor
  aws --endpoint $LOCALSTACK_URL sqs get-queue-url --queue-name trade_imports_data_upserted_gmr_processor_gto || return 1
  aws --endpoint $LOCALSTACK_URL sqs get-queue-url --queue-name trade_imports_matched_gmrs_gmr_processor_eta || return 1
  aws --endpoint $LOCALSTACK_URL sqs get-queue-url --queue-name trade_imports_matched_gmrs_gmr_processor_gto || return 1
  aws --endpoint $LOCALSTACK_URL sqs get-queue-url --queue-name trade_imports_matched_gmrs_gmr_processor_match || return 1

  return 0
}

while ! is_ready; do
    echo "Waiting until ready"
    sleep 1
done

echo READY > /tmp/READY
