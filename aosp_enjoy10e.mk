#
# Copyright (C) 2025 The Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_base.mk)

# Inherit some common TWRP stuff.
$(call inherit-product, vendor/twrp/config/common.mk)

# Inherit from enjoy10e device
$(call inherit-product, device/huawei/enjoy10e/device.mk)

PRODUCT_DEVICE := enjoy10e
PRODUCT_NAME := aosp_enjoy10e
PRODUCT_BRAND := HUAWEI
PRODUCT_MODEL := Huawei Enjoy 10E
PRODUCT_MANUFACTURER := HUAWEI