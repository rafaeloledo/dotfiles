# Configuração AGS inspirada no Waybar

Esta configuração do AGS (Astal GTK Shell) foi criada para imitar a aparência e funcionalidade da configuração Waybar existente.

## Recursos

- Barra superior similar ao Waybar
- Seletor de workspaces com detecção de workspace ativa
- Relógio com data e hora
- Controle de volume com ícones dinâmicos

## Instalação

1. Certifique-se de ter o AGS instalado:
   ```
   # No NixOS
   nix-shell -p ags
   
   # Em outras distribuições, siga a documentação oficial do AGS
   ```

2. Clone este repositório:
   ```
   git clone https://github.com/seu-usuario/dotfiles.git
   cd dotfiles/ags
   ```

3. Instale as dependências:
   ```
   npm install
   ```

4. Execute o AGS:
   ```
   ags
   ```

## Personalização

- `style.scss` - Contém toda a estilização da barra
- `app.ts` - Ponto de entrada da aplicação
- `widget/Bar.tsx` - Componente principal da barra

## Integrações

Esta configuração depende de:
- Hyprland para gerenciamento de janelas
- pamixer para controle de volume

## Licença

Livre para uso e modificação. 