BASE_PATH="/home/daalbano/dev/cachegrand-benchmarks/benchmarks"

unset PLATFORMS
declare -A PLATFORMS=( [cachegrand]="v0.2.1" [dragonfly]="v1.1.2" [keydb]="v6.3.2" [redis]="v7.0.11" )

echo ${!PLATFORMS[*]}

echo "PlatformName,PlatformVersion,BenchmarkSpecs,BenchmarkNode,Threads,Command,Ops,p90,p99,p99.9,p99.99,p99.999"

for MEMTIER_STDOUT_PATH in $(find $BASE_PATH -name memtier_stdout.txt);
do
    REL_PATH=${MEMTIER_STDOUT_PATH:$((${#BASE_PATH} + 1))}
    PLATFORM_NAME=$(echo $REL_PATH | cut -d '/' -f 1)
    PLATFORM_VERSION=$(echo $REL_PATH | cut -d '/' -f 2)

    if ! [[ -v "PLATFORMS[$PLATFORM_NAME]" ]] || [ "${PLATFORMS[$PLATFORM_NAME]}" != "$PLATFORM_VERSION" ];
    then
        continue
    fi

    BENCHMARK_SPECS=$(echo $REL_PATH | cut -d '/' -f 3)
    BENCHMARK_NODE=$(echo $REL_PATH | cut -d '/' -f 4)
    THREADS=$(echo $REL_PATH | cut -d '/' -f 5 | cut -b2-)
    COMMAND=$(echo $REL_PATH | cut -d '/' -f 6)

    echo -n "$PLATFORM_NAME,$PLATFORM_VERSION,$BENCHMARK_SPECS,$BENCHMARK_NODE,$THREADS,$COMMAND,"
    DATA=$(cat $MEMTIER_STDOUT_PATH | grep BEST -A 5 | grep Totals | awk '{ print $2 "," $4 "," $5 "," $6 "," $7 "," $8 '})
    if [ -z "$DATA" ];
    then
        DATA=$(cat $MEMTIER_STDOUT_PATH | grep "ALL STATS" -A 5 | grep Totals | awk '{ print $2 "," $4 "," $5 "," $6 "," $7 "," $8 '})
    fi

    echo $DATA
done
