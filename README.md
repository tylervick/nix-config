# nix-config

Based on @dustinlyons's awesome [nix-config](https://github.com/dustinlyons/nixos-config) repository. See the original README for more information.

# Installation

## For macOS (April 2024)
This configuration supports both Intel and Apple Silicon Macs.

### 1. Install dependencies
```sh
xcode-select --install
```

### 2. Install Nix
Thank you for the [installer](https://zero-to-nix.com/concepts/nix-installer), [Determinate Systems](https://determinate.systems/)!
```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```
> [!IMPORTANT]
>
> If using [the official installation instructions](https://nixos.org/download) instead, [`flakes`](https://nixos.wiki/wiki/Flakes) and [`nix-command`](https://nixos.wiki/wiki/Nix_command) aren't available by default.
>
> You'll need to enable them.
> 
> **Add this line to your `/etc/nix/nix.conf` file**
> ```
> experimental-features = nix-command flakes
> ```
> 
> **_OR_**
>
> **Specify experimental features when using `nix run` below**
> ```
> nix --extra-experimental-features 'nix-command flakes' run .#<command>
> ```

### 3. Clone this repository
```sh
git clone git@github.com/tylervick/nix-config
cd nix-config
```

### 4. Make apps executable
```sh
find apps/$(uname -m | sed 's/arm64/aarch64/')-darwin -type f \( -name apply -o -name build -o -name build-switch -o -name create-keys -o -name copy-keys -o -name check-keys \) -exec chmod +x {} \;
```

### 5. Setup secrets

#### 5a. Install keys
Before generating your first build, these keys must exist in your `~/.ssh` directory. Don't worry, I provide a few commands to help you.

| Key Name            | Platform         | Description                           | 
|---------------------|------------------|---------------------------------------|
| id_ed25519          | macOS / NixOS    | Used to download secrets from Github. |
| id_ed25519_agenix   | macOS / NixOS    | Used to encrypt and decrypt secrets.  |

Run one of these commands:

##### Copy keys from USB drive
This command auto-detects a USB drive connected to the current system.
> Keys must be named `id_ed25519` and `id_ed25519_agenix`.
```sh
nix run .#copy-keys
```

##### Create new keys
```sh
nix run .#create-keys
```
> [!NOTE]
> If you choose this option, make sure to [save the value](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account) of `id_ed25519.pub` to Github.
> 
> ```sh
> cat /Users/$USER/.ssh/id_ed25519.pub | pbcopy # Copy key to clipboard
> ```

##### Check existing keys
If you're rolling your own, just check they are installed correctly.
```sh
nix run .#check-keys
```

### 6. Install configuration
Ensure the build works before deploying the configuration, run:
```sh
nix run .#build
```

### 7. Make changes and activate
Finally, alter your system with this command:
```sh
nix run .#build-switch
```
> [!CAUTION]
> `~/.zshrc` will be replaced with the [`zsh` configuration](https://github.com/dustinlyons/nixos-config/blob/main/templates/starter/modules/shared/home-manager.nix#L8) from this repository. Make sure this is what you want.


## For NixOS
See the original README for instructions, I do not currently use NixOS as a daily driver.
