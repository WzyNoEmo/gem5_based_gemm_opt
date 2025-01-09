#!/bin/bash

# 定义gem5的路径和配置文件
GEM5_PATH="build/X86/gem5.opt"
CONFIG_FILE="configs/learning_gem5/part1/my_two_level.py"
BINARY_PATH="tests/gemm/baseline"
OUTPUT_FILE="autorun_my_rp.txt"
STATS_FILE="m5out/stats.txt"

> $OUTPUT_FILE

# 定义要测试的替换策略
#declare -a replacement_policies=("lru" "mru" "plru" "lfu" "bip" "lip" "random" "fifo" "nru" "rrip")
declare -a replacement_policies=("random" "weightedrandom")
# 循环执行gem5仿真
for rp in "${replacement_policies[@]}"; do
    echo "replacement policy: $rp" >> $OUTPUT_FILE
    
    #提取时间
    $GEM5_PATH $CONFIG_FILE $BINARY_PATH --l1d_size=4kB --l2_size=16kB --l1d_rp=$rp --l2_rp=$rp 2>&1 | \
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