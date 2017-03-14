## Table of Contents
* [Scope](#scope)
  * [Alternatives](#alternatives)
* [Log format](#log-format)
  * [Captured fields](#captured-fields)
* [Usage](#usage)
  * [Help](#help)
  * [Output](#output)
  * [Filters](#filters)
  * [Examples](#examples)
* [Performance](#performance)
  * [Platform](#platform)
  * [Results](#results)
  * [Considerations](#considerations)

## Scope
The scope of this CLI program is to scan [Apache HTTPD](https://httpd.apache.org/) logs in order to highlight possible DDoS attacks and/or other type of events.

### Alternatives
Some alternatives exists:
* heavyweight log [analysis tools](https://www.apacheviewer.com/), for which this CLI is not a replacement
* pure command line scripts via [AWK](http://www.the-art-of-web.com/system/logs/), that i consider elegant, but a maintenance nightmare when filters start piling up

## Log format
The assumed log format is the following:
```log
23.63.227.241 - - [03/Jul/2016:03:56:21 +0100] "GET / HTTP/1.1" 302 94 "-" "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko" "192.40.202.240"
```
Consider you can modify the regex used to capture log file data by using an [environment variable](#custom-regex).

### Captured fields
The following fields are captured from each line by using a named-group regex:
* *time*: the log time
* *request*: the HTTP request received by the server  
* *status*: the HTTP status of the response
* *user_agent*: the user agent data
* *true_ip*: since most of the applications run behind a CDN, the True IP of the client

## Usage
Compile the main file to get the CLI program:
```shell
crystal build --release src/apache_log_parser.cr
```

### Help
Once compiled, you can check program help by typing:
```shell
./apache_log_parser -h
Usage: ./apache_log_parser -s /logs -f 2016-06-30T00:00:00+0100 -t 2016-07-04T00:00:00+0100 -c 200 -k send_mail -a iphone -v get
    -s SRC, --src=SRC                Specify log files path [cwd]
    -f FROM, --from=FROM             Filter requests from this time
    -t TO, --to=TO                   Filter requests until this time
    -c CODE, --code=CODE             Filter by HTTP code
    -r REQUEST, --request=REQUEST    Filter HTTP request by regex
    -a AGENT, --agent=AGENT          Filter user agent by regex
    -v VERB, --verb=VERB             Filter by HTTP verb
    -h, --help                       Show this help
```

### Output
The CLI library starts scanning file by the specified source path (default to CWD). 
The results are printed directly to STDOUT, highlighting hits by HTTP status, hour and true IP:
```shell
./apache_log_parser --src samples/

access_log.gz                  17        


HTTP STATUS                    HITS      
----------------------------------------
304                            17

HOUR                           HITS      
----------------------------------------
2016-07-03 03h                 17

TRUE IP                        HITS      
----------------------------------------
126.245.6.49                   3
221.127.193.144                3
182.139.30.248                 2
211.157.178.224                1
61.148.244.148                 1
37.104.78.137                  1
153.182.1.52                   1
165.225.96.76                  1
59.173.177.227                 1
```

#### Highlight output
Depending on the standard traffic of your server, you could want to highlight the results that are greater than a specified limit:
```shell
HIGHLIGHT=200000 ./apache_log_parser --src samples/
```

### Filters
You can refine results by combining different filters:
* time range (i.e. 2016-06-30T00:00:00+0100)
* HTTP code by regex
* HTTP verb (get, post, put, delete, head, options)
* HTTP request by regex
* user agent by regex

#### Limit data
Since the list of true IP could be large you can limit the number printed data by using an environment variable:
```shell
LIMIT=10 ./apache_log_parser
``` 

#### Custom regex
In case you need to specify a custom regex to capture log data you can use an environment variable (remember to use the same group names):
```shell
REGEX="^(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)" ./apache_log_parser
```

### Examples

#### Detect bots
```shell
./apache_log_parser -src=<path_to_gz_logs> --agent="[spring|google]bot"
``` 

#### Detect errors
```shell
./apache_log_parser -src=<path_to_gz_logs> --code=50*
```

#### Check specific time window
You can specify different time zones and they will be observed:
```shell
./apache_log_parser -src=<path_to_gz_logs> --from=2016-07-03T04:10:13+0200 --to=2016-07-03T05:33:01+0400
```

#### Combining filters
You can combine available filters for more granular data analysis.
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
| no filters             |           3648593  |         2m10.500s  |         698.55  |
| time range             |           1445855  |          2m8.561s  |         214.00  |
| HTTP code              |           2967811  |          2m5.633s  |         442.37  |
| HTTP verb              |           2754608  |         3m25.770s  |         722.08  |
| request                |            265290  |         3m19.767s  |          96.76  |
| user agent             |             42638  |         2m34.023s  |          15.75  |
| all combined           |                 8  |         3m49.067s  |           2.31  |

### Considerations
Execution time is CPU-bound and remains pretty consistent for the used filters, augmenting when dealing with the regexps on the request and user agent data.  
RAM consumption strongly depends on the number of fetched data, since each row is consumed into the stack.
