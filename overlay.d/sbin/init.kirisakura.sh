#!/system/bin/sh 

sleep 15;

# Applying Kirisakura Settings

# Disable sched_boost during CONSERVATIVE_BOOST
#	echo 0 > /dev/stune/foreground/schedtune.sched_boost_no_override
#	echo 0 > /dev/stune/top-app/schedtune.sched_boost_no_override

# Tune Core_CTL for proper task placement
#	echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable
#	echo 0 > /sys/devices/system/cpu/cpu4/core_ctl/enable
#	echo 0 > /sys/devices/system/cpu/cpu7/core_ctl/enable




# Disable CAF task placement for Big Cores
#	echo 0 > /proc/sys/kernel/sched_walt_rotate_big_tasks

# Core control parameters for gold
#	echo 2 > /sys/devices/system/cpu/cpu4/core_ctl/min_cpus
#	echo 60 > /sys/devices/system/cpu/cpu4/core_ctl/busy_up_thres
#	echo 30 > /sys/devices/system/cpu/cpu4/core_ctl/busy_down_thres
#	echo 100 > /sys/devices/system/cpu/cpu4/core_ctl/offline_delay_ms
#	echo 3 > /sys/devices/system/cpu/cpu4/core_ctl/task_thres

# Core control parameters for gold+
#	echo 0 > /sys/devices/system/cpu/cpu7/core_ctl/min_cpus
#	echo 60 > /sys/devices/system/cpu/cpu7/core_ctl/busy_up_thres
#	echo 30 > /sys/devices/system/cpu/cpu7/core_ctl/busy_down_thres
#	echo 100 > /sys/devices/system/cpu/cpu7/core_ctl/offline_delay_ms
#	echo 1 > /sys/devices/system/cpu/cpu7/core_ctl/task_thres
# Controls how many more tasks should be eligible to run on gold CPUs
# w.r.t number of gold CPUs available to trigger assist (max number of
# tasks eligible to run on previous cluster minus number of CPUs in
# the previous cluster).
#
# Setting to 1 by default which means there should be at least
# 4 tasks eligible to run on gold cluster (tasks running on gold cores
# plus misfit tasks on silver cores) to trigger assitance from gold+.
#	echo 1 > /sys/devices/system/cpu/cpu7/core_ctl/nr_prev_assist_thresh

# Disable Core control on silver
#	echo 0 > /sys/devices/system/cpu/cpu0/core_ctl/enable

# Setting b.L scheduler parameters
	echo 94 94 > /proc/sys/kernel/sched_upmigrate
	echo 84 84 > /proc/sys/kernel/sched_downmigrate
	echo 100 > /proc/sys/kernel/sched_group_upmigrate
	echo 10 > /proc/sys/kernel/sched_group_downmigrate
	echo 1 > /proc/sys/kernel/sched_walt_rotate_big_tasks


# Use WALT
	echo 1 > /proc/sys/kernel/sched_use_walt_cpu_util
	echo 1 > /proc/sys/kernel/sched_use_walt_task_util

# Tweak IO performance after boot complete
	echo "cfq" > /sys/block/sda/queue/scheduler
	echo 128 > /sys/block/sda/queue/read_ahead_kb
	echo 128 > /sys/block/dm-0/queue/read_ahead_kb

# Input boost and stune configuration
	echo "0:1113600 1:0 2:0 3:0 4:1171200 5:0 6:0 7:0" > /sys/module/cpu_boost/parameters/input_boost_freq
	echo 1500 > /sys/module/cpu_boost/parameters/input_boost_ms
	echo 30 > /sys/module/cpu_boost/parameters/dynamic_stune_boost
	echo 1500 > /sys/module/cpu_boost/parameters/dynamic_stune_boost_ms

# Dynamic Stune Boost during sched_boost
#	echo 15 > /dev/stune/top-app/schedtune.sched_boost

# Set min cpu freq
	echo 576000 > /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq
	echo 710400 > /sys/devices/system/cpu/cpu4/cpufreq/scaling_min_freq
	echo 825600 > /sys/devices/system/cpu/cpu7/cpufreq/scaling_min_freq

# Setup Schedutil Governor
#	echo "schedutil" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
#	echo 500 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/up_rate_limit_us
#	echo 20000 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/down_rate_limit_us
#	echo 1 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/iowait_boost_enable
#	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/pl
#	echo 0 > /sys/devices/system/cpu/cpufreq/policy0/schedutil/hispeed_freq

#	echo "schedutil" > /sys/devices/system/cpu/cpu4/cpufreq/scaling_governor	
#	echo 500 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/up_rate_limit_us
#	echo 20000 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/down_rate_limit_us
#	echo 1 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/iowait_boost_enable
#	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/pl
#	echo 0 > /sys/devices/system/cpu/cpufreq/policy4/schedutil/hispeed_freq

#	echo "schedutil" > /sys/devices/system/cpu/cpu7/cpufreq/scaling_governor	
#	echo 500 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/up_rate_limit_us
#	echo 20000 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/down_rate_limit_us
#	echo 1 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/iowait_boost_enable
#	echo 0 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/pl
#	echo 0 > /sys/devices/system/cpu/cpufreq/policy7/schedutil/hispeed_freq

# Setup EAS cpusets values for better load balancing
	echo 0-7 > /dev/cpuset/top-app/cpus
	echo 0-3,5-6 > /dev/cpuset/foreground/cpus
	echo 0-3 > /dev/cpuset/background/cpus
	echo 0-3  > /dev/cpuset/system-background/cpus
	echo 2-3  > /dev/cpuset/audio-app/cpus
	echo 0-3 > /dev/cpuset/restricted/cpus

# Tune FS
	echo 3000 > /proc/sys/vm/dirty_expire_centisecs
	echo 10 > /proc/sys/vm/dirty_background_ratio

sleep 5;

#    echo 3 > /sys/sweep2sleep/sweep2sleep

echo "Kirisakura-Kernel Setup Finished" >> /dev/kmsg
