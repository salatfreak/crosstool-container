# Building Toolchains for Cross Compilation
It may not always be feasable to compile software on the device it is supposed
to run on. This is especially the case for embedded devices. The
[crosstool-NG][crosstool] project assists in bulding compiler toolchains for a
wide range of architectures. These toolchains can be used for compiling C
programs but they are also required for cross compiling *Rust* programs e. g.

Stable pre-built versions of *crosstool-NG* are hard to come by. With this
repository you can compile a container based build yourself. It will also build
a custom version of the *strip* executable with support for striping *ELF*
binaries for a selection of common target architectures. Without this, building
toolchains for some targets will fail.

[crosstool]: https://github.com/crosstool-ng/crosstool-ng

## Building
To build the crosstool container install *podman* and run `podman build -t
crosstool .` in the root directory of this repository. Using *docker* instead
of podman should work exactly the same.

## Usage
- Create a new directory for your toolchain and change to it.
- List the available presets: `crosstool.sh list-samples 2>/dev/null`
- Select a sample: `crosstool.sh <SAMPLE NAME>`
- Make modifications: `crosstool.sh menuconfig`
- Build your toolchain: `crosstool.sh build.4` (for 4 parallel jobs)
- Wait for an approximate eternity.

If everything succeeded, your toolchain has now been placed in the
*x-tools/<TOOLCHAIN NAME>* directory.

## Automated Configuration
For automation of the build process, you can save the current config using
`crosstool.sh savedefconfig` and update the current configuration using
`crosstool.sh defconfig`. The config path can be specified by setting the
*DEFCONFIG* environment variable inside the container, e. g. by modifying the
*crosstool.sh* script.
