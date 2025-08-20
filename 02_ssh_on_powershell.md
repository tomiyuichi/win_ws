### windowsでssh接続を受け付けるための設定

```bash
PS C:\windows\system32> Set-Service -Name sshd -StartupType Automatic
PS C:\windows\system32> Start-Service sshd
PS C:\windows\system32> New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22


Name                          : sshd
DisplayName                   : OpenSSH Server (sshd)
Description                   :
DisplayGroup                  :
Group                         :
Enabled                       : True
Profile                       : Any
Platform                      : {}
Direction                     : Inbound
Action                        : Allow
EdgeTraversalPolicy           : Block
LooseSourceMapping            : False
LocalOnlyMapping              : False
Owner                         :
PrimaryStatus                 : OK
Status                        : 規則は、ストアから正常に解析されました。 (65536)
EnforcementStatus             : NotApplicable
PolicyStoreSource             : PersistentStore
PolicyStoreSourceType         : Local
RemoteDynamicKeywordAddresses : {}
PolicyAppId                   :
PackageFamilyName             :

```

```bash
PS C:\Users\富雄一> whoami
azuread\富雄一
PS C:\Users\富雄一> netstat -an | findstr 22
  TCP         0.0.0.0:22             0.0.0.0:0              LISTENING
  TCP         172.16.120.74:51069    172.16.120.93:22       ESTABLISHED
  TCP         172.16.120.74:51347    74.125.204.188:5228    ESTABLISHED
  TCP         172.16.120.74:53257    216.239.32.223:443     CLOSE_WAIT
  TCP         172.16.120.74:53392    142.250.157.188:5228   ESTABLISHED
  TCP         172.16.120.74:53605    216.239.32.223:443     TIME_WAIT
  TCP         172.16.120.74:53608    216.239.32.223:443     TIME_WAIT
  TCP         172.16.120.74:53611    216.239.32.223:443     ESTABLISHED
  TCP         172.16.120.74:53772    162.159.140.229:443    ESTABLISHED
  TCP         172.16.120.74:53922    34.36.216.150:443      ESTABLISHED
  TCP         172.16.120.74:53999    52.223.2.229:443       ESTABLISHED
  TCP         172.16.120.74:54021    172.217.161.226:443    TIME_WAIT
  TCP         172.16.120.74:54022    72.145.35.108:443      TIME_WAIT
  TCP         172.16.120.74:54065    182.22.25.252:443      ESTABLISHED
  TCP         172.16.120.74:54076    142.250.206.226:443    ESTABLISHED
  TCP         172.16.120.74:54166    172.217.161.227:443    ESTABLISHED
  TCP         172.16.120.74:54199    172.217.161.227:443    ESTABLISHED
  TCP         [::]:22                [::]:0                 LISTENING
  UDP         0.0.0.0:50473          172.217.161.227:443
  UDP         0.0.0.0:54229          *:*
  UDP         [::]:54229             *:*
ubuntu@rpi3bty:~ $ ssh azuread\富雄一@172.16.120.73
ssh: connect to host 172.16.120.73 port 22: No route to host
```

- 上記問題に対して、以下の通り対策する。
- ネットワークのプロパティで、デフォルトの`パブリックネットワーク`設定を、`プライベートネットワーク`設定に変更する
- これで、ファイアーウォールではじかれなくなるはず


```bash
ubuntu@rpi3bty:~ $ ssh azuread\富雄一@172.16.120.74
azuread富雄一@172.16.120.74's password:
Permission denied, please try again.
azuread富雄一@172.16.120.74's password:

ubuntu@rpi3bty:~ $ ssh -v azuread\富雄一@172.16.120.74
OpenSSH_9.2p1 Debian-2+deb12u6, OpenSSL 3.0.16 11 Feb 2025
debug1: Reading configuration data /etc/ssh/ssh_config
debug1: /etc/ssh/ssh_config line 19: include /etc/ssh/ssh_config.d/*.conf matched no files
debug1: /etc/ssh/ssh_config line 21: Applying options for *
debug1: Connecting to 172.16.120.74 [172.16.120.74] port 22.
debug1: Connection established.
debug1: identity file /home/ubuntu/.ssh/id_rsa type -1
debug1: identity file /home/ubuntu/.ssh/id_rsa-cert type -1
debug1: identity file /home/ubuntu/.ssh/id_ecdsa type -1
debug1: identity file /home/ubuntu/.ssh/id_ecdsa-cert type -1
debug1: identity file /home/ubuntu/.ssh/id_ecdsa_sk type -1
debug1: identity file /home/ubuntu/.ssh/id_ecdsa_sk-cert type -1
debug1: identity file /home/ubuntu/.ssh/id_ed25519 type -1
debug1: identity file /home/ubuntu/.ssh/id_ed25519-cert type -1
debug1: identity file /home/ubuntu/.ssh/id_ed25519_sk type -1
debug1: identity file /home/ubuntu/.ssh/id_ed25519_sk-cert type -1
debug1: identity file /home/ubuntu/.ssh/id_xmss type -1
debug1: identity file /home/ubuntu/.ssh/id_xmss-cert type -1
debug1: identity file /home/ubuntu/.ssh/id_dsa type -1
debug1: identity file /home/ubuntu/.ssh/id_dsa-cert type -1
debug1: Local version string SSH-2.0-OpenSSH_9.2p1 Debian-2+deb12u6
debug1: Remote protocol version 2.0, remote software version OpenSSH_for_Windows_9.5
debug1: compat_banner: match: OpenSSH_for_Windows_9.5 pat OpenSSH* compat 0x04000000
debug1: Authenticating to 172.16.120.74:22 as 'azuread\345\257\214\351\233\204\344\270\200'
debug1: load_hostkeys: fopen /home/ubuntu/.ssh/known_hosts2: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts2: No such file or directory
debug1: SSH2_MSG_KEXINIT sent
debug1: SSH2_MSG_KEXINIT received
debug1: kex: algorithm: curve25519-sha256
debug1: kex: host key algorithm: ssh-ed25519
debug1: kex: server->client cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: kex: client->server cipher: chacha20-poly1305@openssh.com MAC: <implicit> compression: none
debug1: expecting SSH2_MSG_KEX_ECDH_REPLY
debug1: SSH2_MSG_KEX_ECDH_REPLY received
debug1: Server host key: ssh-ed25519 SHA256:STWnf2TYpmfi17TRWVSKJ9aD8Ipco1q21eHEvu1k24o
debug1: load_hostkeys: fopen /home/ubuntu/.ssh/known_hosts2: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts: No such file or directory
debug1: load_hostkeys: fopen /etc/ssh/ssh_known_hosts2: No such file or directory
debug1: Host '172.16.120.74' is known and matches the ED25519 host key.
debug1: Found key in /home/ubuntu/.ssh/known_hosts:1
debug1: ssh_packet_send2_wrapped: resetting send seqnr 3
debug1: rekey out after 134217728 blocks
debug1: SSH2_MSG_NEWKEYS sent
debug1: expecting SSH2_MSG_NEWKEYS
debug1: ssh_packet_read_poll2: resetting read seqnr 3
debug1: SSH2_MSG_NEWKEYS received
debug1: rekey in after 134217728 blocks
debug1: Will attempt key: /home/ubuntu/.ssh/id_rsa
debug1: Will attempt key: /home/ubuntu/.ssh/id_ecdsa
debug1: Will attempt key: /home/ubuntu/.ssh/id_ecdsa_sk
debug1: Will attempt key: /home/ubuntu/.ssh/id_ed25519
debug1: Will attempt key: /home/ubuntu/.ssh/id_ed25519_sk
debug1: Will attempt key: /home/ubuntu/.ssh/id_xmss
debug1: Will attempt key: /home/ubuntu/.ssh/id_dsa
debug1: SSH2_MSG_EXT_INFO received
debug1: kex_input_ext_info: server-sig-algs=<ssh-ed25519,sk-ssh-ed25519@openssh.com,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,sk-ecdsa-sha2-nistp256@openssh.com,webauthn-sk-ecdsa-sha2-nistp256@openssh.com,ssh-dss,ssh-rsa,rsa-sha2-256,rsa-sha2-512>
debug1: kex_input_ext_info: publickey-hostbound@openssh.com=<0>
debug1: kex_input_ext_info: ping@openssh.com (unrecognised)
debug1: SSH2_MSG_SERVICE_ACCEPT received
debug1: Authentications that can continue: publickey,password,keyboard-interactive
debug1: Next authentication method: publickey
debug1: Trying private key: /home/ubuntu/.ssh/id_rsa
debug1: Trying private key: /home/ubuntu/.ssh/id_ecdsa
debug1: Trying private key: /home/ubuntu/.ssh/id_ecdsa_sk
debug1: Trying private key: /home/ubuntu/.ssh/id_ed25519
debug1: Trying private key: /home/ubuntu/.ssh/id_ed25519_sk
debug1: Trying private key: /home/ubuntu/.ssh/id_xmss
debug1: Trying private key: /home/ubuntu/.ssh/id_dsa
debug1: Next authentication method: keyboard-interactive
debug1: Authentications that can continue: publickey,password,keyboard-interactive
debug1: Next authentication method: password
azuread富雄一@172.16.120.74's password:
debug1: Authentications that can continue: publickey,password,keyboard-interactive
Permission denied, please try again.
azuread富雄一@172.16.120.74's password:
debug1: Authentications that can continue: publickey,password,keyboard-interactive
Permission denied, please try again.
azuread富雄一@172.16.120.74's password:
debug1: Authentications that can continue: publickey,password,keyboard-interactive
debug1: No more authentication methods to try.
azuread\345\257\214\351\233\204\344\270\200@172.16.120.74: Permission denied (publickey,password,keyboard-interactive).
```

- 接続自体はできるが、認証が通らないという状態まではきた。
- この先はもう、英数字のユーザー名のローカルアカウントを作成するしかない。

### ローカルアカウントの追加

```bash
net user sshuser StrongPassword123! /add
```

- `sshuser`というユーザー名で、アカウントを作ったことでsshでログインできるようになった。
- sshでログインした瞬間に、ホームディレクトリなどが自動で作られた模様。
- しかしログインシェルが`コマンドプロンプト`のようで、`ls`などのlinuxコマンドが使えず不便。
- しかしコンソール上で明示的に`powershell`とうつと、シェルがpowershellに変更される模様。
