# 引き継ぎ: moranajp の CRAN アーカイブへの対応

(2026-08-04 作成．textmining2 プロジェクトのセッションからの引き継ぎ)

> **【対応済み: 2026-08-04】**
> 修正の方針 1.〜4. のうち，パッケージ側の修正(1.〜3.)は完了．
> `R CMD check --as-cran` は 0 errors / 0 warnings / 1 NOTE
> (NOTE は「archived on CRAN」のみ)．
> **CRAN への再投稿(4. の投稿そのもの)は未実施．**
> 作業内容と，調査中に見つかった別課題(茶まめの出力列のずれ)は
> `.claude/CLAUDE.md` の「進捗状況」と「TODO」を参照．

## 背景

moranajp は 2025年10月末に CRAN からアーカイブされた．
<https://cran.r-project.org/web/packages/moranajp/index.html>

## 原因(CRAN からのメールで判明)

`web_chamame()` の Examples が Web茶まめ(<https://chamame.ninjal.ac.jp/>)に接続できず，
R CMD check がエラーになった．

```
> web_chamame(text)
Error in open.connection(x, "rb") : cannot open the connection
Calls: web_chamame -> <Anonymous> -> read_html.default
```

CRAN ポリシーの次の条項に抵触している．

> Packages which use Internet resources should fail gracefully with an informative message
> if the resource is not available or has changed (and not give a check warning nor error).

CRAN 側(Brian Ripley 氏)は
**「資源が復旧するかどうかに関わらず修正が必要」**と明記している．
つまり茶まめが今つながっても，パッケージ側の作りを直さないと再登録できない．

経緯:

- 2025-10-11 CRAN から通知．期限 2025-10-25．
- 2025-10-12 失敗内容の詳細が追送された．
- 期限までに対応されず，アーカイブ．

## 修正の方針

1. **`web_chamame()` を穏当に失敗させる**．
   接続失敗時に error を投げず，情報つきメッセージ(`message()`)を出して
   `NULL` などを返す．`try()` で包む，または `httr2` の `req_error()` を使う．
   `read_html()` を直接呼ぶ箇所が起点なので，そこを囲う．
2. **Examples をネットワークに触れない形にする**．
   `man/web_chamame.Rd` の `\examples{}` を `\dontrun{}` か `\donttest{}` にする．
   roxygen 側(`R/` 内の `@examples`)を直して `document()` し直すこと．
   保存済みの応答を使う形にできればなお良い．
   - 同様にネットワークを使う `neko_chamame` / `review_chamame` の Examples も点検する．
3. **テストをオフラインで skip する**．
   `tests/testthat/` 内でネットワークを使うものは `testthat::skip_if_offline()` などで飛ばす．
4. 修正後 `R CMD check --as-cran` を通し，`cran-comments.md` に
   アーカイブ理由と修正内容を書いて再投稿する．

## 作業前の注意

- **作業ブランチ**: 現在 `develop` にいる(`main` / `dev_for_debug` もある)．
  textmining2 は `remotes::install_github()` で **develop ブランチ**を導入している．
- **未コミットの変更がある**．先に内容を確認して整理すること．

  ```
   M DESCRIPTION
   M R/bigram.R
   M R/clean_up.R
   M R/make_group.R
   M R/moranajp.R
   M R/utils_id.R
   M tests/testthat/test-moranajp.R
  ```

- 最後の CRAN 投稿記録は `CRAN-SUBMISSION`: version 0.9.7 / 2024-07-30．

## 関連

- 依存元のアプリ: `d:\Dropbox\todo\textmining` (textmining2)．
  主要処理を moranajp に依存するため，この対応の影響が大きい．
  経緯は同リポジトリの `.claude/CLAUDE.md` の「TODO / 今後の候補」にも記録済み．
- 構想中の新パッケージ(textmining リポジトリの `design-sentence-connection.md`)も
  同じ形態素解析バックエンドを前提にしている．
  CRAN に出すなら最初から穏当な失敗の作りにしておく．
