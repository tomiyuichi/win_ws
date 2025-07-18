### install chocolatey

- 管理者権限でpowershellから、以下のコマンドを実行してchocolateyをインストールする。
- 以下のスクリプトはバッチファイルで実行するとエラーになるので、直接コマンドを入力すること。

```ps1
Set-ExecutionPolicy Bypass -Scope Process -Force; `
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; `
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

```

### [FAILURE] install heif-convert

- chocoはインストールできたが、libheifはどうやらchocolateyのリポジトリに存在しない模様。(ubuntuのみ)

```ps1
PS C:\Users\富雄一\win_ws> choco install libheif -y
Chocolatey v2.5.0
Installing the following packages:
libheif
By installing, you accept licenses for the packages.
libheif not installed. The package was not found with the source(s) listed.
 Source(s): 'https://community.chocolatey.org/api/v2/'
 NOTE: When you specify explicit sources, it overrides default sources.
If the package version is a prerelease and you didn't specify `--pre`,
 the package may not be found.
Please see https://docs.chocolatey.org/en-us/troubleshooting for more
 assistance.

Chocolatey installed 0/1 packages. 1 packages failed.
 See the log for details (C:\ProgramData\chocolatey\logs\chocolatey.log).

Failures
 - libheif - libheif not installed. The package was not found with the source(s) listed.
 Source(s): 'https://community.chocolatey.org/api/v2/'
 NOTE: When you specify explicit sources, it overrides default sources.
If the package version is a prerelease and you didn't specify `--pre`,
 the package may not be found.
Please see https://docs.chocolatey.org/en-us/troubleshooting for more
 assistance.
```

### install Image Magic

- 公式からimagemagicをダウンロードしてインストール
- インストールウィザードの中で、実行バイナリの場所をPATHに追加する選択をしておく。

### .bat形式のスクリプトが現代のwindowsでは古いことが判明。

- 時間取得機能などが、思ったように動作しない。
- コマンドプロンプトではなく、powershellのスクリプト`.ps1`を使うのが、現在では推奨らしい。
- windows7以降で使用可能、windows10以降は標準搭載されているらしい。
- ps1はutf8で日本語が文字化けする。shiftjisで記述すること。

### 環境のps1実行ポリシーチェック

#### 現在の実行ポリシー確認

- `Get-ExecutionPolicy -List`を実行する。

```ps1
Get-ExecutionPolicy -List

        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser       Undefined
 LocalMachine       Undefined

```

- `CurrentUser` や `LocalMachine` のポリシーが Restricted になっていると、.ps1 スクリプトは実行できないらしい。
- `RemoteSigned` や `Unrestricted` にして、ローカルで作成した .ps1 ファイルを実行可能にする。

#### 実行可能なポリシーに変更

- 管理者権限で、powershellから`Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`を実行する。

```ps1
PS C:\windows\system32> Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

実行ポリシーの変更
実行ポリシーは、信頼されていないスクリプトからの保護に役立ちます。実行ポリシーを変更すると、about_Execution_Policies
のヘルプ トピック (https://go.microsoft.com/fwlink/?LinkID=135170)
で説明されているセキュリティ上の危険にさらされる可能性があります。実行ポリシーを変更しますか?
[Y] はい(Y)  [A] すべて続行(A)  [N] いいえ(N)  [L] すべて無視(L)  [S] 中断(S)  [?] ヘルプ (既定値は "N"): y

PS C:\windows\system32> Get-ExecutionPolicy -List

        Scope ExecutionPolicy
        ----- ---------------
MachinePolicy       Undefined
   UserPolicy       Undefined
      Process       Undefined
  CurrentUser    RemoteSigned
 LocalMachine       Undefined

```

#### ネット上からダウンロードしたスクリプトの署名確認/ブロック解除用コマンド

```ps1
# 署名確認方法
Get-AuthenticodeSignature "/path/to/script/file.ps1"
# ex.
# SignerCertificate      : 
# Status                 : NotSigned # 自作スクリプトはこれでOK
# StatusMessage          : The file is not signed

# ブロック解除
Unblock-File -Path "/path/to/script/file.ps1"


```