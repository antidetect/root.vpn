<div align="center">

# 🛡️ root.vpn

### VPN một dòng lệnh, làm ra để “hòa vào nền” ở nơi WireGuard trần bị chặn.

**AmneziaWG 2.0 (UDP/443) + VLESS·REALITY (TCP/443) chỉ bằng một lệnh — với ngụy trang giao thức được thiết kế để trông như lưu lượng QUIC/TLS bình thường trên cổng 443.**

![License](https://img.shields.io/badge/License-MIT-22c55e?style=for-the-badge)
![AmneziaWG](https://img.shields.io/badge/AmneziaWG-2.0-3b82f6?style=for-the-badge)
![REALITY](https://img.shields.io/badge/VLESS-REALITY-a855f7?style=for-the-badge)<br>
![Tested](https://img.shields.io/badge/kiểm%20thử%20E2E-Ubuntu%2024.04%20thật%20✓-16a34a?style=for-the-badge)
![Leaks](https://img.shields.io/badge/rò%20rỉ%20IP%2FDNS%2FIPv6-không%20(lab%20E2E)-16a34a?style=for-the-badge)
![One command](https://img.shields.io/badge/cài%20đặt-một%20lệnh-f59e0b?style=for-the-badge)
![Platform](https://img.shields.io/badge/Ubuntu·Debian-e95420?style=for-the-badge&logo=linux&logoColor=white)

**🌐 [English](README.md) · [Русский](README.ru.md) · [中文](README.zh.md) · Tiếng Việt**

</div>

> [!IMPORTANT]
> **Nói thẳng:** root.vpn được **thiết kế** để giống lưu lượng QUIC/TLS bình thường, và đã được **kiểm thử đầu‑cuối trên máy chủ thật** (xem bên dưới). Nó **chưa** được kiểm thử trước các hệ thống kiểm duyệt thực tế — việc ngụy trang là *thuộc tính thiết kế*, không phải kết quả đã chứng minh trên thực địa. Xem [Russia / TSPU edition](#-russia--tspu-edition) và [Giới hạn thành thật](#️-giới-hạn-thành-thật). Không “dầu rắn”.

## Cài đặt (không cần git)

```bash
curl -fsSL https://raw.githubusercontent.com/antidetect/root.vpn/main/install.sh | sudo bash
```

Dòng đó dùng `curl`+`tar` (không cần git) tải root.vpn, dựng một máy chủ road‑warrior đã gia cố trên **cổng 443**, và in mã QR để bạn quét kết nối. Không cờ, không bảng web, không dashboard để lộ. Trên image mới, trình cài đặt nền reboot một hai lần để nạp nhân mới — **chỉ cần chạy lại cùng lệnh sau mỗi lần reboot**, nó tiếp tục an toàn.

Mặc định bạn có **hai lối vào trên :443**: **AmneziaWG/UDP** tốc độ cao *và* dự phòng **VLESS·REALITY/TCP** cho mạng chặn UDP (`TCP_ENABLED=1` là mặc định; đặt `0` để chỉ AWG).

> [!WARNING]
> AmneziaWG chỉ UDP. Nơi mạng chặn *toàn bộ* UDP, client dùng **hồ sơ thứ hai (VLESS + REALITY trên TCP/443)** để vượt qua. Hai cánh cửa, một câu lệnh.

---

## ✨ Vì sao chọn root.vpn

- 🥷 **Sinh ra để hòa lẫn, không chỉ mã hóa.** WireGuard/OpenVPN trần dễ bị lấy vân tay và bị chặn trên nhiều mạng hạn chế. root.vpn ngụy trang *gói mở màn* thành một **QUIC client Initial tới một website hợp lệ**, còn chân TCP dùng **REALITY** chuyển tiếp bắt tay TLS của một site bên thứ ba thật — kẻ dò chủ động chỉ nhận lại đúng site thật đó.
- 🎲 **Không hai lần cài nào giống nhau.** Gói rác, đệm theo thông điệp, header dạng khoảng và phần mở màn giả‑QUIC đều **ngẫu nhiên theo từng lần triển khai** (connection ID, TLS random, key share, GREASE, thứ tự extension đều khác). Điều này loại bỏ dấu hiệu byte tĩnh chung giữa các máy chủ — nhưng **không** tuyên bố đánh bại bộ phân loại ML/mẫu‑kết‑nối.
- 🚪 **UDP *và* TCP trên :443.** Chung máy, không xung đột — đã xác nhận cả hai đang lắng nghe trên máy thật.
- ⚡ **Một lệnh, máy chủ lo phần còn lại.** Cài module nhân, sinh khóa, dựng cấu hình, mở tường lửa, thiết lập NAT, tạo client đầu tiên và in QR. (Cần root + HTTPS ra ngoài; có thể reboot/tiếp tục trên nhân mới.)
- 🔒 **Gia cố mặc định.** Toàn tuyến (không rò rỉ trong thử nghiệm có kiểm soát), UFW + fail2ban (từ upstream), và trên chân TCP là **Xray trong sandbox systemd** với bí mật `0600` thuộc user dịch vụ và **tắt log truy cập**.
- 🧾 **Của bạn, MIT, kiểm toán được.** Một lớp phủ mỏng, dễ đọc trên [`bivlked/amneziawg-installer`](https://github.com/bivlked/amneziawg-installer) + [Xray‑core](https://github.com/XTLS/Xray-core).

## ✅ Đã kiểm thử đầu‑cuối trên máy chủ thật

Không chỉ `bash -n`. Mọi đường đi đều chạy trên một VPS **Ubuntu 24.04** mới (Debian 12 được trình cài đặt hỗ trợ nhưng không nằm trong đợt chạy này):

| Kiểm thử | Kết quả |
|---|---|
| AmneziaWG 2.0 (UDP/443): client thật bắt tay + lưu lượng qua đường hầm | **IP ra = máy chủ ✓** |
| VLESS + REALITY + Vision (TCP/443): client thật qua SOCKS *(với site ngụy trang REALITY phù hợp)* | **IP ra = máy chủ ✓** |
| Rò rỉ IPv4 / **IPv6** / **DNS** — *trong E2E network‑namespace một máy (lab), không phải mạng client thật* | **không rò rỉ ✓** |
| Tường lửa: UFW `deny routed`, FORWARD `DROP`+`awg0 ACCEPT`, NAT MASQUERADE | **✓** |
| fail2ban (dò mật khẩu SSH) | **đang chạy, đang chặn ✓** |
| Vòng đời client: add / remove / list / `rotate-reality`; đường cài qua curl | **✓** |
| Chạy lại idempotent qua các lần reboot của trình cài đặt | **✓** |

> Đợt chạy này phát hiện và sửa ~10 lỗi triển khai đời thực (xử lý nhiều reboot, thiếu phụ thuộc, chọn site ngụy trang REALITY, quyền sở hữu file cho user dịch vụ, v.v.) — chỉ chạy thật mới lộ.

## 🧬 Cách nó hòa vào nền

*Gói mở màn* của client là **mồi nhử**: một **QUIC v1 Initial** thật, duy nhất theo từng lần triển khai, mang TLS ClientHello với *SNI của bạn* (dựng ngoại tuyến theo RFC 9000/9001; khóa Initial khớp vector kiểm thử RFC 9001 Phụ lục A.1, và trong quá trình phát triển gói được ngăn xếp độc lập `aioquic` phân tích — lấy lại được SNI). Với bộ kiểm duyệt, phiên *bắt đầu* như HTTP/3 thường trên 443; sau đó là bắt tay AmneziaWG thật, máy chủ bỏ qua mồi nhử. **Lưu ý:** chỉ gói đầu giả QUIC — một bộ phân loại có trạng thái theo dõi cả luồng vẫn có thể nhận ra nó không phải phiên HTTP/3 đầy đủ. Chân TCP dùng **REALITY**, dò sẽ nhận về một site bên thứ ba thật.

```mermaid
flowchart LR
    C["📱 Thiết bị của bạn"] -->|"mở màn giống QUIC / TLS tới site thật trên :443"| DPI["🛂 DPI · TSPU · GFW"]
    DPI -->|"có ý để được coi là web bình thường"| S["🖥️ máy chủ root.vpn"]
    C -. "đường hầm AmneziaWG 2.0 / VLESS·REALITY thật" .-> S
    S --> NET["🌍 internet mở"]
```

## ⚔️ So sánh tính năng thiết kế

*So sánh tính năng thiết kế sẵn có, không phải kết quả thực địa. Việc vượt kiểm duyệt thực tế chưa được kiểm chứng độc lập cho bất kỳ lựa chọn nào.*

| Tính năng | WireGuard trần | OpenVPN (TLS/443) | AmneziaWG gốc | **root.vpn** |
|---|:---:|:---:|:---:|:---:|
| Giả dạng / ngụy trang giao thức | ❌ | ⚠️ qua plugin | ✅ | ✅ |
| Chân TLS kháng dò chủ động | ❌ | ⚠️ tls‑crypt | ❌ | ✅ REALITY (chân TCP) |
| UDP **và** TCP trên :443 | ❌ | chỉ TCP | chỉ UDP | ✅ cả hai |
| Dấu hiệu ngẫu nhiên theo từng lần triển khai | ❌ | ❌ | ⚠️ thủ công | ✅ |
| Một lệnh + client + QR | ⚠️ | ⚠️ | ⚠️ | ✅ |
| Toàn tuyến, đã kiểm rò rỉ (lab E2E) | — | — | — | ✅ |

## 🚀 Cài đặt đầy đủ

**Bạn cần:** một VPS **Ubuntu 24.04** (hoặc Debian 12) mới — lý tưởng 1 GB RAM, script tự thêm swap nếu thiếu — có **IP danh tiếng sạch** (tránh dải VPS đã bị chặn), và quyền root.

**Nhanh nhất (không cần git):**
```bash
# có thể truyền cấu hình qua biến môi trường (site ngụy trang REALITY kín đáo + QUIC SNI):
curl -fsSL https://raw.githubusercontent.com/antidetect/root.vpn/main/install.sh \
  | sudo REALITY_DEST=dl.google.com AWG_SNI=www.cloudflare.com bash
```

**Hoặc tải về + sửa rồi chạy (cũng không cần git):**
```bash
curl -fsSL https://github.com/antidetect/root.vpn/archive/refs/heads/main.tar.gz | tar -xz
cd root.vpn-main
nano defaults.conf          # đặt REALITY_DEST / AWG_SNI, v.v.
sudo ./awg2
```

**Hoặc dùng git:**
```bash
git clone https://github.com/antidetect/root.vpn && cd root.vpn && sudo ./awg2
```

Khi xong bạn sẽ thấy `all checks passed`, mã QR của client đầu tiên và một link `vless://`. Hướng dẫn từng thiết bị: **[docs/USAGE.md](docs/USAGE.md)**.

## 🎛️ Quản lý

```bash
sudo awg2 add laptop                  # client mới trên cả hai chân → QR + link vless://
sudo awg2 add guest --expires=7d      # client tự hết hạn
sudo awg2 remove laptop               # thu hồi mọi nơi
sudo awg2 list                        # mọi client, cả hai chân
sudo awg2 status                      # interface, cổng, tóm tắt ngụy trang
sudo awg2 rotate-sni <tên miền>       # SNI QUIC mới + tạo lại client
sudo awg2 rotate-reality              # khóa REALITY mới + xuất lại link
sudo awg2 rotate-reality-target <host># đổi site ngụy trang REALITY
sudo awg2 uninstall
```

## 📲 Kết nối thiết bị

Mỗi client nhận một **hồ sơ AmneziaWG** và (khi bật chân TCP) một **hồ sơ VLESS·REALITY** — thử AmneziaWG trước; dùng VLESS khi UDP bị chặn.

| Nền tảng | AmneziaWG (UDP) | VLESS·REALITY (TCP) |
|---|---|---|
| Windows | AmneziaVPN | v2rayN / Hiddify |
| macOS | AmneziaVPN | Hiddify / v2rayN |
| Android | AmneziaWG / AmneziaVPN | Hiddify / v2rayNG |
| iOS | AmneziaVPN | Streisand (miễn phí) / Shadowrocket (trả phí) / Hiddify |
| Linux | `awg-quick` / AmneziaVPN | Hiddify / mihomo / `xray` |

👉 **Nhập từng bước + xử lý sự cố + kiểm tra rò rỉ:** [docs/USAGE.md](docs/USAGE.md)

## 🎚️ Tùy chọn tàng hình

| Tùy chọn | Cách | Trạng thái |
|---|---|---|
| **Mặc định** | AWG/UDP + VLESS‑REALITY‑**Vision** TCP/443 | ✅ nền tảng đã kiểm thử |
| **Tăng cường cho Nga** | Chân TCP qua **XHTTP** (`TCP_TRANSPORT="xhttp"`) | giảm thiểu trước việc TSPU bị báo chặn Vision‑trên‑443; **chưa kiểm chứng trên TSPU thật** |
| **CDN front / hậu lượng tử** | XHTTP+TLS qua CDN · mã hóa VLESS (ML‑KEM) | **thử nghiệm / thủ công**, mặc định tắt, không thuộc nền tảng đã kiểm thử |

Lý do kỹ thuật + ánh xạ mối đe dọa: **[docs/DESIGN‑v2‑tcp‑masking.md](docs/DESIGN-v2-tcp-masking.md)**.

## 🇷🇺 Russia / TSPU edition

> [!IMPORTANT]
> Đây là hồ sơ cấu hình cho điều kiện TSPU của Nga, tổng hợp từ báo cáo thực địa của cộng đồng 2026 (net4people/bbs, Habr) — **dự án này chưa kiểm chứng trước TSPU thật**. Mọi mục bên dưới chỉ tăng chi phí phát hiện / đổi mẫu lưu lượng; không phải cách vượt đã được chứng minh. Yếu tố quyết định thường là **IP/ASN lối ra**, điều mà không tham số nào ở đây thay đổi được.

**Nếu một tuyến bị chặn, làm lần lượt** (mỗi mục là một biến trong `defaults.conf` hoặc biến môi trường, rồi chạy lại `sudo awg2`):

1. **Bỏ Vision → XHTTP.** "Đóng băng" TSPU 11‑2025 được báo nhắm vào luồng `xtls‑rprx‑vision` đơn trên :443 (server→client dừng sau ~16 KB). `TCP_TRANSPORT="xhttp"` → chạy lại. (Thay thế trong repo cho mux mà root.vpn không kèm.)
2. **Rời :443.** Việc đóng băng được báo gắn với cổng 443; cổng cao đỡ hơn. `TCP_PORT="8443"` (tường lửa theo sau). Đánh đổi: mất vỏ "giống HTTPS", tệ hơn trên nhà mạng chế độ whitelist.
3. **Site ngụy trang REALITY sạch + xoay.** TSPU đếm bắt tay theo SNI, SNI dùng chung cháy nhanh hơn. `awg2 rotate-reality-target <host TLS1.3+h2 sạch>` rồi `awg2 rotate-reality`.
4. **Di động → preset mobile (chân UDP).** `AWG_PRESET="mobile"` (Jc=3, thu hẹp Jmax); giữ `AWG_MIMICRY="quic"` + `AWG_SNI` kín đáo; `awg2 rotate-sni <tên miền>` khi nhà mạng thích nghi.
5. **Vân tay uTLS Firefox.** Báo cáo thực địa khoan dung với Firefox/Edge hơn Chrome: `XRAY_FP="firefox"`. (Không chữa được đóng băng theo dung lượng.)
6. **Làm sạch ASN — phần không tham số nào sửa được** (xem dưới). "Tẩy" duy nhất trong repo là CDN‑front (`CDN_DOMAIN` + tên miền/chứng chỉ của bạn; thử nghiệm/thủ công).
7. **Giữ Xray mới ở cả hai đầu** (`XRAY_VERSION` đã ghim là ổn; client cùng phiên bản).

| Triệu chứng | Hành động |
|---|---|
| UDP / QUIC bị bóp | giữ AWG + SNI kín đáo; nếu UDP không dùng được thì dùng chân TCP; chỉ hạ `AWG_PORT` xuống cổng UDP thấp nếu UDP cao bị chặn mà :443 thì không |
| Vision đóng băng trên :443 (~16 KB, hồi ~60s) | `TCP_TRANSPORT="xhttp"` **và** `TCP_PORT="8443"`; chỉ đổi `XRAY_FP` sẽ không giúp |
| Bắt tay xong rồi đứt | cắt ASN/IP — `rotate-reality-target` / `rotate-reality`; nếu vẫn vậy thì lối ra đã cháy → máy sạch hơn hoặc `CDN_DOMAIN` |
| Đặc thù di động / chế độ whitelist | `AWG_PRESET="mobile"`, xoay SNI; trên nhà mạng whitelist việc chọn giao thức vô ích — chỉ chuỗi trong‑Nga được whitelist hoặc CDN edge mới có cơ hội, rời :443 sẽ **có hại** |

**Không sẵn dùng (thủ công / lộ trình):** mux/XMUX theo kết nối (không có tham số — XHTTP thay thế); `XHTTP_MODE=packet-up` (sửa tay `/etc/rootvpn/xray/params`); Shadowsocks‑2022 / AnyTLS (không trong repo); **chuỗi nội địa** (client → VPS trong‑Nga được whitelist → lối ra nước ngoài — phương án sống sót mạnh nhất ở Nga, nhưng ngoài phạm vi: dựng instance thứ hai và nối tay); chỉnh AWG `I1` theo nhà mạng (sửa tay `awg0.conf`).

**Thực tế IP / ASN (cấu hình không chữa được):** TSPU lọc theo CIDR/ASN đích — REALITY hoàn hảo trên dải đã cháy (Hetzner AS24940, OVH, DO) vẫn đứt sau bắt tay. Khả năng sống sót đại khái, tốt→tệ: **dân cư / di động (4G/LTE) > dải trong‑nước được whitelist (qua chuỗi) > hyperscaler lớn (AWS/Azure/GCP) > DC giá rẻ (dự kiến bắt‑tay‑rồi‑đứng)**. Chọn IP lối ra cho phù hợp và coi đó là mục tiêu luôn dịch chuyển.

## 🛡️ Gia cố

Toàn tuyến · UFW (`deny routed`) + fail2ban (upstream) · `net.ipv6.disable_ipv6=1` (không rò rỉ v6) · NAT MASQUERADE + `FORWARD DROP`. Trên chân TCP/Xray: khóa riêng REALITY + cấu hình Xray `0600` chown cho user dịch vụ · **tắt log truy cập Xray** (log của nó không có IP/SNI client) · sandbox systemd (`NoNewPrivileges`, `ProtectSystem=strict`, chỉ `CAP_NET_BIND_SERVICE`). Upstream ghim theo phiên bản (tùy chọn `UPSTREAM_SHA256` để ghim theo hash, mặc định tắt). Tham số ngụy trang ngẫu nhiên theo từng lần triển khai.

## ⚠️ Giới hạn thành thật

- **Chưa kiểm thử trước kiểm duyệt thực tế.** Vượt TSPU Nga / GFW Trung / DPI Iran **chưa** được kiểm chứng — chống DPI ở đây là ý đồ thiết kế + kiểm thử lab/chức năng, không phải kết quả thực địa.
- **Kiểm tra rò rỉ chỉ ở lab.** Đạt trong E2E network‑namespace một máy, *không* trên thiết bị và mạng truy cập thật. Hãy tự kiểm trên thiết bị (xem USAGE).
- **Chỉ gói đầu giả QUIC.** Bộ phân loại có trạng thái theo dõi cả luồng vẫn có thể phân biệt; TLS‑in‑TLS của REALITY chỉ tăng chi phí phát hiện, không vô hình.
- **Danh tiếng IP/ASN thắng mọi giao thức.** Trên dải VPS đã bị chặn, bắt tay xong là dữ liệu “chết” — hãy dùng nút thoát sạch/dân cư.
- **Chọn site ngụy trang REALITY rất quan trọng.** Dùng site TLS1.3+HTTP/2 sạch (`dl.google.com`, `www.lovelive-anime.jp`); **tránh** site có chuỗi chứng chỉ khổng lồ (`microsoft.com`, `amazon.com`) — sẽ làm hỏng bắt tay REALITY (đã chứng minh khi test). root.vpn có thẩm định và cảnh báo, nhưng **hãy test site ngụy trang trước khi phát cho client**.
- **Chưa có benchmark thông lượng.** **Debian 12** và các tùy chọn nâng cao (XHTTP/CDN/PQ) không nằm trong nền tảng Ubuntu 24.04 đã kiểm chứng.
- **Khóa client & tin cậy.** AWG 2.0 cần app Amnezia; chân TCP cần app dòng Xray. Nó chạy mã upstream đã ghim với quyền root — hãy đọc; ghim `UPSTREAM_SHA256` nếu muốn.

## 📚 Tài liệu

- 📖 [Hướng dẫn sử dụng client](docs/USAGE.md) — kết nối mọi thiết bị
- 🏗️ [Thiết kế v2](docs/DESIGN-v2-tcp-masking.md) — kiến trúc, ánh xạ mối đe dọa, tùy chọn

## 🙏 Ghi công & Giấy phép

Xây trên [`bivlked/amneziawg-installer`](https://github.com/bivlked/amneziawg-installer) và [amnezia‑vpn](https://github.com/amnezia-vpn) (AmneziaWG 2.0) + [XTLS/Xray‑core](https://github.com/XTLS/Xray-core) (VLESS·REALITY). Trình tạo QUIC‑Initial ngoại tuyến tuân theo RFC 9000/9001 và là công trình gốc. Xem [NOTICE](NOTICE).

**MIT** © 2026 — xem [LICENSE](LICENSE). Dành cho mục đích riêng tư & vượt kiểm duyệt hợp pháp; bạn tự chịu trách nhiệm tuân thủ luật áp dụng cho mình.
