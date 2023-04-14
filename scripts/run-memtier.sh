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
MIN_THREADS=64
MAX_THREADS=64
CLIENTS_PER_THREAD=25
MEMTIER_TEST_DURATION=60
MEMTIER_TEST_RUNS=3
MEMTIER_DATA_SIZE=64

# Calcuate the end of the sequence
SEQ_START=$(( $(echo "sqrt($MIN_THREADS)" | bc) - 2 ))
SEQ_END=$(( $(echo "sqrt($MAX_THREADS)" | bc) - 2 ))

# Run the benchmarks
for I in $(seq $SEQ_START $SEQ_END);
do
    # Calculate the number of threads
    MEMTIER_THREADS=$((2**$I))

    # Give an overview of the next run and wait for user input
    echo "> Running memtier with <${MEMTIER_THREADS}> threads and <${CLIENTS_PER_THREAD}> clients per thread"
    read -p "> Press enter to start" my_var 

    # Loop over the commands to test
    for COMMAND in "set" "get";
    do
        # Set the output paths
        MEMTIER_OUTPUT_BASE_PATH="/root/cachegrand-benches/redis-6.0.16-c25/t${MEMTIER_THREADS}/${COMMAND}"
        MEMTIER_HDR_OUTPUT_PATH_PREFIX="${MEMTIER_OUTPUT_BASE_PATH}/memtier_hdr"
        MEMTIER_STDOUT_OUTPUT_PATH="${MEMTIER_OUTPUT_BASE_PATH}/memtier_stdout.txt"

        # Set the command string
        MEMTIER_COMMAND_STRING=""
        if [ "${COMMAND}" = "set" ]; then
            MEMTIER_COMMAND_STRING="set __key__ __data__"
        elif [ "${COMMAND}" = "get" ]; then
            MEMTIER_COMMAND_STRING="get __key__"
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
            -s "147.28.182.119" \
            -p "6379" \
            -c "${CLIENTS_PER_THREAD}" \
            -t "${MEMTIER_THREADS}" \
            --test-time=${MEMTIER_TEST_DURATION} \
            --print-percentiles=90,99,99.9,99.99,99.999 \
            --randomize \
            --distinct-client-seed \
            --data-size=${MEMTIER_DATA_SIZE} \
            --key-minimum=10000000 \
            --key-maximum=20000000 \
            --command="${MEMTIER_COMMAND_STRING}" \
            --command-ratio=1 \
            --command-key-pattern=G \
            --hdr-file-prefix=${MEMTIER_HDR_OUTPUT_PATH_PREFIX} \
            --hide-histogram \
            -x ${MEMTIER_TEST_RUNS} > ${MEMTIER_STDOUT_OUTPUT_PATH}

        # Check if the run failed
        if [ $? -ne 0 ]; then
            # Print the error on the stderr and exit
            echo ">   Benchmark failed" >&2
            exit 1
        fi
    done

    echo "> Finished benchmarking with <${MEMTIER_THREADS}> threads"
done
