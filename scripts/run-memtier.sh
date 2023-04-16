# Copyright (C) 2023 Daniele Salvatore Albano

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

# This script is intended to be run on a node of the testing cluster which is not the main server, to use
# multiple runs of the benchmark it's possible to use tmux with synchronized panes to start them all at
# the same time.

# When testing redis and keydb ensure that protected mode is off, otherwise the benchmark will fail.

# General configuration
MIN_THREADS=1
MAX_THREADS=64
BENCHMARK_OUTPUT_BASE_PATH="/home/daalbano/cachegrand-benches"
BENCHMARK_NAME="cachegrand/v0.2.0"
MEMTIER_HOST=127.0.0.1
MEMTIER_PORT=6379
MEMTIER_TEST_RUNS=3
MEMTIER_TEST_DURATION=30
MEMTIER_CLIENTS_PER_THREAD=25
MEMTIER_DATA_SIZE=64
MEMTIER_PIPELINE=0

# Automatically append the clients count and the pipeline count
# to the benchmark name if needed, the final name will be
# something like "cachegrand/v0.2.0/c25-pipeline256"
MEMTIER_BENCHMARK_NAME="${BENCHMARK_NAME}/c${CLIENTS_PER_THREAD}"
if [ $MEMTIER_PIPELINE -gt 0 ];
then
    BENCHMARK_NAME="${BENCHMARK_NAME}-pipeline${MEMTIER_PIPELINE}"
fi

# Run the benchmarks
MEMTIER_THREADS=0
while [ $MEMTIER_THREADS -lt $MAX_THREADS ];
do
    # Calculate the amount of the threads for this loop
    if [ $MEMTIER_THREADS -eq 0 ];
    then
        MEMTIER_THREADS=1
    else
        MEMTIER_THREADS=$(($MEMTIER_THREADS << 1))
    fi

    # Skip if the amount of threads is less than the minimum
    if [ $MEMTIER_THREADS -lt $MIN_THREADS ];
    then
        continue
    fi

    # Calculate the number of threads
    echo $MEMTIER_THREADS
    continue

    # Give an overview of the next run and wait for user input
    MEMTIER_echo "> Running memtier with <${MEMTIER_THREADS}> threads and <${CLIENTS_PER_THREAD}> clients per thread"
    read -p "> Press enter to start" my_var 

    # Loop over the commands to test
    for COMMAND in "set" "get";
    do
        # Set the output paths
        MEMTIER_OUTPUT_BASE_PATH="${BENCHMARK_OUTPUT_BASE_PATH}/${BENCHMARK_NAME}/t${MEMTIER_THREADS}/${COMMAND}"
        MEMTIER_HDR_OUTPUT_PATH_PREFIX="${MEMTIER_OUTPUT_BASE_PATH}/memtier_hdr"
        MEMTIER_STDOUT_OUTPUT_PATH="${MEMTIER_OUTPUT_BASE_PATH}/memtier_stdout.txt"

        # Set the command string
        MEMTIER_COMMAND_STRING=""
        if [ "${COMMAND}" = "set" ]; then
            MEMTIER_COMMAND_STRING="set __key__ __data__"
        elif [ "${COMMAND}" = "get" ]; then
            MEMTIER_COMMAND_STRING="get __key__"
        fi

        MEMTIER_PIPELINE_PARAMETER=""
        if [ $MEMTIER_PIPELINE -gt 0 ]; then
            MEMTIER_PIPELINE_PARAMETER="--pipeline=${MEMTIER_PIPELINE}"
        fi

        # Create the output directory
        mkdir -p ${MEMTIER_OUTPUT_BASE_PATH}

        # Give a further overview of the run
        echo ">   Benchmark"
        echo ">     Command <${COMMAND}> (command string <${MEMTIER_COMMAND_STRING}>)"
        echo ">     Output written to <${MEMTIER_STDOUT_OUTPUT_PATH}>"
        echo ">     HDR files prefixed with <${MEMTIER_HDR_OUTPUT_PATH_PREFIX}>"

        # Run the benchmark
        memtier_benchmark \
            -s "${MEMTIER_HOST}" \
            -p "${MEMTIER_PORT}" \
            MEMTIER_-c "${CLIENTS_PER_THREAD}" \
            -t "${MEMTIER_THREADS}" \
            --test-time=${MEMTIER_TEST_DURATION} \
            --print-percentiles=90,99,99.9,99.99,99.999 \
            --distinct-client-seed \
            --data-size=${MEMTIER_DATA_SIZE} \
            --key-minimum=10000000 \
            --key-maximum=20000000 \
            --command="${MEMTIER_COMMAND_STRING}" \
            --command-key-pattern=G \
            --command-ratio=1 \
            ${MEMTIER_PIPELINE_PARAMETER} \
            --hdr-file-prefix=${MEMTIER_HDR_OUTPUT_PATH_PREFIX} \
            --hide-histogram \
            -x ${MEMTIER_TEST_RUNS} > ${MEMTIER_STDOUT_OUTPUT_PATH}
    done

    echo "> Finished benchmarking with <${MEMTIER_THREADS}> threads"
done
