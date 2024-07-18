
  do ->

    char = -> String.from-char-code it

    #

    concat = (string, separator = '') -> string.join separator

    split = (string, separator = '') -> string.split separator

    #

    repeat = (string, count) -> new Array count + 1 .join string

    #

    trim-regex = /^[\s]+|[\s]+$/g

      # ^[\s]+ : ^ asserts the position at the start of the line
      #        : \s matches any whitespace character one or more times (+)

      # | : acts as an alternatives separator
      #   : allows the regex to match either the pattern before or the pattern after it

      # [\s]+$ : the $ symbol asserts the position at the end of the line

      # the regex matches both leading and trailing whitespace characters

    trim = (.replace trim-regex, '')

    #

    lower-case = (.to-lower-case!)
    upper-case = (.to-upper-case!)

    #

    camel-regex = /[-_]+(.)?/g

      # [-_]+ : matches one or more occurrences of either a hyphen - or an underscore _
      #       : the square brackets [] create a character set, and the + means one or more

      # (.)? : the parentheses () create a capturing group
      #      : inside the group there is a dot . which matches any single character except a newline.
      #      : the ? after the group makes it optional, meaning it can appear zero or one time

    camel-case = (.replace camel-regex, -> upper-case &1 ? '')

    #

    dash-lower-upper = (, lower, upper) -> "#{ lower }-#{ if upper.length > 1 then upper else lcase upper }"

    dash-upper = (, upper) -> if upper.length > 1 then "#upper-" else lower-case upper

    upper-lower-regex = /([^-A-Z])([A-Z]+)/g

    replace-upper-lower = (.replace upper-lower-regex, dash-lower-upper)

    upper-regex = /^([A-Z]+)/

    replace-upper = (.replace upper-regex, dash-upper)

    kebab-case = -> it |> replace-upper-lower |> replace-upper

    #

    capital-regex = /\b\w/g

      # \b : matches a position where a word boundary occurs
      #    : it does not match an actual character, it identifies a position between characters
      #    : matches the transition from a word character (such as letters, digits, underscores) to a non-word character
      #    : matches the transition from a non-word character to a word-character

      # \w : represents a word character
      #    : matches letters (both uppercase and lowercase), digits, underscores

      # together they match all word boundaries followed by word characters

    capital-case = (.replace capital-regex, upper-case)

    #

    words-regex = /[ ]+/

    string-as-words = ->

      switch it.length

        | 0 => []

        else it.split words-regex

    words-as-string = (.join ' ')

    #

    # https://en.wikipedia.org/wiki/C0_and_C1_control_codes

    c0-control-codes = { [ name, char-code ] for name, char-code in <[ nul soh stx etx eot enq ack bel bs ht lf vt ff cr so si dle dc1 dc2 dc3 dc4 nak syn etb can em sub esc fs gs rs us sp ]> }

    c1-control-codes = { [ name, char-code + 127 ] for name, char-code in <[ del pad hop bph nbh ind nel ssa esa hts htj vts pld plu ri ss2 ss3 dcs pu1 pu2 sts cch mw spa epa sos sgc sci csi st osc pm apc ]> }

    control-codes = {} <<< c0-control-codes <<< c1-control-codes

    control-chars = { [ (name), (char code) ] for name, code of control-codes }

    #

    affix = (stem, prefix = '', suffix = prefix) -> "#prefix#stem#suffix"

    prepend = (stem, prefix) -> affix stem, prefix, ''
    append  = (stem, suffix) -> affix stem, '', suffix

    #

    quote-chars =

      single: "'"
      double: '"'

    single-quotes = -> affix it, quote-chars.single
    double-quotes = -> affix it, quote-chars.double

    parens = -> affix it, '(', ')'
    braces = -> affix it, '{', '}'

    square-brackets = -> affix it, '[', ']'
    angle-brackets  = -> affix it, '<', '>'

    #

    first = (string, n = 1) -> string.slice 0, n
    last = (string, n = 1) -> string.slice -n

    #

    pad = (value, count, padding, fn) -> prefix = repeat padding, count ; prepend value, prefix |> fn

    padl = (value, count, padding = '0') -> pad value, count, padding, -> it `last` count
    padr = (value, count, padding = ' ') -> pad value, count, padding, -> it `first` count

    #


    {
      char, trim,
      upper-case, lower-case,
      camel-case, kebab-case, capital-case,
      control-chars,
      string-as-words, words-as-string,
      affix, prepend, append,
      single-quotes, double-quotes,
      parens, braces, square-brackets, angle-brackets,
      first, last,
      padl, padr
    }
