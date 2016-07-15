## Table of Contents
* [Scope](#scope)
* [Enhancements](#enhancements)
* [Usage](#usage)
  * [Help](#help)
  * [Filters](#filters)
* [Performance](#performance)
  * [Platform](#platform)
  * [Results](#results)

## Scope
This is a Crystal porting of the original [GO library](https://github.com/costajob/apache-log-parser).

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
You can filter logs data by specifying the source path (default to cwd), filtering by HTTP code, verb, keyword (on HTTP request) and time range:

```
./apache_log_parser --src=/usr/local/apache/logs/older --from=2016-07-03T04:10:13+0100 --to=2016-07-03T05:33:01+0100 --code=500 --keyword=send_email --verb=head
``` 

## Performance
I tested this library with a compressed Apache log of 126MB (about 1.6GB uncompressed), by applying different filters and a combination of them all.  
I measured execution time by using standard *time* function; memory consumption was recorded via Xcode's Instruments.

### Platform
The following benchmarks was measured on a MacBook PRO 15 late 2011, 4CPUs, 8GB RAM.

### Results

|  Applied filter/s      | Total results      | Execution time     |   RAM peak (MB) |
| :--------------------- | -----------------: | -----------------: |---------------: |
| keyword                |            418551  |         3m10.025s  |         118.45  |
| time range             |           2368069  |         3m13.552s  |         627.03  |
| http code              |           3571459  |         3m03.405s  |        1130.00  |
| http verb              |            516033  |         3m20.143s  |         126.06  |
| all combined           |            412701  |         3m19.153s  |         118.48  |
