#!/bin/bash

# ����gem5��·���������ļ�
GEM5_PATH="build/X86/gem5.opt"
CONFIG_FILE="configs/learning_gem5/part1/my_two_level.py"
BINARY_PATH="tests/gemm/baseline"
OUTPUT_FILE="autorun_cpu.txt"
STATS_FILE="m5out/stats.txt"

#> $OUTPUT_FILE
echo "cpu type : o3" >> $OUTPUT_FILE

# ����Ҫ���Ե�L1d��L2�����������
declare -a l1d_sizes=("4kB"  "128kB")
declare -a l2_sizes=("16kB"  "256kB")

# ѭ��ִ��gem5����
for i in "${!l1d_sizes[@]}"; do
    l1d_size=${l1d_sizes[$i]}
    l2_size=${l2_sizes[$i]}

    # ����ȡ��ͳ������׷�ӵ�����ļ�
    echo "L1d size: $l1d_size, L2 size: $l2_size" >> $OUTPUT_FILE

    #��ȡʱ��
    $GEM5_PATH $CONFIG_FILE $BINARY_PATH --l1d_size=$l1d_size --l2_size=$l2_size 2>&1 | \
    grep -E "Matrix multiplication took" >> $OUTPUT_FILE

    #��ȡstats��Missrate
    l2_miss_rate=$(grep "system.l2cache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    dcache_miss_rate=$(grep "system.cpu.dcache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    cpi=$(grep "system.cpu.cpi" $STATS_FILE | awk '{print $2}')
    echo "L2 Cache Overall Miss Rate: $l2_miss_rate" >> $OUTPUT_FILE
    echo "D-Cache Overall Miss Rate: $dcache_miss_rate" >> $OUTPUT_FILE
    echo "CPU CPI: $cpi" >> $OUTPUT_FILE

    # ��ӿ����Էָ���ͬ�Ĳ��������
    echo "" >> $OUTPUT_FILE
done

echo "Simulation outputs recorded in $OUTPUT_FILE"