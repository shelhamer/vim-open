# Opening files, urls, and emails from Vim

This plugin provides a mapping, helper functions, and syntax for opening and
highlighting files, urls, and emails with their default handlers.

At the moment this is specific to OSX through the `open` shell command.

## Usage

The mapping `<leader>g` will open the resource at the cursor whether it is a
file, url, or email.

Filepaths are designated by enclosing them in square brackets []. This is the
convention in markdown.

## TODO

- doesn't support filepaths including square brackets
- pick a better filepath delimiter for typing and detection?
- add support for other OS (someday/maybe)
