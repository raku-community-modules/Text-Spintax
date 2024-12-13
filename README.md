[![Actions Status](https://github.com/raku-community-modules/Text-Spintax/actions/workflows/linux.yml/badge.svg)](https://github.com/raku-community-modules/Text-Spintax/actions) [![Actions Status](https://github.com/raku-community-modules/Text-Spintax/actions/workflows/macos.yml/badge.svg)](https://github.com/raku-community-modules/Text-Spintax/actions) [![Actions Status](https://github.com/raku-community-modules/Text-Spintax/actions/workflows/windows.yml/badge.svg)](https://github.com/raku-community-modules/Text-Spintax/actions)

NAME
====

Text::Spintax - A parser and renderer for spintax formatted text

SYNOPSIS
========

```raku
use Text::Spintax;

my $node = Text::Spintax.new.parse('This {is|was|will be} some {varied|random} text');
my $text = $node.render;
```

DESCRIPTION
===========

Text::Spintax implements a parser and renderer for spintax formatted text. Spintax is a commonly used method for generating "randomized" text. For example,

    This {is|was} a test

would be rendered as

    This is a test
    This was a test

Spintax can be nested indefinitely, for example:

    This is nested {{very|quite} deeply|deep}.

would be rendered as

    This is nested very deeply.
    This is nested quite deeply.
    This is nested deep.

AUTHOR
======

Dale Evans

COPYRIGHT AND LICENSE
=====================

Copyright 2016 - 2018 Dale Evans

Copyright 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

