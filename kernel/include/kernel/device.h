#ifndef _KERNEL_DEVICE_H
#define _KERNEL_DEVICE_H

#include <stdint.h>

typedef enum {
  CHARDEVICE = 1,
  BLOCKDEVICE = 2,
} device_type_t;

struct device {
  const char *name;
  uint32_t id;
  device_type_t dev_type;
  uint32_t (*read)(uint8_t *buf, uint8_t offset, uint32_t length, void *device);
  uint32_t (*write)(uint8_t *buf, uint8_t offset, uint32_t length,
                    void *device);
};

void add_device(struct device *dev);
void init_device();

#endif //_KERNEL_DEVICE_H
