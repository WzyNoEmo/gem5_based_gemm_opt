#!/bin/bash
OUTPUT_FILE="autorun_riscv.txt"
STATS_FILE="m5out/stats.txt"

# ����X86��·���������ļ�
X86_GEM5_PATH="build/X86/gem5.opt"
X86_CONFIG_FILE="configs/learning_gem5/part1/my_two_level.py"
X86_BINARY_PATH="tests/gemm/baseline"

> $OUTPUT_FILE

    # ����ȡ��ͳ������׷�ӵ�����ļ�
    echo "X86 TEXT" >> $OUTPUT_FILE

    #��ȡʱ��
    $X86_GEM5_PATH $X86_CONFIG_FILE $X86_BINARY_PATH --l1d_size=4kB --l2_size=16kB 2>&1 | \
    grep -E "Matrix multiplication took" >> $OUTPUT_FILE

    #��ȡstats��Missrate
    X86_l2_miss_rate=$(grep "system.l2cache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    X86_dcache_miss_rate=$(grep "system.cpu.dcache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    X86_cpi=$(grep "system.cpu.cpi" $STATS_FILE | awk '{print $2}')
    X86_simInsts=$(grep "simInsts" $STATS_FILE | awk '{print $2}')
    X86_simOps=$(grep "simOps" $STATS_FILE | awk '{print $2}')
    X86_dram_read=$(grep "system.mem_ctrl.dram.numReads::total" $STATS_FILE | awk '{print $2}')
    X86_dram_write=$(grep "system.mem_ctrl.dram.numWrites::total" $STATS_FILE | awk '{print $2}')
    
    echo "L2 Cache Overall Miss Rate: $X86_l2_miss_rate" >> $OUTPUT_FILE
    echo "D-Cache Overall Miss Rate: $X86_dcache_miss_rate" >> $OUTPUT_FILE
    echo "CPU CPI: $X86_cpi" >> $OUTPUT_FILE
    echo "simInsts: $X86_simInsts" >> $OUTPUT_FILE
    echo "simOps: $X86_simOps" >> $OUTPUT_FILE
    echo "total dram read: $X86_dram_read" >> $OUTPUT_FILE
    echo "total dram read: $X86_dram_write" >> $OUTPUT_FILE

    # ��ӿ����Էָ���ͬ�Ĳ��������
    echo "" >> $OUTPUT_FILE

# ����RISCV��·���������ļ�
RISCV_GEM5_PATH="build/RISCV/gem5.opt"
RISCV_CONFIG_FILE="configs/learning_gem5/part1/my_two_level_riscv.py"
RISCV_BINARY_PATH="tests/gemm/baseline_rcv"

    # ����ȡ��ͳ������׷�ӵ�����ļ�
    echo "RISCV TEXT" >> $OUTPUT_FILE

    #��ȡʱ��
    $RISCV_GEM5_PATH $RISCV_CONFIG_FILE $RISCV_BINARY_PATH --l1d_size=4kB --l2_size=16kB 2>&1 | \
    grep -E "Matrix multiplication took" >> $OUTPUT_FILE

    #��ȡstats��Missrate
    RISCV_l2_miss_rate=$(grep "system.l2cache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    RISCV_dcache_miss_rate=$(grep "system.cpu.dcache.overallMissRate::total" $STATS_FILE | awk '{print $2}')
    RISCV_cpi=$(grep "system.cpu.cpi" $STATS_FILE | awk '{print $2}')
    RISCV_simInsts=$(grep "simInsts" $STATS_FILE | awk '{print $2}')
    RISCV_simOps=$(grep "simOps" $STATS_FILE | awk '{print $2}')
    RISCV_dram_read=$(grep "system.mem_ctrl.dram.numReads::total" $STATS_FILE | awk '{print $2}')
    RISCV_dram_write=$(grep "system.mem_ctrl.dram.numWrites::total" $STATS_FILE | awk '{print $2}')
    
    echo "L2 Cache Overall Miss Rate: $RISCV_l2_miss_rate" >> $OUTPUT_FILE
    echo "D-Cache Overall Miss Rate: $RISCV_dcache_miss_rate" >> $OUTPUT_FILE
    echo "CPU CPI: $RISCV_cpi" >> $OUTPUT_FILE
    echo "simInsts: $RISCV_simInsts" >> $OUTPUT_FILE
    echo "simOps: $RISCV_simOps" >> $OUTPUT_FILE
    echo "total dram read: $RISCV_dram_read" >> $OUTPUT_FILE
    echo "total dram read: $RISCV_dram_write" >> $OUTPUT_FILE

    # ��ӿ����Էָ���ͬ�Ĳ��������
    echo "" >> $OUTPUT_FILE


echo "Simulation outputs recorded in $OUTPUT_FILE"