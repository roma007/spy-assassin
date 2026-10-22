# 审核回复模板：商店页缺少 EULA 链接（Guideline 3.1.2 自动拒审）

> 拒审原文（2026-10-22 收到，自动化消息）：
> "The submission offers auto-renewable subscriptions, such as Pro Monthly, Pro Yearly, Pro Weekly,
> but does not include a functional link to the Terms of Use (EULA) in the app metadata that appears on
> the app's App Store product page. If you are using the standard Apple Terms of Use (EULA), include a link
> to the Terms of Use in the App Description for every localization. If you are using a custom EULA, add it
> in App Store Connect."
>
> 结论：本 App 使用**苹果标准 EULA**（App 内付费墙「使用条款（EULA）」按钮链向
> `https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`），因此按苹果指示，
> 在**每个本地化**的 App Description 里补上 EULA 链接即可。**只改商店元数据，不用重新打包、不用换构建号**
> （构建版本继续用 `1.0.0 (8)`）。
>
> 本次提交：提交 ID `cd9d61ee-9b17-4872-bbff-e7543266eb53`，提交日期 2026-10-20 20:21。

---

## 1. 修复步骤（App Store Connect）

### 步骤 A：先改元数据（版本页，**必须已保存**才能重新提交）

1. 打开版本页：<https://appstoreconnect.apple.com/apps/6821077575/distribution/ios/version/inflight>
   （iOS App 版本 1.0.0 → 产品页面信息）。
2. 页面顶部「**英语（美国）**」语言下拉 → 展开，查看有哪些本地化。
3. 对**每一个已存在的本地化**重复：
   - 描述**已有内容** → 光标点到描述框**最末尾** → 回车换行 → 粘贴两行链接 → **保存**
     （取剪贴板：`docs/asc/copy.sh <语言> links`）
   - 描述**是空的**（新建本地化时描述与关键词不会自动继承主语言）→ 整段粘贴 `docs/asc/copy.sh <语言>`
   - 末尾两行（英文；中文/西语/韩语前缀见 `docs/asc/links_*.txt`）：
     ```
     Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
     Privacy Policy: https://roma007.github.io/spy-assassin/privacy.html
     ```
4. 计数校验：现英文描述 2,976 字符 + 155 ≈ **3,131 < 4,000**，不会超限。
5. 描述里的纯 URL 在商品页会**自动变成可点击链接**，不能写成「点击这里」之类没有 URL 的字样。

### 步骤 B：解决中心回信（**必须早于重新提交**）

1. App 页顶部「**查看 App 审核问题与消息**」→「进行中 / In Progress」→ 进入该提交（iOS 提交页）。
2. 苹果那条自动消息下方点「**回复 App 审核 / Reply to App Review**」。
3. 粘贴下面的回信 → 下方 **Attach File** 附一张截图（描述框末尾那两行 + 字符计数）→ **发送**。
4. **确认消息区出现你刚发的回复**，再进行步骤 C。
   > ⚠️ 铁律：重新提交后这条消息线立即关闭、变成只读，之后再也补不了附件/录屏，只能等下一轮拒信的新消息线
   > （白跑 1~3 天）。详见《审核回复_2.1.md》开头。

### 步骤 C：重新提交

1. 解决中心顶部点「**重新提交至 App 审核 / Resubmit to App Review**」→ 弹窗确认（可能要求密码/2FA）→ 提交。
2. 三个订阅（Pro Weekly / Monthly / Yearly）与订阅群组 `pro` 状态是「可供审核」，会随版本一起再次送审，**无需重新添加**。

---

## 2. 解决中心回信（中文，可直接粘贴）

```
尊敬的 App Review 团队：

感谢您的审核。关于「商店页元数据缺少使用条款（EULA）链接」的问题，我们已按提示完成修改：

1. 本 App 使用苹果标准使用条款（EULA）：https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
2. 我们已在 App Store Connect「版本 1.0.0 → 描述」中，为 App 的每一个本地化在描述末尾添加了可点击的
   EULA 链接，并同时附上隐私政策链接（描述中的纯 URL 在商品页会自动显示为可点击链接）。
3. App 内的合规链接也已就位：付费墙（Pro 订阅页）底部提供「使用条款（EULA）」与「隐私政策」两个可点击链接，
   并附有订阅周期、价格、自动续费与取消说明、以及「恢复购买」按钮。
4. 本次仅修改了商店元数据，无需更换构建版本（1.0.0 (8)），随附截图可见描述末尾的 EULA 链接。

感谢审阅，期待通过。

开发者 / Developer
Spy Assassin（com.spyassassin.app）
```

> 如果只改了英语（美国）一个本地化，把第 2 条换成：
> 「我们已在 App Store Connect『版本 1.0.0 → 描述』中，于英语（美国）（本 App 的主要语言）的描述末尾添加了可点击的
> EULA 链接与隐私政策链接；其余本地化未单独提供描述，将按 Apple 规则显示主要语言的元数据。」

---

## 3. 解决中心回信（English，可直接粘贴）

```
Dear App Review Team,

Thank you for your review. Regarding the note that the app metadata on the product page did not include
a functional link to the Terms of Use (EULA), we have made the following changes:

1. This app is licensed under the standard Apple Terms of Use (EULA):
   https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
2. We added a clickable Terms of Use (EULA) link at the end of the App Description for every localization
   of version 1.0.0, together with a link to our Privacy Policy. URLs in the description are rendered as
   tappable links on the product page. A screenshot of the description is attached.
3. In-app compliance is already in place: the Pro paywall shows the subscription length, price,
   auto-renewal and cancellation information, a "Restore Purchases" button, plus clickable
   "Terms of Use (EULA)" and "Privacy Policy" links.
4. This update only changes the store metadata; the same build (1.0.0 (8)) is resubmitted.

We appreciate your time and look forward to the approval.

Developer
Spy Assassin (com.spyassassin.app)
```

---

## 4. 提交前自检清单

- [ ] English (U.S.) 描述末尾有 `Terms of Use (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
- [ ] 简体中文 描述末尾有 `使用条款（EULA）：https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
- [ ] Español 描述末尾有 `Términos de uso (EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
- [ ] 한국어 描述末尾有 `이용 약관(EULA): https://www.apple.com/legal/internet-services/itunes/dev/stdeula/`
- [ ] 每个语言的描述末尾同时有隐私政策链接
- [ ] 描述计数 < 4000，且已点「保存」
- [ ] 后台「许可协议」= 标准 EULA（与 App 内链接一致）
- [ ] **已在点「重新提交」之前**于解决中心回复并附截图（重新提交后消息线关闭）
- [ ] 已点「重新提交至 App 审核」并确认提交
- [ ] 复核 App 内付费墙：价格 / 周期 / 自动续费说明 / 恢复购买 / EULA / 隐私政策 六项齐全（勿删）

---

## 5. 备用方案（若再次因 EULA 被拒）

改用**自定义 EULA**：在 App Store Connect **App 信息 → 许可协议 → 编辑 → 自定义 EULA URL** 填入自建页面
（如 `https://roma007.github.io/spy-assassin/terms.html`），商店页会自动出现「许可协议」链接。
此时必须：①自定义 EULA 文本含 Apple 最低要求条款（承认授权而非售卖、禁止反向工程、遵守适用法律、
第三方组件条款、争议解决等）；②把 App 内 `lib/core/pro/upgrade_dialog.dart` 的 `kTermsOfUseUrl`
指向同一地址并出新包提交；③描述里仍建议保留 EULA 链接。

## 6. 完全自动化的备选（可选）

不想手动点 4 次的话，可用 App Store Connect API 脚本直接写入四个语言的描述：
需要 ASC「用户和访问 → 密钥」创建一个 App Manager 密钥（`.p8`）+ Issuer ID + Key ID，
脚本位置见 `docs/asc/`（由本机生成，不入库密钥）。
