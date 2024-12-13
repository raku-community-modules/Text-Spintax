class Text::Spintax {

    class NullNode {
        method render { "" }
    }

    class SequenceNode {
        has @.children;
        method render { @!children>>.render.join("") }
    }

    class TextNode {
        has $.text;
        method render { $!text }
    }

    class SpinNode {
        has @.children;
        method render {
            my @opt_children = @!children[0].children;
            @opt_children[@opt_children.elems.rand.truncate].render;
        }
    }

    grammar Spintax {
        token TOP {
            <sequence>
        }
        token text { <-[\{\}|]>+ }
        token lpar { \{ }
        token rpar { \} }
        token pipe { \| }
        token sequence {
            <renderable>*
        }
        token renderable {
            [
            | <text>
            | <spin>
            ]
        }
        token spin {
            <junk=.lpar> <opts> <junk=.rpar>
        }
        token opts {
            [
            <sequence> <junk=.pipe>
            ]*
            <sequence>
        }
        rule chunk {
            <text>|<opt>
        }
    }

    class Spinaction {
        method TOP($/) {
            my $seq = $<sequence>;
            make SequenceNode.new(children => $<sequence>.ast);
        }
        method sequence($/) {
            my @children = $<renderable>>>.ast;
            my $seq =  SequenceNode.new(children => @children);
            make $seq;
        }
        method renderable($/) {
            my @children;
            if ($<spin>.ast) {
                @children.push($<spin>.ast);
            }
            if ($<text>.ast) {
                @children.push($<text>.ast);
            }
            make SequenceNode.new(children => @children);
        }
        method lpar($/) {
            make NullNode.new;
        }
        method rpar($/) {
            make NullNode.new;
        }
        method pipe($/) {
            make NullNode.new;
        }
        method text($/) {
            my $text = ~$/;
            make TextNode.new(text => ~$/);
        }
        method opts($/) {
            my @children = $<sequence>».ast;
            make SequenceNode.new(children => @children);
        }
        method spin($/) {
            my @children = $<opts>.ast;
            make(SpinNode.new(children => @children));
        }
    }

    method parse ($text) {
        my $actions = Spinaction.new;
        my $match = Spintax.parse($text, :$actions);
        $match.ast
    }
}

=begin pod

=head1 NAME

Text::Spintax - A parser and renderer for spintax formatted text

=head1 SYNOPSIS

=begin code :lang<raku>

use Text::Spintax;

my $node = Text::Spintax.new.parse('This {is|was|will be} some {varied|random} text');
my $text = $node.render;

=end code

=head1 DESCRIPTION

Text::Spintax implements a parser and renderer for spintax formatted
text. Spintax is a commonly used method for generating "randomized"
text. For example,

=begin output

This {is|was} a test

=end output

would be rendered as

=begin output

This is a test
This was a test

=end output

Spintax can be nested indefinitely, for example:

=begin output

This is nested {{very|quite} deeply|deep}.

=end output

would be rendered as

=begin output

This is nested very deeply.
This is nested quite deeply.
This is nested deep.

=end output

=head1 AUTHOR

Dale Evans

=head1 COPYRIGHT AND LICENSE

Copyright 2016 - 2018 Dale Evans

Copyright 2024 Elizabeth Mattijsen

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: expandtab shiftwidth=4
