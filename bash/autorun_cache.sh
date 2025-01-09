#!/bin/bash

# 定义gem5的路径和配置文件
GEM5_PATH="build/X86/gem5.opt"
CONFIG_FILE="configs/learning_gem5/part1/my_two_level.py"
BINARY_PATH="tests/gemm/baseline"
OUTPUT_FILE="autorun_cache.txt"
STATS_FILE="m5out/stats.txt"

> $OUTPUT_FILE

# 定义要测试的L1d和L2缓存容量组合
declare -a l1d_sizes=("4kB" "4kB"  "4kB"  "4kB"   "8kB"   "16kB"  "32kB"  "64kB" "128kB")
declare -a l2_sizes=("16kB" "32kB" "64kB" "128kB" "128kB" "128kB" "128kB" "128kB" "256kB")

# 循环执行gem5仿真
for i in "${!l1d_sizes[@]}"; do
    l1d_size=${l1d_sizes[$i]}
    l2_size=${l2_sizes[$i]}

    # 将提取的统计数据追加到输出文件
    echo "L1d size: $l1d_size, L2 size: $l2_size" >> $OUTPUT_FILE

    #提取时间
    $GEM5_PATH $CONFIG_FILE $BINARY_PATH --l1d_size=$l1d_size --l2_size=$l2_size 2>&1 | \
    grep -E "Matrix multiplication took" >> $OUTPUT_FILE

    #提取stats的Missrate
    l2_miss_rate=$(grep "system.l2cache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    dcache_miss_rate=$(grep "system.cpu.dcache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    echo "L2 Cache Overall Miss Rate: $l2_miss_rate" >> $OUTPUT_FILE
    echo "D-Cache Overall Miss Rate: $dcache_miss_rate" >> $OUTPUT_FILE

    # 添加空行以分隔不同的测试组输出
    echo "" >> $OUTPUT_FILE
done

echo "Simulation outputs recorded in $OUTPUT_FILE"