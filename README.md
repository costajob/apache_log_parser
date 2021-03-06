## Table of Contents
* [Scope](#scope)
  * [Alternatives](#alternatives)
* [Log format](#log-format)
  * [Captured fields](#captured-fields)
* [Usage](#usage)
  * [Help](#help)
  * [Output](#output)
  * [Filters](#filters)
  * [CSV export](#csv-export)
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
Install last Crystal version and clone the repository: 
```shell
git clone https://github.com/costajob/apache_log_parser.git
```
Move into the cloned repository and compile the main file to get the CLI program:
```shell
crystal build --release src/apache_log_parser.cr
```
Move the resulting binary in your PATH.

### Help
Once compiled, you can check program help by typing:
```shell
apache_log_parser -h
Usage: apache_log_parser -s /logs -f 2016-06-30T00:00:00+0100 -t 2016-07-04T00:00:00+0100 -i 66.249.66.63 -c 20* -r send_mail -a iphone
    -s SRC, --src=SRC                Specify log files path [cwd]
    -f FROM, --from=FROM             Filter requests from this time
    -t TO, --to=TO                   Filter requests until this time
    -c CODE, --code=CODE             Filter HTTP code by regex
    -i IPS, --ips=IPS                Filter by list of true client IPs
    -r REQUEST, --request=REQUEST    Filter HTTP request by regex
    -a AGENT, --agent=AGENT          Filter user agent by regex
    -h, --help                       Show this help
```

### Output
The CLI library starts scanning file by the specified source path (default to CWD). 
The results are printed directly to STDOUT, displaying hits distributed on time and by true IP:
```shell
apache_log_parser --src=<path_to_gz_logs>

access_log.gz                  17        


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

#### Global report
If more than one log file is scanned, a global report is printed by collecting all of the parsed data.

#### Highlight output
Depending on the standard traffic of your server, you could want to highlight the results that are greater than a specified limit:
```shell
HIGHLIGHT=200000 apache_log_parser --src=<path_to_gz_logs>
```

### Filters
You can refine results by combining different filters:
* from time
* to time
* HTTP code by regex (can be negated)
* list of true client IPs
* HTTP request by regex (can be negated)
* user agent by regex (can be negated)

#### Limit data
Since the list of true IP could be large you can limit the number printed data by using an environment variable:
```shell
LIMIT=10 apache_log_parser --src=<path_to_gz_logs>
``` 

#### Custom regex
In case you need to specify a custom regex to capture log data you can use an environment variable (remember to use the same group names):
```shell
REGEX="^(?<true_client_ip>(?:[0-9]{1,3}\.){3}[0-9]{1,3}|-)" apache_log_parser
```

### CSV export
At the end of the scanning you are asked to export a CSV with filtered data into the current folder (or by defining the EXPORT environment variable). 
Remember that the `user_agent`, `request` and `code` data are only captured if the relative filters have been specified.
It is also possible to skip asking by using an environment variable:
```shell
ASK=n apache_log_parser
```

### Examples

#### Detect bots
```shell
apache_log_parser --src=<path_to_gz_logs> --agent="[spring|google]bot"
``` 

#### Detect errors
```shell
apache_log_parser --src=<path_to_gz_logs> --code=50*
```

#### Detect specific HTTP verb
```shell
apache_log_parser --src=<path_to_gz_logs> --request=^post
```

#### Check specific time window
You can specify different time zones and they will be observed:
```shell
apache_log_parser --src=<path_to_gz_logs> --from=2016-07-03T04:10:13+0200 --to=2016-07-03T05:33:01+0400
```

#### Exclude specific results
By using the negation form `-` (available for status, request and user agent) is possible to filter by excluding matching results:
```shell
apache_log_parser --src=<path_to_gz_logs> --agent=-iphone
```

#### Combining filters
You can combine available filters for more granular data analysis.
```shell
apache_log_parser --src=<path_to_gz_logs> \
                  --from=2016-07-03T04:10:13+0100 \
                  --to=2016-07-03T05:33:01+0100 \
                  --code=302 \
                  --ips=66.249.66.63,61.148.244.148 \
                  --request=jpg \
                  --agent=iphone
```

## Performance
I tested this library with a compressed Apache log of 126MB (about 1.6GB uncompressed), by applying different filters and a combination of them all.  
I measured execution time by using standard *time* function; memory consumption was recorded via Xcode's Instruments.  

### Platform
The following benchmarks was measured on a MacBook PRO 15 late 2015, 4CPUs, 16GB RAM.

### Results

|  Applied filter/s      | Total results      | Execution time     |   RAM peak (MB) |
| :--------------------- | -----------------: | -----------------: |---------------: |
| no filters             |           3917386  |          2m9.971s  |         601.99  |
| from/to                |           1803951  |         2m14.297s  |         331.42  |
| code                   |           3183506  |         2m14.902s  |         712.77  |
| ips                    |            121250  |          2m6.322s  |          28.86  |
| request                |           2963684  |         2m22.195s  |         650.17  |
| agent                  |           1695367  |         2m39.292s  |         612.25  |
| combined               |              8977  |         2m47.704s  |           7.27  |

### Considerations
Execution time is CPU-bound and remains pretty consistent no matter the used filters.  
RAM consumption strongly depends on the number of fetched data and on the kind of fetched data, user agent and request being the larger.
