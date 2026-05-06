{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    libreoffice

    # spellcheck
    hunspell
    hunspellDicts.en_US
    hunspellDicts.ru_RU

    # hyphenation
    hyphenDicts.en_US
    hyphenDicts.ru_RU
  ];
}
