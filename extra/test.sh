#!/usr/bin/env bash
Xephyr :5 -screen 2880x1800 & sleep 1 ; DISPLAY=:5 awesome
