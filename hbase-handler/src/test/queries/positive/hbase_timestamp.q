DROP TABLE hbase_table;
CREATE TABLE hbase_table (key string, value string, time timestamp)
  STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
  WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf:string,:timestamp");
DESC extended hbase_table;
FROM src INSERT OVERWRITE TABLE hbase_table SELECT key, value, "2012-02-23 10:14:52" WHERE (key % 17) = 0;
SELECT * FROM hbase_table;

DROP TABLE hbase_table;
CREATE TABLE hbase_table (key string, value string, time bigint)
  STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
  WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf:string,:timestamp");
FROM src INSERT OVERWRITE TABLE hbase_table SELECT key, value, 1329959754 WHERE (key % 17) = 0;
SELECT key, value, cast(time as timestamp) FROM hbase_table;

DROP TABLE hbase_table;
CREATE TABLE hbase_table (key string, value string, time bigint)
  STORED BY 'org.apache.hadoop.hive.hbase.HBaseStorageHandler'
  WITH SERDEPROPERTIES ("hbase.columns.mapping" = ":key,cf:string,:timestamp");
insert overwrite table hbase_table select key,value,ts FROM
(
  select key, value, 100000000 as ts from src WHERE (key % 33) = 0
  UNION ALL
  select key, value, 200000000 as ts from src WHERE (key % 37) = 0
) T;

explain
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time < 200000000;
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time < 200000000;

explain
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time > 100000000;
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time > 100000000;

explain
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time <= 100000000;
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time <= 100000000;

explain
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time >= 200000000;
SELECT key, value, cast(time as timestamp) FROM hbase_table WHERE key > 100 AND key < 400 AND time >= 200000000;
