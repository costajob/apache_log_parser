## Table of Contents
* [Scope](#scope)
* [Log format](#log-format)
* [Usage](#usage)
  * [Help](#help)
  * [Filters](#filters)
* [Performance](#performance)
  * [Platform](#platform)
  * [Results](#results)

## Scope
The scope of this CLI program is to scan [Apache HTTPD](https://httpd.apache.org/) logs in order to highlight possible DDoS attacks and/or other type of events.

## Log format
The assumed log format is the following:
````log
23.63.227.241 - - [03/Jul/2016:03:56:21 +0100] "GET / HTTP/1.1" 302 94 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko" "192.40.202.240"
```
Consider you can modify the regex used to capture log file data by using an environment variable (see below).

### Captured fields
The following fields are captured from each line by using a named-group regex:
* *time*: the log time
* *request*: the HTTP request received by the server  
* *status*: the HTTP status of the response
* *user_agent*: the user agent data
* *true_ip*: since most of the applications run behind a CDN, the True IP of the client

## Usage
Compile the main file to get the CLI program:

```
crystal build --release src/apache_log_parser.cr
```

### Help
Once compiled, you can check program help by typing:

```
./apache_log_parser -h
```

### Filters
You can filter logs data by specifying the source path (default to cwd) and combining different filters:
* HTTP code
* HTTP verb
* HTTP request by regex
* user agent by regex
* time range

#### Limit data
Since the list of True IPs could be large you can limit the number of data to output by using an environment variable:
```
LIMIT=10 ./apache_log_parser -src=/usr/local/apache/logs/older --code=304
``` 

#### Custom regex
In case you need to specify a custom regex for a specific log file, you can do this by using an environment variable:
```shell
REGEX="^(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)" ./apache_log_parser
```

#### Examples

##### Detect bots
```shell
./apache_log_parser -src=<path_to_gz_logs> --agent=*bot
``` 

##### Detect crashes
```shell
./apache_log_parser -src=<path_to_gz_logs> --code=500 
```

##### Check specific time window
You can specify different time zones and they will be checked:
```shell
./apache_log_parser -src=<path_to_gz_logs> --from=2016-07-03T04:10:13+0200 --to=2016-07-03T05:33:01+0200
```

##### Combining filters
You can combine available filters for a granular data analysis:
```shell
./apache_log_parser -src=<path_to_gz_logs> --from=2016-07-03T04:10:13+0100 --to=2016-07-03T05:33:01+0100 --code=302 --verb=get --request=images --agent=iphone
```

## Performance
I tested this library with a compressed Apache log of 126MB (about 1.6GB uncompressed), by applying different filters and a combination of them all.  
I measured execution time by using standard *time* function; memory consumption was recorded via Xcode's Instruments.

### Platform
The following benchmarks was measured on a MacBook PRO 15 late 2015, 4CPUs, 16GB RAM.

### Results

|  Applied filter/s      | Total results      | Execution time     |   RAM peak (MB) |
| :--------------------- | -----------------: | -----------------: |---------------: |
| time range             |           3648593  |          2m5.724s  |         696.40  |
| http code              |           2967811  |          2m5.633s  |         442.37  |
| http verb              |           2754608  |         3m21.389s  |         722.33  |
