# crlf problems on windows git

windowsのローカルで、gitを初期設定で使っていると、add時に以下の出力がみられる。

```bash
PS C:\Users\tomiyuichi\win_ws> git add .
warning: in the working copy of 'win_ws.code-workspace', LF will be replaced by CRLF the next time Git touches it
```

### Git は リポジトリ内部では常に LF を使うのが基本.

- git add した時点では、作業ディレクトリの改行コード（CRLF）を LF に変換してステージングする。
- ただし、gitattributes や Git の設定によって挙動が変わる
- git commit → git push でリモートに送られるのは LF の改行コードのファイル。
- ただ、以下の`core.autocrlf`は標準のubuntuのgit環境では、falseまたはinputになっているはずなので、cloneしてもLFで保たれるはずである。

```bash
PS C:\Users\tomiyuichi\win_ws> git config --get core.autocrlf
true
```

### しかしこのままでは、windows上にあるgitレポジトリをubuntuにコピーすると問題になる

- `git clone`経由でないものは、`core.autocrlf=true`のレポジトリのファイルはCRLFである。
- したがって、次のコマンドで、windowsのローカルレポジトリもLF改行にしておく。

```bash
git config core.autocrlf input
```

- こうしておけば、ローカルのファイルはLF改行で扱われる。
- 一部の古いエディタ（メモ帳）などはLF改行に対応していないケースがあるため、その点は注意が必要。
