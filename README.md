# Real-time systems 

The required runtime is available here: https://github.com/tommasoprandin/ravenscar-full-olimexh405-profiling.

## Getting Started

After installing the runtime as explained in its repository, you have to select the proper toolchain:
```
alr toolchain --select --local
```
select the GNAT version specified in the `alire.toml` file (any `gprbuild` version will work).

After that the program can be compiled by simply running:
```
alr build
```

The ELF file is available under `/obj`, which can be run with any suitable tool (e.g. ST-Link with `openocd`).
For instance to run it with `probe-rs` using a ST-Link V2 on a Olimex H405:
```
probe-rs run --protocol swd --chip stm32f405rgtx --target-output-file semihosting:stdout obj/gee 
```