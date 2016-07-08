## Table of Contents
* [Scope](#scope)
* [Enhancements](#enhancements)
* [Usage](#usage)
  * [Help](#help)
  * [Filters](#filters)
* [Performance](#performance)
  * [Platform](#platform)
  * [Results](#results)

# apache_log_parser
This is a Crystal porting of the original [GO library](https://github.com/costajob/apache-log-parser).

## Scope
Please refer to the GO version for more information.

## Enhancements
Using Crystal leads me to a more extensible code base by:
* using a log format class to define the used regex
* catching all of the row data depending on the specified format
* parsing the GZ file by buffering

## Usage
The library must be compiled and used as a command line program:

```
crystal build --release src/apache_log_parser.cr
```

### Help
Once compiled, you can check program help by typing:

```
./apache_log_parser --help
```

### Filters
You can filter logs data by specifying the source path, filtering by HTTP code and time range:

```
./apache_log_parser --src=/usr/local/apache/logs/older --code=500 --from=2016-07-03-04:10:13+0100 --to=2016-07-03-05:33:01+0100
``` 

## Performance
I measured performance by prepending each run with the time call and inspecting memory consumption by using Xcode's Instruments.

### Platform
The following benchmarks was measured on a MacBook PRO 15 late 2011, 4CPUs, 8GB RAM.

### Results

|  Access File(s)        | Execution Time     |   RAM Peak (MB) |
| :----------------------| -----------------: |---------------: |
| 1 x ~130MB             |         3m14.860s  |          61.25  |
| 2 x ~130MB             |         6m49.222s  |         113.18  |
