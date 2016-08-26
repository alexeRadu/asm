#!/bin/bash

mkdir disk
mount -t vfat -o loop disk.img ./disk
