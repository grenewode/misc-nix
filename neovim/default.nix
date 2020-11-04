{ neovim, fzf, nixpkgs-fmt, ripgrep, stdenv, bash, vimPlugins }:
  neovim.override {
    viAlias = true;
    vimAlias = true;
    withNodeJs = true;
    withPython = true;
    withPython3 = true;
    withRuby = true;

    configure = {
      customRC = ''
        set hidden
        set mouse=n
        set mousemodel=popup_setpos
        set number
        set relativenumber
        set nowrap
        set clipboard=unnamedplus
        set cursorline
        set nocp

        if (has("termguicolors"))
          set termguicolors
          let g:gruvbox_italic=1

          let g:jellybeans_use_term_italics = 1
        endif

        nnoremap <ALT-<Right>> :bnext<CR>
        nnoremap <ALT-<Left>> :bprev<CR>

        " colorscheme wpgtkAlt
        autocmd vimenter * colorscheme gruvbox
        " autocmd vimenter * colorscheme jellybeans

        " highlight CursorLine gui=underline cterm=underline ctermfg=None guifg=None ctermbg=None ctermfg=None
        " highlight MatchParen gui=bold cterm=bold ctermfg=None ctermbg=None guifg=None guibg=None

        " Netrw settings
        let g:netrw_liststyle = 3 " Display using the "tree" style
        let g:netrw_special_syntax = 1
        let g:netrw_banner = 1

        " autocmd StdinReadPre * let s:std_in=1
        " autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'Explore' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
        autocmd VimEnter * if argc() == 0 | Explore! | endif

        function ToggleExplore()
          if exists(':Rexplore') 
            Rexplore
          else
            Explore!
          endif
        endfunction

        " From https://vi.stackexchange.com/a/17684
        let g:NetrwIsOpen=0

        function! ToggleNetrw()
            if g:NetrwIsOpen
          let i = bufnr("$")
          while (i >= 1)
              if (getbufvar(i, "&filetype") == "netrw")
            silent exe "bwipeout " . i 
              endif
              let i-=1
          endwhile
          let g:NetrwIsOpen=0
            else
          let g:NetrwIsOpen=1
          silent Explore
            endif
        endfunction

        nnoremap <C-\> :call ToggleExplore()<CR>
        " Triger `autoread` when files changes on disk
        " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
        " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
        autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
          \ if mode() !~ "\v(c|r.?|!|t)" && getcmdwintype() == "" | checktime | endif

        " Notification after file change
        " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
        autocmd FileChangedShellPost *
          \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

        set encoding=UTF-8

        let g:airline#extensions#tabline#enabled = 1
        " let g:airline_theme='wpgtk_alternative'

        let g:indent_guides_enable_on_vim_startup = 1

        " let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

        let g:airline_powerline_fonts = 1

        let g:eighties_enabled = 1
        let g:eighties_minimum_width = 80
        let g:eighties_compute = 1

        let g:rainbow_active = 1

        " https://stackoverflow.com/questions/4292733/vim-creating-parent-directories-on-save
        function s:MkNonExDir(file, buf)
            if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
          let dir=fnamemodify(a:file, ':h')
          if !isdirectory(dir)
              call mkdir(dir, 'p')
          endif
            endif
        endfunction
        augroup BWCCreateDir
            autocmd!
            autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
        augroup END

        let g:EasyMotion_do_mapping = 0 " Disable default mappings

        " Jump to anywhere you want with minimal keystrokes, with just one key binding.
        " `s{char}{label}`
        nmap s <Plug>(easymotion-overwin-f)

        " Turn on case-insensitive feature
        let g:EasyMotion_smartcase = 1

        " JK motions: Line motions
        map <Leader>j <Plug>(easymotion-j)
        map <Leader>k <Plug>(easymotion-k)
        set encoding=UTF-8

        " Enable integrations
        let g:deoplete#enable_at_startup = 1
        let g:airline#extensions#ale#enabled = 1

        " General settings
        let g:ale_sign_column_always = 1
        let g:ale_open_list = 1
        let g:ale_keep_list_window_open = 1
        let g:ale_set_quickfix = 1
        let g:ale_set_highlights = 1
        let g:ale_fix_on_save = 1
        let g:ale_virtualtext_cursor = 1
        let g:ale_list_vertical = 0

        let g:ale_shell = "${bash}/bin/bash"

        let g:ale_linters = {
            \ 'rust': ['rls', 'cargo'],
            \ }

        let g:ale_fixers = {
        \   '*': ['remove_trailing_lines', 'trim_whitespace'],
        \   'nix': ['nixpkgs-fmt'],
        \}

        let g:ale_rust_cargo_check_tests = 1
        let g:ale_rust_cargo_check_examples = 1
        let g:ale_rust_cargo_check_all_targets = 1
        let g:ale_rust_cargo_use_clippy = 1

        let g:ale_python_auto_pipenv = 1
        let g:ale_nix_nixpkgsfmt_executable = "${nixpkgs-fmt}/bin/nixpkgs-fmt"

        augroup CloseLoclistWindowGroup
        autocmd!
        autocmd QuitPre * if empty(&buftype) | lclose | endif
        augroup END

        function! RipgrepFzf(query, fullscreen)
          let command_fmt = '${ripgrep}/bin/rg --column --line-number --no-heading --color=always --smart-case -- %s || true'
          let initial_command = printf(command_fmt, shellescape(a:query))
          let reload_command = printf(command_fmt, '{q}')
          let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
          call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
        endfunction

        command! -nargs=* -bang Rg call RipgrepFzf(<q-args>, <bang>0)

        nnoremap <silent> <C-p> :Files<CR>
        nnoremap <silent> <C-f> :Rg<CR>
      '';

      packages.myVimPackage = with vimPlugins; {
        # see examples below how to use custom packages
        start = [
          fzf-vim
          fzfWrapper
          vim-airline
          vim-airline-themes
          direnv-vim
          vim-fugitive
          vim-sleuth
          vim-devicons
          vim-choosewin
          vim-commentary
          vim-sensible
          vim-vinegar
          vim-polyglot
          vim-multiple-cursors
          vim-SyntaxRange
          auto-pairs
          easymotion
          rainbow
          vim-eighties
          editorconfig-vim
          gruvbox
          deoplete-nvim
          ale
        ];
        opt = [];
      };
    };
  }
