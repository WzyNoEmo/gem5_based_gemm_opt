# gem5 环境搭建

由于 anaconda 在虚拟环境中安装存在依赖包找不到的问题，因此采用 docker 完成环境搭建。

## 拉取 docker 镜像


```
docker pull ghcr.io/gem5/ubuntu-20.04_all-dependencies:v23-0
```
## 拉取 gem5 代码
为了与 docker 环境对应，这里下载分支 v23.0
```
git clone -b v23.0 https://github.com/gem5/gem5
```
增加执行权限
```
chmod -R 777 ./gem5
```

## 启动 docker 镜像

```
docker run -u root --volume /home/wangzy/gem5:/gem5 --rm -it ghcr.io/gem5/ubuntu-20.04_all-dependencies:v23-0

docker run -u $UID:$GID --volume /home/wangzy/gem5:/gem5 --rm -it ghcr.io/gem5/ubuntu-20.04_all-dependencies:v23-0
```


此后终端打印如下信息进入 docker
```
root@c3da92038e2f:/# 
```

## 在容器内构建gem5

这里以构建X86为例，如需构建RISCV，需要对命令进行简单修改。
```
scons build/X86/gem5.opt -j 32
```

# gem5 运行
参考 https://www.gem5.org/documentation/learning_gem5/part1/simple_config/ 。

```
build/X86/gem5.opt configs/learning_gem5/part1/simple.py        //no-cache
build/X86/gem5.opt configs/learning_gem5/part1/two_level.py     //2level-cache
build/X86/gem5.opt configs/deprecated/example/se.py --cmd=tests/test-progs/hello/bin/x86/linux/hello --cpu-type=TimingSimpleCPU --l1d_size=64kB --l1i_size=16kB --caches       //使用se.py配置脚本
```
以上为官方提供配置脚本与参考命令，基于官方的two_level.py脚本，构建了更好适配本实验的脚本my_two_level.py，同时对cache.py进行修改，增加在命令行中指定替换策略的args参数。

进一步地，为了进行不同方向测试案例的批量化测试，构建了bash脚本
+ autorun_cache.sh
+ autorun_rp.sh
+ autorun_cpu.sh
+ autorun_riscv.sh

以上脚本分别为进行不同缓存size，缓存替换策略（replacement policy），cpu type（in order/3o）以及指令集架构（RISCV/X86）下GEMM的gem5仿真，同时脚本自动化从gem5仿真器输出m5out中提取关心参数。同时，脚本对输出信息进行过滤后打印在同名的txt文件下。