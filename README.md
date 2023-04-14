# cachegrand-benchmarks
Welcome to the cachegrand-benchmarks repository! This repository contains the benchmark data for cachegrand, the world's fastest key-value store and cache!
Here you'll find the raw benchmark data, usually generated with memtier_benchmark, that showcases the incredible performance of cachegrand as well as comparisons to competitor key-value stores like Redis, KeyDB, DragonflyDB, and more.

## Repository Structure

- `benchmarks`: This directory contains the raw benchmark data folders.
- `scripts`: This directory contains scripts used for generating and processing benchmark data.

## Benchmark Data
Each benchmark run is stored in a dedicated folder within the `benchmarks` directory, with a timestamp indicating when the benchmark was conducted. The naming convention for the folders is:

<YYYYMMDDHHMMSS>

For example:

`20230414093000`

Inside each benchmark run folder, you will find:

- A README.md file describing the benchmarked platforms, commit IDs or version numbers, and the hardware used for the benchmarks, including all relevant specs.
- Folders for each platform, with the platform name as the folder name (e.g., cachegrand, redis, keydb, dragonflydb).
  - Within each platform folder, you will find subfolders for each number of threads, prefixed with "t" (e.g., t1, t2, t4, t8, t16, t32, t64, etc.).
    - Inside each thread count folder, you will find folders for each command (e.g., get, set, mget, mset, msetnx, etc.).

## Benchmark Types
Benchmarks can be of two types:

- Auto-generated: These benchmarks are conducted periodically to track cachegrand's performance over time.
- Ad-hoc: These benchmarks are generated specifically for a release, showcasing the performance improvements and features introduced in that release.

## Contributing
If you have benchmark data you'd like to contribute or if you find any issues with the existing data, please feel free to open an issue or submit a pull request.
## License
The benchmarks data in this repository are licensed under the Creative Commons
Attribution-NonCommercial-NoDerivatives 4.0 International License (CC BY-NC-ND 4.0) meanwhile the
scripts might be licensed under different licenses (e.g. GPL3, BSD-3-clause, etc.).
