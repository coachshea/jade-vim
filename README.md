# Jade-Vim #

Full-featured Vim plugin for Jade

This is a fork of [vim-jade](https://github.com/digitaltoad/vim-jade.git)

## Installation

Installation using Tim Pope's [pathogen.vim](https://github.com/tpope/vim-pathogen).

```
cd ~/.vim/bundle git clone git://github.com/coachshea/jade-vim.git
```

If you do not want to use pathogen. You can always install vim-jade in the
normal manner by copying each directory to your ~/.vim directory.  Make sure not
to overwrite any existing directory of the same name and instead copy only the
contents of the source directory to the directory of the same name in your
~/.vim directory.

## Usage

To view the compiled jade in a preview window use the JadeWatch command

```
:JadeWatch [html] [vert[ical]] [N]
```

The html option will show the output as html as opposed to the default
javascript.

The vert[ical] option wil show the display window in a vertical split.

The N option is a number which represents the size of the window.

Once a preview window is opened, it will automatically update on InsertLeave and
on BufWritePost

For convenience, it is recommended that shortcuts to your favorite options are
set in you .vimrc file.  For example:

```
au FILETYPE jade nnoremap <buffer> <LocalLeader>h :JadeWatch html vert<CR>
au FILETYPE jade nnoremap <buffer> <LocalLeader>j :JadeWatch vert<CR>
```

The default complilers can be set with these options:

```
:let g:JadeCompiler = "myfavoritecompiler"
:let g:JadeHtmlCompiler = "myfavoriteHTMLcompiler"
```

## jadeclient
    
Many people use [clientjade](https://github.com/jgallen23/clientjade.git) to
compile their front-end jade templates. Unfortunately, clientjade does not allow
for compilation from stdin and, therefore, does not play nice with this plugin.
I have created a fork of clientjade called
[jadeclient](https://github.com/coachshea/jadeclient.git), which is a superset
of clientjade.  You can  use it just as you've used clientjade and get the exact
same results.  However, it has one additional option "-s" or "--stdin"
which allows for reading over stdin.  For example:

```
$echo "h1 hello" | jadeclient -s

jade.templates["buffer"] = function(locals, attrs, escape, rethrow, merge) {
attrs = attrs || jade.attrs; escape = escape || jade.escape; rethrow =
rethrow || jade.rethrow; merge = merge || jade.merge; var buf = []; with
(locals || {}) { var interp; buf.push('<hello></hello>'); } return
buf.join(""); }
```

To use jadeclient with vim-jade simple type the following command (assuming a
global install, although it will work with a local install as well):

```
:let g:JadeCompiler = "jadeclinet -s"
```

This is, of course, not suited for production as every function will be named
"buffer", however it will allow you to quickly see what the compiled javascript
(minus the function name) will look like.

If you are someone who uses jadeclient frequently, be sure to set the
global variable in your .vimrc to save time.

