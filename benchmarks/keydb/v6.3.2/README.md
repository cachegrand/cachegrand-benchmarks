## General specs

### Main server

CPU: 1 x 32c/64t EPYC 7502
RAM: 8 x 32GB 3200MHZ
OS: Ubuntu 22.04, latest kernel 5.15

### Load generation server(s)

CPU: 1 x 32c/64t EPYC 7502
RAM: 8 x 32GB 3200MHZ
OS: Ubuntu 22.04, latest kernel 5.15

`memtier_benchmark` built from the master branch of its git repository on github.

### `uname -a`
Linux cg-server-x64-bench-01 5.15.0-70-generic #77-Ubuntu SMP Tue Mar 21 14:02:37 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux

### `/proc/cpuinfo` first cpu

```
# cat /proc/cpuinfo 
processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 23
model		: 49
model name	: AMD EPYC 7502P 32-Core Processor
stepping	: 0
microcode	: 0x8301052
cpu MHz		: 2495.222
cache size	: 512 KB
physical id	: 0
siblings	: 64
core id		: 0
cpu cores	: 32
apicid		: 0
initial apicid	: 0
fpu		: yes
fpu_exception	: yes
cpuid level	: 16
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 ht syscall nx mmxext fxsr_opt pdpe1gb rdtscp lm constant_tsc rep_good nopl nonstop_tsc cpuid extd_apicid aperfmperf rapl pni pclmulqdq monitor ssse3 fma cx16 sse4_1 sse4_2 x2apic movbe popcnt aes xsave avx f16c rdrand lahf_lm cmp_legacy svm extapic cr8_legacy abm sse4a misalignsse 3dnowprefetch osvw ibs skinit wdt tce topoext perfctr_core perfctr_nb bpext perfctr_llc mwaitx cpb cat_l3 cdp_l3 hw_pstate ssbd mba ibrs ibpb stibp vmmcall fsgsbase bmi1 avx2 smep bmi2 cqm rdt_a rdseed adx smap clflushopt clwb sha_ni xsaveopt xsavec xgetbv1 xsaves cqm_llc cqm_occup_llc cqm_mbm_total cqm_mbm_local clzero irperf xsaveerptr rdpru wbnoinvd amd_ppin arat npt lbrv svm_lock nrip_save tsc_scale vmcb_clean flushbyasid decodeassists pausefilter pfthreshold avic v_vmsave_vmload vgif v_spec_ctrl umip rdpid overflow_recov succor smca sme sev sev_es
bugs		: sysret_ss_attrs spectre_v1 spectre_v2 spec_store_bypass retbleed
bogomips	: 4990.44
TLB size	: 3072 4K pages
clflush size	: 64
cache_alignment	: 64
address sizes	: 43 bits physical, 48 bits virtual
power management: ts ttp tm hwpstate cpb eff_freq_ro [13] [14]
```

### `dmidecode --type 17` first ram slot

```
Handle 0x1100, DMI type 17, 92 bytes
Memory Device
	Array Handle: 0x1000
	Error Information Handle: Not Provided
	Total Width: 72 bits
	Data Width: 64 bits
	Size: 32 GB
	Form Factor: DIMM
	Set: 1
	Locator: A1
	Bank Locator: Not Specified
	Type: DDR4
	Type Detail: Synchronous Registered (Buffered)
	Speed: 3200 MT/s
	Manufacturer: 80AD869D80AD
	Serial Number: 836F054B
	Asset Tag: 01195222
	Part Number: HMA84GR7CJR4N-XN
	Rank: 2
	Configured Memory Speed: 3200 MT/s
	Minimum Voltage: 1.2 V
	Maximum Voltage: 1.2 V
	Configured Voltage: 1.2 V
	Memory Technology: DRAM
	Memory Operating Mode Capability: Volatile memory
	Firmware Version: Not Specified
	Module Manufacturer ID: Unknown
	Module Product ID: Unknown
	Memory Subsystem Controller Manufacturer ID: Unknown
	Memory Subsystem Controller Product ID: Unknown
	Non-Volatile Size: None
	Volatile Size: 32 GB
	Cache Size: None
	Logical Size: None
```

## Network

### general specs

2 x 25gbit ports via a Intel Network Adapter XXV710

### `ip l`

```
# ip l
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN mode DEFAULT group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
2: enp65s0f0: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP mode DEFAULT group default qlen 1000
    link/ether 40:a6:b7:20:2f:e0 brd ff:ff:ff:ff:ff:ff
3: enp65s0f1: <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP> mtu 1500 qdisc mq master bond0 state UP mode DEFAULT group default qlen 1000
    link/ether 40:a6:b7:20:2f:e0 brd ff:ff:ff:ff:ff:ff permaddr 40:a6:b7:20:2f:e1
4: idrac: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
    link/ether 2c:ea:7f:ef:54:d3 brd ff:ff:ff:ff:ff:ff
5: bond0: <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
    link/ether 40:a6:b7:20:2f:e0 brd ff:ff:ff:ff:ff:ff
```

### `ethtool`

```
# ethtool enp65s0f0
Settings for enp65s0f0:
	Supported ports: [ FIBRE ]
	Supported link modes:   25000baseCR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: None	 RS	 BASER
	Advertised link modes:  25000baseCR/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: None	 RS	 BASER
	Speed: 25000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes

# ethtool enp65s0f1
Settings for enp65s0f1:
	Supported ports: [ FIBRE ]
	Supported link modes:   25000baseCR/Full
	Supported pause frame use: Symmetric Receive-only
	Supports auto-negotiation: Yes
	Supported FEC modes: None	 RS	 BASER
	Advertised link modes:  25000baseCR/Full
	Advertised pause frame use: No
	Advertised auto-negotiation: Yes
	Advertised FEC modes: None	 RS	 BASER
	Speed: 25000Mb/s
	Duplex: Full
	Auto-negotiation: off
	Port: Direct Attach Copper
	PHYAD: 0
	Transceiver: internal
	Supports Wake-on: d
	Wake-on: d
        Current message level: 0x00000007 (7)
                               drv probe link
	Link detected: yes
```

### `lspci | grep "Ethernet controller"`

# lspci | grep "Ethernet controller"
41:00.0 Ethernet controller: Intel Corporation Ethernet Controller XXV710 for 25GbE SFP28 (rev 02)
41:00.1 Ethernet controller: Intel Corporation Ethernet Controller XXV710 for 25GbE SFP28 (rev 02)

### `sysctl net.core.default_qdisc`

```
# sysctl net.core.default_qdisc
net.core.default_qdisc = fq_codel
```

### `iperf -P8`

```
# iperf -c 147.28.154.69 -P8
------------------------------------------------------------
Client connecting to 147.28.154.69, TCP port 5001
TCP window size: 85.3 KByte (default)
------------------------------------------------------------
[  2] local 147.28.182.113 port 41484 connected with 147.28.154.69 port 5001
[  3] local 147.28.182.113 port 41492 connected with 147.28.154.69 port 5001
[  6] local 147.28.182.113 port 41498 connected with 147.28.154.69 port 5001
[  5] local 147.28.182.113 port 41490 connected with 147.28.154.69 port 5001
[  4] local 147.28.182.113 port 41488 connected with 147.28.154.69 port 5001
[  7] local 147.28.182.113 port 41514 connected with 147.28.154.69 port 5001
[  8] local 147.28.182.113 port 41520 connected with 147.28.154.69 port 5001
[  1] local 147.28.182.113 port 41478 connected with 147.28.154.69 port 5001
[ ID] Interval       Transfer     Bandwidth
[  5] 0.0000-10.0081 sec  12.6 GBytes  10.9 Gbits/sec
[  6] 0.0000-10.0242 sec  2.61 GBytes  2.23 Gbits/sec
[  4] 0.0000-10.0242 sec  4.88 GBytes  4.18 Gbits/sec
[  2] 0.0000-10.0242 sec  9.39 GBytes  8.05 Gbits/sec
[  7] 0.0000-10.0242 sec  2.72 GBytes  2.33 Gbits/sec
[  3] 0.0000-10.0241 sec  4.86 GBytes  4.17 Gbits/sec
[  1] 0.0000-10.0242 sec  6.65 GBytes  5.70 Gbits/sec
[  8] 0.0000-10.0241 sec  5.35 GBytes  4.58 Gbits/sec
[SUM] 0.0000-10.0030 sec  49.1 GBytes  42.2 Gbits/sec
[ CT] final connect times (min/avg/max/stdev) = 0.096/0.106/0.123/0.009 ms (tot/err) = 8/0
```

### `cat /proc/net/bonding/bond0`

```
# cat /proc/net/bonding/bond0
Ethernet Channel Bonding Driver: v5.15.0-70-generic

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer3+4 (1)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 200
Down Delay (ms): 200
Peer Notification Delay (ms): 0

802.3ad info
LACP active: on
LACP rate: fast
Min links: 0
Aggregator selection policy (ad_select): stable
System priority: 65535
System MAC address: 40:a6:b7:20:2f:e0
Active Aggregator Info:
	Aggregator ID: 1
	Number of ports: 2
	Actor Key: 21
	Partner Key: 37
	Partner Mac Address: c2:d6:82:fb:f0:12

Slave Interface: enp65s0f0
MII Status: up
Speed: 25000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 40:a6:b7:20:2f:e0
Slave queue ID: 0
Aggregator ID: 1
Actor Churn State: none
Partner Churn State: none
Actor Churned Count: 0
Partner Churned Count: 0
details actor lacp pdu:
    system priority: 65535
    system mac address: 40:a6:b7:20:2f:e0
    port key: 21
    port priority: 255
    port number: 1
    port state: 63
details partner lacp pdu:
    system priority: 32768
    system mac address: c2:d6:82:fb:f0:12
    oper key: 37
    port priority: 4096
    port number: 10
    port state: 61

Slave Interface: enp65s0f1
MII Status: up
Speed: 25000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: 40:a6:b7:20:2f:e1
Slave queue ID: 0
Aggregator ID: 1
Actor Churn State: none
Partner Churn State: none
Actor Churned Count: 0
Partner Churned Count: 0
details actor lacp pdu:
    system priority: 65535
    system mac address: 40:a6:b7:20:2f:e0
    port key: 21
    port priority: 255
    port number: 2
    port state: 63
details partner lacp pdu:
    system priority: 32768
    system mac address: c2:d6:82:fb:f0:12
    oper key: 37
    port priority: 32768
    port number: 32778
    port state: 61
```
