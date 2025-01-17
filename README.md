# overlays
[![Build](https://github.com/radxa/overlays/actions/workflows/build.yml/badge.svg)](https://github.com/radxa/overlays/actions/workflows/build.yml)

Additional device tree overlays to support different hardware on Radxa products

## Build overlays in-tree

You will need [this patch](https://github.com/radxa-repo/bsp/blob/main/linux/latest/0100-vendor/0001-VENDOR-Add-Radxa-overlays.patch) so this repo can be built with the kernel.

The official overlays are built in-tree, and is delivered as part of the kernel package.

## Build overlays locally

First, make sure you have the running kernel header, `gcc`, and `device-tree-compiler` installed.

You can then run the following command to build overlays:

```bash
make -j$(nproc)
```

Please be aware this only build a subset of overlays, and any overlays that depend on vendor headers will fail. This is because the Makefile is intended to find overlays that are incompatible with upstream kernel.

To delete built overlays, run the following command:

```bash
make clean
```

## Download prebuilt artifacts

As part of our CI pipeline, the built overlays are uploaded at the end. You can find all CI runs [here](https://github.com/radxa/overlays/actions), and the artifact is located inside each indvidual run.

Please be aware that artifacts expire over time, and they are not officially tested versions.

## Metadata specs

Currently, we mandate a custom `metadata` node in overlays. This data is parsed by [`rsetup`](https://github.com/radxa-pkg/rsetup) to provide a human readable description and conflict detection. Below is a sample `metadata` node with detailed guidelines after:

```
/ {
	metadata {
		title = "Enable ENC28J60 on SPI2";
		compatible = "unknown";
		category = "misc";
		exclusive = "GPIO2_B3", "GPIO2_B2", "GPIO2_B1", "GPIO2_B4", "GPIO4_A7";
		description = "Enable Microchip ENC28J60 SPI Ethernet controller on SPI2.\nINT=40";
	};
};
```

### A. Title (string)

1. `title` should not contain the product name.  
   `rsetup` will only show compatible overlays with `compatible` field. As such, do not confuse users to second guess if an overlay is truly compatible when the product name is not explicitly mentioned.
2. `title` should not end with a period.

### B. Compatible (array)

1. `compatible` should not be an SoC unless it is truly compatible with every products using that SoC.  
   `rsetup` will match the base device tree's `compatible` with the overlay's `compatible`. As long as one value from each match, the overlay is considered compatible. Since most products' device tree contains their SoC in `compatible`, setting SoC in overlay's `compatible` will make it compatible with every such product.  
   Explicit products list should be preferred to generic SoC matching.
2. If a overlay is broken, `compatible` should be `unknown`.

### C. Category (string)

1. `category` currently can be one of the following:  
   camera, display, misc

### D. Exclusive (array)

1. `exclusive` should refer to the device tree node and property.
2. For features that are muxed to a GPIO line, `exclusive` should be the GPIO ID.
3. For features that use multiple GPIO lines, they should all be listed under `exclusive`.

### E. Description (string)

1. `description` is a multi line text to describe the function of the overlay. It can be the same as `title` with an ending period.
2. Newline in `description` should use `\n`.
3. Hardware parameters should be listed at the end to help user to connect their devices.
