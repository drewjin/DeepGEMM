# 初始化项目代码

若你的 clone 方式是如下方式：

```sh
git clone git@github.com:deepseek-ai/DeepGEMM.git
```

则需要初始化 submodules：

```sh
git submodule update --init --recursive
```

否则就是如下形式，直接就初始化了：

```sh
git clone --recursive git@github.com:deepseek-ai/DeepGEMM.git
```

# 虚拟环境创建

使用如下脚本创建虚拟环境，并启动：

```sh
uv sync
source .venv/bin/activate
```

# 构建环境并测试

首先下载 `bear`，用于保证构建过程生成 `compile_commands.json` 这个文件，这个文件会用于辅助 `clangd` 生成索引，对读代码有好处。

随后，便可以使用如下脚本编译构建（我魔改了一下开发脚本，用以保证可控制是否生成 `compile_commands.json`。

```sh
./develop.sh -c
```