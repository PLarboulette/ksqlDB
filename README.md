# ksqDB 

## Tools 

I use a tool called ksql-datagen. It's a tool available in the Confluent platform  which ben be download [here](https://www.confluent.io/download/). I use the
version 6.0.0 of the Confluent Platform (currently the last).

## To run the project 

- Run `docker-compose up`
- Launch the ksqlDB CLI :
```
docker exec -it ksqldb-cli ksql http://ksqldb-server:8088
 ```
- Create the streams : 

The columns which are used to create the stream can be found in the schema of each entity (`schemas`folder). 
```
CREATE STREAM transactions (transactiontime DOUBLE, transactionid VARCHAR, clientid VARCHAR, transactionamount VARCHAR)
  WITH (kafka_topic='transactions-json', value_format='json', partitions=1);
```

```
CREATE STREAM clients (clienttime DOUBLE, clientid VARCHAR)
  WITH (kafka_topic='clients-json', value_format='json', partitions=1);
```

We create a third stream which join the two previous. We use for that the field `clientid` which is available in the two entities ( `clients` and `transactions`).
The `WITHIN 10 SECONDS` indicates the time that the streams wait to attempt to make the join. If the data comes too late, the join can't be made. 

```
CREATE STREAM transactions_clients AS 
    SELECT * FROM transactions LEFT JOIN clients WITHIN 10 SECONDS ON transactions.clientid = clients.clientid  EMIT CHANGES;
```

We can see the streams with the command :
```
SHOW STREAMS;
```

- We run a query on the steam :

```
SELECT transactions_transactionid, transactions_transactionamount, transactions_clientid, clients_clientid FROM transactions_clients tc EMIT CHANGES;
```

You can see that the fields are prefixed by the name of the stream of the entity (with the join clause) and a `_` and not a `transactions_clients.transactionamount` (which was my first idea). 

- Currently, the query doesn't return anything because the two topics (and streams) are empty. We can add data using the scripts `sh transactions.sh json` and `sh clients.sh json` located in the `scripts` folder. It will push 100 items of each entity in the two tipics.  
- We can see in the terminal the lines where the `clientid` is the ame ror the two entities. I print the two to see the equality. 