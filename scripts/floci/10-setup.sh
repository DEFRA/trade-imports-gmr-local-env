#!/bin/bash

# test-reports
awslocal s3 mb s3://reports

# trade-imports-gmr-finder
awslocal s3 mb s3://trade-imports-gmr-finder-search-results
awslocal sns create-topic --name trade_imports_matched_gmrs
awslocal sqs create-queue --queue-name trade_imports_matched_gmrs_processor
awslocal sns subscribe --topic-arn arn:aws:sns:$AWS_REGION:000000000000:trade_imports_matched_gmrs --protocol sqs --notification-endpoint arn:aws:sqs:$AWS_REGION:000000000000:trade_imports_matched_gmrs_processor --attributes '{"RawMessageDelivery": "true"}'
awslocal sqs create-queue --queue-name trade_imports_data_upserted_gmr_finder

# trade-imports-gmr-processor
awslocal sqs create-queue --queue-name trade_imports_data_upserted_gmr_processor_gto
awslocal sqs create-queue --queue-name trade_imports_matched_gmrs_gmr_processor_eta
awslocal sqs create-queue --queue-name trade_imports_matched_gmrs_gmr_processor_gto
awslocal sqs create-queue --queue-name trade_imports_matched_gmrs_gmr_processor_match
awslocal sns subscribe --topic-arn arn:aws:sns:$AWS_REGION:000000000000:trade_imports_matched_gmrs --protocol sqs --notification-endpoint arn:aws:sqs:$AWS_REGION:000000000000:trade_imports_matched_gmrs_gmr_processor_eta --attributes '{"RawMessageDelivery": "true"}'
awslocal sns subscribe --topic-arn arn:aws:sns:$AWS_REGION:000000000000:trade_imports_matched_gmrs --protocol sqs --notification-endpoint arn:aws:sqs:$AWS_REGION:000000000000:trade_imports_matched_gmrs_gmr_processor_gto --attributes '{"RawMessageDelivery": "true"}'
awslocal sns subscribe --topic-arn arn:aws:sns:$AWS_REGION:000000000000:trade_imports_matched_gmrs --protocol sqs --notification-endpoint arn:aws:sqs:$AWS_REGION:000000000000:trade_imports_matched_gmrs_gmr_processor_match --attributes '{"RawMessageDelivery": "true"}'
