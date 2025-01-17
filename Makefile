CONFIG_CLK_RK3308 ?= rockchip
CONFIG_CLK_RK3399 ?= rockchip
CONFIG_CLK_RK3568 ?= rockchip
CONFIG_CLK_RK3588 ?= rockchip
CONFIG_ARCH_MESON ?= amlogic
include $(wildcard arch/arm64/boot/dts/*/overlays/Makefile)

DTBO-AMLOGIC	:=	$(addprefix arch/arm64/boot/dts/amlogic/overlays/,$(dtb-amlogic))
DTBO-ROCKCHIP	:=	$(addprefix arch/arm64/boot/dts/rockchip/overlays/,$(dtb-rockchip))
DTBO			:=	$(DTBO-AMLOGIC) $(DTBO-ROCKCHIP)
TMP				:=	$(addsuffix .tmp,$(DTBO))

.PHONY: all
all: build

#
# Build
#
.PHONY: build
build: $(DTBO)

%.dtbo: %.dts
	cpp -x assembler-with-cpp -E -I "/usr/src/linux-headers-$(shell uname -r)/include" -I "/usr/lib/modules/$(shell uname -r)/build/include" "$<" "$@.tmp"
	dtc -q -@ -I dts -O dtb -o "$@" "$@.tmp"

#
# Clean
#
.PHONY: distclean
distclean: clean

.PHONY: clean
clean:
	rm -rf $(DTBO) $(TMP)
