{ config, pkgs, lib, ... }:

{
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        isDefault = true;
        name = "default";
        
        # Configurações do Firefox
        settings = {
          # Interface
          "ui.key.menuAccessKeyFocuses" = false;
          "extensions.pocket.enabled" = false;
          "browser.tabs.firefox-view" = false;
          "browser.uitour.enabled" = false;
          
          # Transições de tela cheia
          "full-screen-api.transition-duration.enter" = "0 0";
          "full-screen-api.transition-duration.leave" = "0 0";
          "full-screen-api.transition.timeout" = 0;
          "full-screen-api.warning.timeout" = 0;
          "full-screen-api.warning.delay" = -1;
          
          # Nova aba
          "browser.newtabpage.activity-stream.default.sites" = "";
          "browser.newtabpage.activity-stream.feeds.topsites" = false;
          "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
          
          # Segurança
          "signon.rememberSignons" = false;
          
          # Performance - descomente conforme necessário
          # "browser.cache.disk.enable" = false;
          # "gfx.webrender.all" = true;
          # "gfx.webrender.precache-shaders" = true;
          # "gfx.webrender.compositor" = true;
          # "gfx.canvas.accelerated" = true;
          # "layers.gpu-process.enabled" = true;
          # "media.hardware-video-decoding.enabled" = true;
        };
        
        # Extensões do Firefox
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          # Privacidade e segurança
          ublock-origin
          privacy-badger
          
          # Produtividade
          darkreader
          grammarly
          languagetool
          
          # Gestão de senhas
          bitwarden
          
          # Desenvolvimento
          react-devtools
          web-developer
          
          # Outros
          # Adicione suas extensões aqui conforme necessidade
          # Exemplo: youtube-enhancer
          # Exemplo: sponsorblock
        ];
        
        # Arquivos de configuração personalizados
        userChrome = ''
          /* Adicione seu CSS personalizado aqui */
        '';
        
        userContent = ''
          /* Adicione seu CSS personalizado para conteúdo web aqui */
        '';
        
        # Configurações de busca
        search = {
          default = "Google";
          force = true;
          engines = {
            "Nix Packages" = {
              urls = [{
                template = "https://search.nixos.org/packages";
                params = [
                  { name = "type"; value = "packages"; }
                  { name = "query"; value = "{searchTerms}"; }
                ];
              }];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [{ template = "https://nixos.wiki/index.php?search={searchTerms}"; }];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # 1 dia
              definedAliases = [ "@nw" ];
            };
            "GitHub" = {
              urls = [{ template = "https://github.com/search?q={searchTerms}"; }];
              iconUpdateURL = "https://github.com/fluidicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = [ "@gh" ];
            };
          };
        };
      };
    };
  };
} 