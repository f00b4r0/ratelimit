# ratelimit

An experimental ubus interface to the HTB traffic shaper for OpenWrt

## Description

ratelimit provides a stateful interface to the HTB traffic shaper, enabling network device-based per-client bandwidth limits assignment.

It offers a turnkey solution to set individual MAC-address-based bandwidth limits via ubus calls.

## License

MIT - https://opensource.org/license/MIT

- Copyright (C) 2021-2023 John Crispin
- Copyright (C) 2023-2025 Thibaut VARÈNE

Permission is hereby granted, free of charge, to any person obtaining a copy of this software
and associated documentation files (the “Software”), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial
portions of the Software.

THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
THE USE OR OTHER DEALINGS IN THE SOFTWARE.

## Configuration

The available configuration options are listed in the provided [ratelimit](files/etc/config/ratelimit) configuration file.

## ubus interface

```
"defaults_set":{"name":"String","rate":"String","rate_ingress":"String","rate_egress":"String"}
"client_set":{"device":"String","defaults":"String","address":"String","rate":"String","rate_ingress":"String","rate_egress":"String"}
"client_delete":{"device":"String","address":"String"}
"device_delete":{"device":"String"}
"reload":{}
```

- `defaults_set` sets or updates defaults. `name` is the (required) defaults name,
  at least one of `rate` (applies to both ingress and egress), `rate_ingress` or `rate_egress` must be specified,
  the latter two overriding `rate` value.
- `client_set` sets or updates client limits. `device` is the (required) target network device,
  `address` is the (required) MAC address of the client to which the limits must be applied, and either `defaults`
  (to apply the specified defaults) or at least one of `rate`, `rate_ingress` or `rate_egress` must be specified. 
- `client_delete` clears client limits. `device` is the (required) target network device, `address` is the (required) MAC address of the client
- `device_delete` clears device limits (for all associated clients). `device` is the (required) target network device.
- `reload` reloads tc ruleset (handled by the hotplug script)

#### rate string format

rate values are provided either as a number string representing the limit in bits per second (bps),
or as a tc-htb compatible suffixed number, e.g. "1mbit".

### Examples

```
# set a 1mbit limit on both upload and download for client "00:11:22:33:44:55" on network device "lan":
ubus call ratelimit client_set '{"device":"lan","address":"00:11:22:33:44:55","rate":"1mbit"}'
# apply defaults "mydefaults" to client "AA:BB:CC:DD:EE:FF" on network device "eth0":
ubus call ratelimit client_set '{"device":"eth0","address":"AA:BB:CC:DD:EE:FF","defaults":"mydefaults"}'
# set 100kbps upload, unlimited download limits for client "66:77:88:99:AA:BB" on network device "wlan0":
ubus call ratelimit client_set '{"device":"wlan0","address":"66:77:88:99:AA:BB","rate_ingress":"100000"}'
# clear all limits for client "00:11:22:33:44:55" on network device "lan":
ubus call ratelimit client_delete '{"device":"lan","address":"00:11:22:33:44:55"}'
# clear all limits on network device "eth0"
ubus call ratelimit device_delete '{"device":"eth0"}' 
```
