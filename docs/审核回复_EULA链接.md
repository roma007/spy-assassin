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
> 在**每个本地化**的 App Description 里补上 EULA 链接即可。**只改商店元数据，不用重新打包、不用换构建号。**

---

## 1. 修复步骤（App Store Connect）

1. 登录 <https://appstoreconnect.apple.com> → 我的 App → **Spy Assassin**。
2. 左侧点 **版本（Version，如 1.0）**——**描述不在「App 信息」页**，在版本页。
3. 版本页顶部有**语言下拉**，依次选 **English (U.S.) / 简体中文 / Español (LatAm) / 한국어**，
   找到 **「描述（Description）」** 文本框（同一区域还有 关键词 / 促销文本 / 更新内容 / 支持网址），
   把描述整体替换为 `docs/商店素材.md` §4.2 / §4.1 / §4.4 / §4.3 对应的整段（**含末尾两行链接**）→ **保存**（每切一个语言都要单独保存）。
4. 回到 **App 信息** 页面，确认「许可协议（License Agreement）」保持**标准 EULA**（不要改成自定义，
   除非同时把 App 内链接也改成同一份自定义 EULA 并出新包）。
5. 可选加固：确认 **隐私政策网址** 可访问（`https://roma007.github.io/spy-assassin/privacy.html`）。
6. 打开 **解决中心（Resolution Center）**，粘贴下面的回信 → **重新提交（Submit）**。

> ⚠️ **顺序铁律：先「回复 + 附截图」，再点重新提交。**
> 被拒后回复框只在你点「重新提交」之前可用；一旦重新提交，这条消息线立即关闭、变成只读，
> 之后再补交截图/录屏就来不及了，只能等下一轮拒信的新消息线（白跑 1~3 天）。详见《审核回复_2.1.md》开头。
> 建议随信附一张截图：**App Store Connect 描述框里 EULA 链接那一行**（或商店页预览）。

> ⚠️ 重新提交前再确认一遍 **版本页 →「App 内购买项目」** 里三个订阅仍挂在本次版本上
> （Pro Weekly / Pro Monthly / Pro Yearly，状态「已批准」）。整版被拒后偶尔需要重新勾选。

> 描述里的纯 URL 在 App Store 商品页会自动变成可点击链接，因此必须写成**完整网址**，
> 不能写成「点击这里查看条款」这种没有 URL 的字样。

---

## 2. 解决中心回信（中文，可直接粘贴）

```
尊敬的 App Review 团队：

感谢您的审核。关于「商店页元数据缺少使用条款（EULA）链接」的问题，我们已按提示完成修改：

1. 本 App 使用苹果标准使用条款（EULA）：https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
2. 我们已在 App Store Connect「App 信息 → 本地化」中，为每一个本地化（English (U.S.)、简体中文、
   Español (LatAm)、한국어）的 App 描述末尾都添加了可点击的 EULA 链接，并同时附上隐私政策链接。
3. App 内的合规链接也已就位：付费墙（Pro 订阅页）底部提供「使用条款（EULA）」与「隐私政策」两个可点击链接，
   并附有订阅周期、价格、自动续费与取消说明、以及「恢复购买」按钮。
4. 本次仅修改了商店元数据，无需更换构建版本（Build）。

感谢审阅，期待通过。

开发者 / Developer
Spy Assassin（com.spyassassin.app）
```

---

## 3. 解决中心回信（English，可直接粘贴）

```
Dear App Review Team,

Thank you for your review. Regarding the note that the app metadata on the product page did not include
a functional link to the Terms of Use (EULA), we have made the following changes:

1. This app is licensed under the standard Apple Terms of Use (EULA):
   https://www.apple.com/legal/internet-services/itunes/dev/stdeula/
2. We added a clickable Terms of Use (EULA) link at the end of the App Description for EVERY
   localization (English (U.S.), Simplified Chinese, Español (LatAm), 한국어), together with a link
   to our Privacy Policy. URLs in the description are rendered as tappable links on the product page.
3. In-app compliance is already in place: the Pro paywall shows the subscription length, price,
   auto-renewal and cancellation information, a "Restore Purchases" button, plus clickable
   "Terms of Use (EULA)" and "Privacy Policy" links.
4. This update only changes the store metadata; the same build is resubmitted.

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
- [ ] 后台「许可协议」= 标准 EULA（与 App 内链接一致）
- [ ] 版本页「App 内购买项目」里三个订阅仍挂在本次版本上
- [ ] **已在点「重新提交」之前**于解决中心回复并附截图（回复后消息线关闭）
- [ ] 解决中心已回复并重新提交
- [ ] 复核 App 内付费墙：价格 / 周期 / 自动续费说明 / 恢复购买 / EULA / 隐私政策 六项齐全（勿删）

---

## 5. 备用方案（若再次因 EULA 被拒）

改用**自定义 EULA**：在 App Store Connect **App 信息 → 许可协议 → 编辑 → 自定义 EULA URL** 填入自建页面
（如 `https://roma007.github.io/spy-assassin/terms.html`），商店页会自动出现「许可协议」链接。
此时必须：①自定义 EULA 文本含 Apple 最低要求条款（承认授权而非售卖、禁止反向工程、遵守适用法律、
第三方组件条款、争议解决等）；②把 App 内 `lib/core/pro/upgrade_dialog.dart` 的 `kTermsOfUseUrl`
指向同一地址并出新包提交；③描述里仍建议保留 EULA 链接。
