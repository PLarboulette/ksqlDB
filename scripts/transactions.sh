#!/bin/bash

"$CONFLUENT_HOME"/bin/ksql-datagen schema=../schemas/transactions.avro format="$1" topic=transactions-"$1" key=transactionid iterations=100 bootstrap-server=localhost:9092