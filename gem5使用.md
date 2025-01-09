# gem5 �����

���� anaconda �����⻷���а�װ�����������Ҳ��������⣬��˲��� docker ��ɻ������

## ��ȡ docker ����


```
docker pull ghcr.io/gem5/ubuntu-20.04_all-dependencies:v23-0
```
## ��ȡ gem5 ����
Ϊ���� docker ������Ӧ���������ط�֧ v23.0
```
git clone -b v23.0 https://github.com/gem5/gem5
```
����ִ��Ȩ��
```
chmod -R 777 ./gem5
```

## ���� docker ����

```
docker run -u root --volume /home/wangzy/gem5:/gem5 --rm -it ghcr.io/gem5/ubuntu-20.04_all-dependencies:v23-0

docker run -u $UID:$GID --volume /home/wangzy/gem5:/gem5 --rm -it ghcr.io/gem5/ubuntu-20.04_all-dependencies:v23-0
```


�˺��ն˴�ӡ������Ϣ���� docker
```
root@c3da92038e2f:/# 
```

## �������ڹ���gem5

�����Թ���X86Ϊ�������蹹��RISCV����Ҫ��������м��޸ġ�
```
scons build/X86/gem5.opt -j 32
```

# gem5 ����
�ο� https://www.gem5.org/documentation/learning_gem5/part1/simple_config/ ��

```
build/X86/gem5.opt configs/learning_gem5/part1/simple.py        //no-cache
build/X86/gem5.opt configs/learning_gem5/part1/two_level.py     //2level-cache
build/X86/gem5.opt configs/deprecated/example/se.py --cmd=tests/test-progs/hello/bin/x86/linux/hello --cpu-type=TimingSimpleCPU --l1d_size=64kB --l1i_size=16kB --caches       //ʹ��se.py���ýű�
```
����Ϊ�ٷ��ṩ���ýű���ο�������ڹٷ���two_level.py�ű��������˸������䱾ʵ��Ľű�my_two_level.py��ͬʱ��cache.py�����޸ģ���������������ָ���滻���Ե�args������

��һ���أ�Ϊ�˽��в�ͬ������԰��������������ԣ�������bash�ű�
+ autorun_cache.sh
+ autorun_rp.sh
+ autorun_cpu.sh
+ autorun_riscv.sh

���Ͻű��ֱ�Ϊ���в�ͬ����size�������滻���ԣ�replacement policy����cpu type��in order/3o���Լ�ָ��ܹ���RISCV/X86����GEMM��gem5���棬ͬʱ�ű��Զ�����gem5���������m5out����ȡ���Ĳ�����ͬʱ���ű��������Ϣ���й��˺��ӡ��ͬ����txt�ļ��¡�