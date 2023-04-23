# cachegrand-benchmarks
Welcome to the cachegrand-benchmarks repository! This repository contains the benchmark data for
cachegrand, the world's fastest key-value store and cache!
Here you'll find the raw benchmark data, usually generated with memtier_benchmark, that showcases
the incredible performance of cachegrand as well as comparisons to competitor key-value stores
like Redis, KeyDB, DragonflyDB, and more.

## Repository Structure

- `benchmarks`: This directory contains the raw benchmark data folders.
- `scripts`: This directory contains scripts used for generating and processing benchmark data.

## Benchmark Data

The benchmark data is organized in the following folder structure:

```
[platform_name]
[platform_name]/[platform_version]
[platform_name]/[platform_version]/[test_configuration]
[platform_name]/[platform_version]/[test_configuration]/[node_number]
[platform_name]/[platform_version]/[test_configuration]/[node_number]/[thread_count]
[platform_name]/[platform_version]/[test_configuration]/[node_number]/[thread_count]/[operation_type]
```

- `platform_name`, the name of the software being benchmarked, e.g., keydb, redis, cachegrand, or dragonfly.
- `platform_version`, the version of the software being benchmarked, e.g., v6.3.2 for KeyDB or v7.0.11 for Redis.
- `test_configuration`, the test configuration used for the benchmark, e.g., c5-pipeline64 or c25.
- `node_number`, the "node number" folder (e.g., n01, n02, etc.) contains the benchmarks generated by a specific load generation server, the hardware in use will be the same for all of them.
- `thread_count`, the number of threads used in the benchmark, e.g., t1, t2, t4, t8, t16, t32, or t64.
- `operation_type`, the type of operation being benchmarked, either get or set.

For example, to find the benchmark results for cachegrand v0.2.1 using the c5-pipeline64 configuration, generated by the load server n01 with t1 thread for get operations, you would look in the following folder:
```
cachegrand/v0.2.1/c5-pipeline64/n01/t1/get
```

## Benchmark Types
cachegrand's benchmarks can be of two types:

- Auto-generated, these benchmarks are conducted periodically to track cachegrand's performance
  over time and in general they will use the commit id of the version tested out, the folder
  name will start with "git-" to differentiate
- Ad-hoc, these benchmarks are generated specifically for a release, showcasing the performance
  improvements and features introduced in that release, and the folder name will match the version
  used (e.g. v0.2.1).

## Contributing
If you have benchmark data you'd like to contribute or if you find any issues with the existing
data, please feel free to open an issue or submit a pull request.

## License
The benchmarks data in this repository are licensed under the Creative Commons
Attribution-NonCommercial-NoDerivatives 4.0 International License (CC BY-NC-ND 4.0) meanwhile the
scripts might be licensed under different licenses (e.g. GPL3, BSD-3-clause, etc.).
