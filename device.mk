#
# Copyright (C) 2025 The Team Win Recovery Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Dynamic
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Fastbootd
PRODUCT_PACKAGES += \
    fastbootd

PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.0-impl-mock \
    android.hardware.fastboot@1.0-impl-mock.recovery

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 29
