#
# Copyright (C) 2025 The Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

LOCAL_PATH := $(call my-dir)

#
# kernel.img
#

INTERNAL_CUSTOM_BOOTIMAGE_ARGS := --base $(BOARD_KERNEL_BASE) --pagesize $(BOARD_KERNEL_PAGESIZE) --kernel $(INSTALLED_KERNEL_TARGET) --cmdline "$(BOARD_KERNEL_CMDLINE) buildvariant=userdebug"

$(INSTALLED_BOOTIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS) $(INSTALLED_KERNEL_TARGET)
	$(call pretty,"Target boot image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_CUSTOM_BOOTIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) $(BOARD_MKBOOTIMG_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))

#
# recovery_kernel.img
#

INSTALLED_RECOVERYKERNELIMAGE_TARGET := $(PRODUCT_OUT)/recovery_kernel.img
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilts/dtb.img
TARGET_PREBUILT_DTBO := $(DEVICE_PATH)/prebuilts/dtbo.img
RECOVERY_KERNEL_DUMMY_RAMDISK := $(PRODUCT_OUT)/recovery_kernel_dummy_ramdisk
RECOVERY_KERNEL_DUMMY_SECOND := $(PRODUCT_OUT)/recovery_kernel_dummy_second

$(RECOVERY_KERNEL_DUMMY_RAMDISK):
	$(hide) echo "dummy" > $@

$(RECOVERY_KERNEL_DUMMY_SECOND):
	$(hide) echo "dummy" > $@

INTERNAL_CUSTOM_RECOVERYKERNELIMAGE_ARGS := --base 0x40078000 --pagesize 2048 --kernel $(INSTALLED_KERNEL_TARGET) --ramdisk $(RECOVERY_KERNEL_DUMMY_RAMDISK) --second $(RECOVERY_KERNEL_DUMMY_SECOND) --dtb $(TARGET_PREBUILT_DTB) --recovery_dtbo $(TARGET_PREBUILT_DTBO) --cmdline "bootopt=64S3,32N2,64N2 unmovable_isolate1=2:256M,3:312M,4:348M buildvariant=$(TARGET_BUILD_VARIANT)" --kernel_offset 0x00008000 --ramdisk_offset 0x11a88000 --second_offset 0x00e88000 --tags_offset 0x07808000 --header_version 2

.PHONY: recoverykernelimage
recoverykernelimage: $(INSTALLED_RECOVERYKERNELIMAGE_TARGET)

$(INSTALLED_RECOVERYKERNELIMAGE_TARGET): $(MKBOOTIMG) $(INTERNAL_BOOTIMAGE_FILES) $(BOOTIMAGE_EXTRA_DEPS) $(INSTALLED_KERNEL_TARGET) $(TARGET_PREBUILT_DTB) $(TARGET_PREBUILT_DTBO) $(RECOVERY_KERNEL_DUMMY_RAMDISK) $(RECOVERY_KERNEL_DUMMY_SECOND)
	$(call pretty,"Target recovery kernel image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_CUSTOM_RECOVERYKERNELIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_BOOTIMAGE_PARTITION_SIZE))

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_RECOVERYKERNELIMAGE_TARGET)

#
# recovery_ramdisk.img
#

INTERNAL_CUSTOM_RECOVERYIMAGE_ARGS := --base 0x80000000 --pagesize 2048 --kernel /dev/null --ramdisk $(recovery_ramdisk) --cmdline "slub_min_objects=12 unmovable_isolate1=2:192M,3:224M,4:256M buildvariant=$(TARGET_BUILD_VARIANT)" --kernel_offset 0x00008000 --ramdisk_offset 0x02000000 --second_offset 0x00f00000 --tags_offset 0x00000100 --header_version 0

.PHONY: recoveryimage
recoveryimage: recoveryvendorimage $(INSTALLED_RECOVERYIMAGE_TARGET)

$(INSTALLED_RECOVERYIMAGE_TARGET): $(MKBOOTIMG) $(recovery_ramdisk) $(INSTALLED_RECOVERYKERNELIMAGE_TARGET) $(INSTALLED_RECVENDORIMAGE_TARGET)
	@echo "----- Making recovery image ------"
	$(hide) $(MKBOOTIMG) $(INTERNAL_CUSTOM_RECOVERYIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(BOARD_RECOVERYIMAGE_PARTITION_SIZE))

#
# ramdisk-recovery_vendor.img
#

INSTALLED_RECVENDOR_RAMDISK_TARGET := $(PRODUCT_OUT)/ramdisk-recovery_vendor.img
INSTALLED_RECVENDOR_RAMDISK_PLACEHOLDER_TARGET := $(PRODUCT_OUT)/ramdisk-recovery_vendor

$(INSTALLED_RECVENDOR_RAMDISK_PLACEHOLDER_TARGET):
	$(hide) mkdir -p $@/vendor
	$(hide) touch $@/vendor/placeholder

$(INSTALLED_RECVENDOR_RAMDISK_TARGET): $(MKBOOTFS) $(MINIGZIP) $(INSTALLED_RECVENDOR_RAMDISK_PLACEHOLDER_TARGET)
	$(call pretty,"Target recovery_vendor ramdisk image: $@")
	$(hide) $(MKBOOTFS) -d $(PRODUCT_OUT) $(INSTALLED_RECVENDOR_RAMDISK_PLACEHOLDER_TARGET) | $(MINIGZIP) > $@

#
# recovery_vendor.img
#

INSTALLED_RECVENDORIMAGE_TARGET := $(PRODUCT_OUT)/recovery_vendor.img
INTERNAL_CUSTOM_RECVENDORIMAGE_ARGS := --base 0x10078000 --pagesize 2048 --kernel /dev/null --ramdisk $(INSTALLED_RECVENDOR_RAMDISK_TARGET) --cmdline "buildvariant=$(TARGET_BUILD_VARIANT)" --kernel_offset 0x00008000 --ramdisk_offset 0x11a88000 --second_offset 0x00e88000 --tags_offset 0x07808000 --header_version 0

.PHONY: recoveryvendorimage
recoveryvendorimage: $(INSTALLED_RECVENDORIMAGE_TARGET)

$(INSTALLED_RECVENDORIMAGE_TARGET): $(MKBOOTIMG) $(INSTALLED_RECVENDOR_RAMDISK_TARGET)
	$(call pretty,"Target recovery_vendor image: $@")
	$(hide) $(MKBOOTIMG) $(INTERNAL_CUSTOM_RECVENDORIMAGE_ARGS) $(INTERNAL_MKBOOTIMG_VERSION_ARGS) --output $@
	$(hide) $(call assert-max-image-size,$@,$(call get-hash-image-max-size,$(BOARD_RECVENDORIMAGE_PARTITION_SIZE)))

INSTALLED_RADIOIMAGE_TARGET += $(INSTALLED_RECVENDORIMAGE_TARGET)
