# vim-jade #

This is a fork of https://github.com/digitaltoad/vim-jade.git

Full-featured Vim plugin for Jade

Installation
------------

If using Tim Pope's [pathogen.vim](https://github.com/tpope/vim-pathogen).

Installation using

    cd ~/.vim/bundle
    git clone git://github.com/coachshea/jade-vim.git

If you do not want to use pathogen.  You can always install vim-jade in the 
normal manner by copying each directory to your ~/.vim directory.  Make sure 
not to overwrite any existing directory of the same name and instead copy only 
the contents of the source directory to the directory of the same name in your 
~/.vim directory.

To view the compiled jade in a preview window use the JadeWatch command

```
  :JadeWatch [html] [vert[ical]] [N]
```
The html option will show the output as html as opposed to the default javascript.

The vert[ical] option wil show the display window in a vertical split.

The N option is a number which represents the size of the window.

The default complilers can be set with these options:

```
  :let g:JadeCompiler="myfavoritecompiler"
  :let g:JadeHtmlCompiler="myfavoriteHTMLcompiler"
```
For convenience, it is recommended that shortcuts to your favorite options are set in you .vimrc file.
For example:
```
  au FILETYPE jade nnoremap <buffer> <LocalLeader>h :JadeWatch html vert<CR>
  au FILETYPE jade nnoremap <buffer> <LocalLeader>j :JadeWatch vert<CR>
```

