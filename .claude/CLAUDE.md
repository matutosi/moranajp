# moranajp プロジェクト

R パッケージ moranajp (日本語の形態素解析) の開発リポジトリ．

## check の生成物の後始末

- **`R CMD check` などで作られる `*.tar.gz` は，役割が終わったら削除する**．
  結果を確認し終えたら (CRAN へ出す場合は提出が済んだら) 消してよい．
  DESCRIPTION とソースから何度でも作り直せるため，残しておく理由がない．
- 同じ理由で，`*.Rcheck/` (check の作業ディレクトリ) も確認が済んだら消す．
- 補足: `*.tar.gz` を作るのは `R CMD build` / `devtools::build()` で，
  `devtools::check()` は既定で一時ディレクトリに作るためプロジェクト直下には残らない．
  プロジェクト直下に残るのは `R CMD build` を直接実行したときが多い．
  どちらの経路でできたものでも，見つけたら消す．

## 進捗状況

### 現在の状態

- 更新日時(JST): 2026-08-19 06:58
- 作業内容: TODO に残っていた2件を実装した(下記「IPAdic 対応」「make_groups() の例」)．
  Web茶まめの IPAdic を使えるようにし，`make_group.R` の `@example` の typo を直した．
  検証中に見つかった `col_lang = "en"` のバグも直した．
  `devtools::check()` は **0 errors / 0 warnings / 0 notes (Status: OK)**．
- 前回の作業: 単語のつながりから文章の構造・論理を解析するライブラリを調査し，
  `.claude/SURVEY-structure-analysis-libraries.md` にまとめた
  (係り受け / 談話構造 / 共起ネットワークの3層に整理．
  moranajp の後段の候補調べで，実装の予定を決めたものではない)．
  あわせて，作業中に git が異常に遅くなる問題を切り分けた(下記)．
- これまでの経緯: CRAN アーカイブ(2025-10-25, インターネット資源の扱いがポリシー違反)への対応が完了し，
  **0.9.8 が CRAN に受理された**(2026-08-05，Uwe Ligges 氏より
  "Thanks, on its way to CRAN.")．アーカイブから復帰した．
  `R CMD check --as-cran` は 0 errors / 0 warnings / 1 NOTE
  (NOTE は「New submission / Package was archived on CRAN」のみ)．
  あわせて Web茶まめの 2025年の仕様変更に追随し，茶まめの解析が動く状態に戻した．
  その後，**0.9.0 の zip 配布をやめ**，`READMEjp.Rmd` の導入案内を CRAN に統一した．

### IPAdic 対応(2026-08-19)

- Web茶まめは**辞書によって結果の列が違う**．実際に投げて確かめた．
  - UniDic 系(`gendai` / `unidic-spoken` / 各時代の辞書): **9列**．
    `キー(＝表層形)` / `大分類` / `中分類` / `小分類` / `細分類` / `書字形(基本形)` を使う．
  - IPAdic: **12列**．`キー(＝表層形)` / `品詞` / `品詞-大分類` / `品詞-中分類` /
    `品詞-小分類` / `原型` を使う(ほかに `読み` `発音` `活用型` `活用形`)．
  - **IPAdic は品詞そのものが `品詞`，その下位が `品詞-大分類`…** という命名で，
    UniDic の `大分類` が品詞にあたるのとずれている．
    基本形の漢字も `原型`(UniDic は `書字形(基本形)` の `形`)で違う．
- そこで `cols_chamame(dic)` を辞書別にし，`is_ipadic()` を足した．
  `check_chamame_table()` と `extract_chamame_cols()` も `dic` を受け取る．
  **出力は従来どおり `out_cols_chamame()` の6列**に揃うので，後段は変わらない．
  文の区切り(`add_sentence_no()`)は `品詞細分類1` に `句点` を探すが，
  IPAdic も `記号 / 句点` になるのでそのまま動く．
- **`col_lang = "en"` が壊れていた**(IPAdic とは無関係の既存バグ)．
  改行 `BP` を戻す処理が日本語の列名 `表層形` を決め打ちしていたが，
  その時点では `extract_chamame_cols()` が `form` に改名済みで，
  0行を代入しようとして落ちていた．`out_cols_chamame(col_lang)[1]` を使うように直した．
- 検証: `neko` の先頭2件を実際に茶まめへ投げ，unidic-spoken が 294行，
  ipadic が 274行(分かち書きが違うので行数は一致しない)，`col_lang = "en"` も可．
  **追加したテストはネットワークを使わない**(列名の対応だけを見る)．

### make_groups() の例(2026-08-19)

- `@example` は**ファイルパスを取るタグ**なので，roxygen が警告を出して
  スニペットを捨てており，Rd には `@inherit moranajp_all` が継承した例が入っていた．
- `@examples` に直すと継承した例を上書きするため，**単体で動く例に書き直した**．
  `make_groups()` は未 export なので `moranajp:::make_groups()` として呼ぶ．
  この書き方で `R CMD check` は NOTE を出さない(実際に確認した)．

### 開発環境のはまりどころ(2026-08-08 に切り分け)

このリポジトリは `d:\Dropbox\todo\moranajp` にあり，Dropbox 同期下にある．

- **Dropbox が劣化すると全部が遅くなる**．ファイルを開くたびに約4秒の待ちが入り，
  `git rev-parse HEAD` が 10.2秒，`git status` が 28.5秒になった
  (ファイルの大きさは無関係で，35バイトも652KBも一律4秒．帯域ではなくオープン処理の問題)．
  - **対処は Dropbox の再起動**．10.2秒 → 0.09秒 に戻った．
    劣化時は Dropbox の累積CPUが 5,655秒 / 6プロセスまで膨らんでいた．
    遅いと感じたら `Get-Process Dropbox | Measure-Object CPU -Sum` を見る．
  - **効かなかったもの**: `com.dropbox.ignored` による同期除外
    (`.git` 単体でもフォルダ全体でも変化なし)．リポジトリを Dropbox の外に移すのは
    効くが，再起動で足りるので元の場所に戻した．
  - 新規作成したファイルの読み書きは劣化時でも速い(10ms程度)ので，
    新規ファイルでベンチを取ると「Dropbox は遅くない」と誤診する．
- **`git push` が無出力のまま固まることがある**．GitHub が 401 を返すと
  `credential.helper = manager` (Git Credential Manager) が対話認証を待ち続けるため．
  `GCM_INTERACTIVE=never` や `-c credential.interactive=false` では止まらない．
  - 回避: gh CLI が認証済みなので，その場かぎりのヘルパで押す．

    ```powershell
    git -c credential.helper= -c 'credential.helper=!gh auth git-credential' push origin develop
    ```

### zip 配布をやめた経緯

- `zip/moranajp_0.9.0.zip`(2021年，git 追跡下)を削除した．
  `READMEjp.Rmd` が `https://github.com/matutosi/moranajp/tree/main/zip` を
  Windows 版の配布場所として案内していたが，5年前の版であり，
  いまは `install.packages("moranajp")` で入るため役目を終えた．
- あわせて `READMEjp.Rmd` の
  「日本語話者のみを対象としていますので，cranでの公開は予定していません．」を
  「cranで公開しています．」に直した(直下のコードブロックが
  `install.packages("moranajp")` を案内しており矛盾していた)．
- `.Rbuildignore` の `^zip$` は，対象が無くなっても害がないので残してある．
- `READMEjp.Rmd` / `README.Rmd` から生成した `.md` はこのリポジトリに無いので，
  再生成は不要(textmining とは違う点)．

### リリースの記録

- 投稿: 2026-08-05 02:33 UTC / 受理: 2026-08-05．
- 投稿した版: 0.9.8 / SHA `7b0ddad`．
  **`v0.9.8` タグはこの `7b0ddad` を指す**(CRAN の tarball と同一のツリー)．
- `usethis::use_github_release()` は `CRAN-SUBMISSION` を読んで
  **そこに記録された SHA にタグを打ち，そのファイルを削除する**．
  tip に打たれるわけではないので，投稿記録のコミットを別に作っても
  タグはそちらへは付かない．
  投稿の追跡は，このタグと `CRAN-SUBMISSION` を含むコミット(`cffca98`)で辿れる．
- `main` と `develop` は同じコミットに揃えてある(develop → main のマージが
  そのまま develop へ早送りされた)．
- 検証した環境
  - local: Windows 11, R 4.5.1 → 0 errors / 0 warnings / 1 NOTE
  - win-builder: Windows Server 2022, R-devel (2026-08-04 r90350) → 1 NOTE
  - R-hub: ubuntu-latest / windows-latest / macos-15-intel の R-devel → すべて `Status: OK`
- **`develop` に purrr 1.2.0 対応が入っていなかった**ことが main へのマージで判明した．
  `is_radio()` の `purrr::map_chr(`$`, "type")` は purrr 1.2.0 で壊れる
  (main 側に hadley 氏の PR #1 として入っていた修正)．
  `is_radio()` は `web_chamame()` がフォームのラジオボタンを設定するのに使うので，
  壊れると茶まめの解析が動かない．ローカルの purrr は 1.0.4 なので check では出ない．
  main へマージしたことで修正が入った状態で投稿できている．

### 今回やったこと

1. **`web_chamame()` を穏当に失敗させた**(アーカイブの直接原因への対応)
   - `read_html_safely()`: ページ取得の失敗で error を投げず，`message()` + `NULL`．
   - `submit_chamame()`: フォーム送信と結果の解析も `try()` で包み，
     HTTP ステータスと結果表の中身(`check_chamame_table()`)を点検する．
   - `moranajp_all(method = "chamame")` も `NULL` を返す．
2. **ネットワークに触れる Examples を `\dontrun{}` にした**
   - `web_chamame` と `moranajp_all` の茶まめ例．
   - `make_groups` は `@inherit moranajp_all` で例を継承するので，これも同時に解決．
     ここが `\donttest{}` のままだと CRAN の check で実行されてしまう(アーカイブの一因)．
3. **テストはネットワークを使わない**
   - 追加したのは「使えないときに `NULL` を返す」テストのみ(`http://127.0.0.1:1/` を使う)．
4. **Web茶まめの 2025年仕様変更に追随**(調査で判明した別のバグ)
   - フォームの項目が 62 → 70 に増え，**ハードコードした番号が全部ずれていた**．
     → 番号ではなく**名前で選ぶ** `select_chamame_fields()` に変更．
   - 新設の `dic_version` を送らないと，UniDic 系の辞書で
     **サーバが 500 Internal Server Error を返す**(これが茶まめが壊れていた原因)．
     → `dic_version` を残すようにして復旧．
   - 辞書を選ぶ `dic` 引数を追加(既定 `"unidic-spoken"`)．
   - **出力列のマッピングを直した**．
     出力項目を多く要求すると，応答の**見出し行とセルが対応しない**ことが判明．
     必要な項目(`f3` 品詞・`f3_1`〜`f3_4` 品詞の大中小細分類・`f12` 書字形(基本形))
     **だけ**を要求すると見出しとセルが一致するので，**列名で選ぶ**ようにした．
     - `品詞` = 大分類，`品詞細分類1` = 中分類，`品詞細分類2` = 小分類，
       `品詞細分類3` = 細分類，`原形` = **書字形(基本形)**(語彙素ではない．
       `で → だ` と `ある → ある` の両方を満たすのは書字形(基本形)だけ)．
     - 以前の位置指定 `select(3, 9:12, 4)` は `品詞 = 活用型`，`原形 = 語彙素` を拾っていた．
       28列目は短単位の品詞ではなく**長単位品詞**で，長単位の途中では `*` になる．
     - 保存済み `neko_chamame` の先頭294行と照合し，
       差は2件のみ(茶まめ側の辞書更新: `スー` の品詞，`この頃` の分割)まで一致することを確認．
     - 照合用のスクリプトを `data-raw/check_chamame.R` に置いた
       (ネットワークを使うのでテストには入れない．
       `tools/` は `.gitignore` 済みなので `data-raw/` に置いている)．
5. **check を通すための既存バグの修正**
   - `add_sentence_no()`: `cond` の文字列を評価する環境が誤りで，
     `df` が `stats::df` に解決されて example が ERROR になっていた．
     `eval_str(str, envir)` を追加し，`add_group()` から呼び出し元の環境を渡す．
     英語列名側の `cond_2` も壊れていた(`".$pos_1 == '句点\\'"`)ので直した．
   - `add_depend_ginza()`: `add_sentence_no(df, {{s_id}})` の余分な引数を削除
     (install 時の WARNING と NOTE の原因)．
   - `eval_str()` の引数を文書化(Rd の WARNING)．
   - `add_text_id()`: `brk` 引数を復活．`dplyr::lag()` を外して 0.9.7 の挙動に戻した
     (テストが期待する「brk は次のテキストに属する」)．
   - `.data[[x]]` → `dplyr::all_of(x)` は **tidyselect の文脈だけ**に限定して修正
     (`select()`, `tidyr::separate()` の列指定)．data-masking の `filter()`/`mutate()`/
     `group_by()` では `.data[[x]]` が正しい．
   - バージョンを 0.9.8 に，`NEWS.md` と `cran-comments.md` を更新．

### 未コミットだった変更の扱い

作業開始時にあった未コミットの変更は，`.data[[x]]` を
**一律** `tidyselect::all_of(x)` に置換するものだった．
これは `filter()` などの data-masking では動かず，`tidyselect` も Imports に無いため，
**破棄した**(patch は保存済み: セッションの scratchpad の `wip-tidyselect-refactor.patch`．
必要なら `git stash` の代わりに参照)．
必要な部分だけ上記 5. で作り直してある．

## TODO / 今後の候補

- [x] **CRAN へ再投稿し，受理された**(2026-08-05)．
  - [x] `v0.9.8` タグ / GitHub Release を作成
  - [x] develop を 0.9.8.9000 に戻す
  - [x] textmining の `.claude/CLAUDE.md` の TODO を done.md へ移す
- [x] **`dic = "ipadic"` に対応した**(2026-08-19)．`cols_chamame()` を辞書別にした．
- [x] **`R/make_group.R` の `@example` の typo を直した**(2026-08-19)．
- [ ] IPAdic は `読み` `発音` `活用型` `活用形` も返すが，いまは捨てている．
  MeCab の出力(`out_cols_mecab()` の10列)に寄せるなら，
  `out_cols_chamame()` を辞書別にする必要がある(後段の列名も変わる)．
