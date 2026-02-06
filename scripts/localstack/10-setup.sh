#!/bin/bash

# test-reports
aws --endpoint-url $LOCALSTACK_URL s3api create-bucket --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION --bucket reports

# trade-imports-gmr-finder
aws --endpoint-url $LOCALSTACK_URL s3api create-bucket --region $AWS_REGION --create-bucket-configuration LocationConstraint=$AWS_REGION --bucket trade-imports-gmr-finder-search-results
aws --endpoint $LOCALSTACK_URL sns create-topic --region $AWS_REGION --name trade_imports_matched_gmrs
aws --endpoint $LOCALSTACK_URL sqs create-queue --region $AWS_REGION --queue-name trade_imports_matched_gmrs_processor
aws --endpoint $LOCALSTACK_URL sns subscribe --region $AWS_REGION --topic-arn arn:aws:sns:$AWS_REGION:000000000000:trade_imports_matched_gmrs --protocol sqs --notification-endpoint arn:aws:sqs:$AWS_REGION:000000000000:trade_imports_matched_gmrs_processor --attributes '{"RawMessageDelivery": "true"}'
aws --endpoint $LOCALSTACK_URL sqs create-queue --region $AWS_REGION --queue-name trade_imports_data_upserted_gmr_finder

# trade-imports-gmr-processor
aws --endpoint $LOCALSTACK_URL sqs create-queue --region $AWS_REGION --queue-name trade_imports_data_upserted_gmr_processor_gto
aws --endpoint $LOCALSTACK_URL sqs create-queue --region $AWS_REGION --queue-name trade_imports_matched_gmrs_gmr_processor_eta
aws --endpoint $LOCALSTACK_URL sqs create-queue --region $AWS_REGION --queue-name trade_imports_matched_gmrs_gmr_processor_gto
aws --endpoint $LOCALSTACK_URL sqs create-queue --region $AWS_REGION --queue-name trade_imports_matched_gmrs_gmr_processor_match
