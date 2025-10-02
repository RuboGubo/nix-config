{ ... }:
{
  # Email configuration
  accounts.email = {
    accounts."ruben.john.ward@gmail.com" = {
      address = "ruben.john.ward@gmail.com";
      userName = "ruben.john.ward@gmail.com";
      realName = "Ruben Ward";
      primary = true;

      # imap = {
      #   host = "imap.gmail.com";
      #   port = 993;
      #   tls.enable = true;
      # };

      # smtp = {
      #   host = "smtp.gmail.com";
      #   port = 587;
      #   tls = {
      #     enable = true;
      #     useStartTls = true;
      #   };
      # };

      thunderbird.enable = true;

      flavor = "gmail.com";
    };
  };
}
