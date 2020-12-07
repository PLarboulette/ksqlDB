#!/bin/bash

"$CONFLUENT_HOME"/bin/ksql-datagen schema=../schemas/clients.avro format="$1" topic=clients-"$1" key=clientid iterations=100
