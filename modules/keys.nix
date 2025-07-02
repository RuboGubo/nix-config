{ pkgs, ... }:
{
  # Secrets
  clan.core.vars.generators."key.ssh.rubogubo" = {
    prompts.private_key = {
      type = "hidden";
      persist = false;
      description = "Enter your private key (empty to autogenerate)";
    };
    share = true;

    files.public_key.secret = false;
    files.private_key.secret = true;

    runtimeInputs = [
      pkgs.openssh
    ];
    script = ''
      if [ ! -s "$prompts/private_key" ]; then
        ssh-keygen -t ed25519 -f ./key -N "" -C "rubogubo"
        mv ./key $out/private_key
        mv ./key.pub $out/public_key
      else
        mv $prompts/private_key $out/private_key
        ssh-keygen -f $prompts/private_key -y > $out/public_key
      fi
    '';
  };

}
