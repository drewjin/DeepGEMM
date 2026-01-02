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
source .venv/bin/activate`
```

# 构建环境并测试

首先下载 `bear`，用于保证构建过程生成 `compile_commands.json` 这个文件，这个文件会用于辅助 `clangd` 生成索引，对读代码有好处。

随后，便可以使用如下脚本编译构建（我魔改了一下开发脚本，用以保证可控制是否生成 `compile_commands.json`。

```sh
./develop.sh -c
```

此时应该有如下文件：`build/compile_commands.json` 和 `deep_gemm/_C.cpython-312-x86_64-linux-gnu.so`

第一个是用来读和写代码的，第二个是我们会用到的包的动态链接库。

随后便可以将项目实际构建到我们的虚拟环境中：

```sh
uv pip install -e . --no-build-isolation
```

此时便可以直接使用 `deep_gemm` 这个包了。

运行测试脚本查看是否可以正常跑：

```sh
# Naive Run
scripts/test_all.sh

# Run with Logs
mkdir -p log && scripts/test_all.sh 2>&1 | tee log/test_all.log
```

全部跑通就算构建完成了，现在点进 `csrc` 里也能正常索引代码，python 代码则更不必说了。