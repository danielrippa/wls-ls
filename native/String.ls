
  do ->

    char = -> String.from-char-code it

    #

    concat = (string, separator = '') -> string.join separator

    split = (string, separator = '') -> string.split separator

    #

    repeat-string = (string, count) ->

      result = ''
      for til count => result += string
      result

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

    control-chars = { [ (name), (char char-code) ] for name, char-code of control-codes }

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

    take-first-chars = (string, n) ->

      if n <= 0
        string.slice 0, 0
      else
        string.slice 0, n

    drop-first-chars = (string, n) ->

      if n <= 0
        string
      else
        string.slice n

    take-last-chars = (string, n) ->

      if n <= 0
        string
      else
        string.slice -n

    drop-last-chars = (string, n) ->

      if n <= 0
        string
      else
        string.slice 0, -n

    #

    pad = (value, count, padding, fn) -> prefix = repeat-string padding, count ; prepend value, prefix |> fn

    padl = (value, count, padding = '0') -> pad value, count, padding, -> it `take-last-chars`  count
    padr = (value, count, padding = ' ') -> pad value, count, padding, -> it `take-first-chars` count

    padc = (value, count, padding = ' ') ->

      total-padding = count - "#value".length

      prefix = repeat-string padding, Math.floor (total-padding / 2)
      suffix = repeat-string padding, total-padding - prefix.length

      "#prefix#value#suffix"

    #

    left-align  = (value, n) -> value |> padl _ , n |> left _ , n

    right-align = (value, n) -> value |> padr _ , n |> right _ , n

    center-align = (value, n) -> value |> padc _ , n |> left _ , n

    contains-string = (where, what) -> ((lower-case where).index-of (lower-case what)) isnt -1

    count-chars = (string) -> string.length

    no-chars = (string) -> (count-chars string) is 0

    has-chars = (string) -> (count-chars string) isnt 0

    reverse-string = (string) -> string |> (.split '') |> (.reverse!) |> (.join '')

    { gs, rs, us, cr, lf, ff, vt } = control-chars ; crlf = "#cr#lf"

    string-as-records = (string) ->

      for separator in [ crlf, lf, cr, ff, vt ]

        loop

          break unless string `contains-string` separator
          string = string.replace separator, rs

      string

    records-as-string = (records, separator = lf) -> records |> (.split rs) |> (.join separator)

    array-as-records = (array) -> array.join rs
    records-as-array = (records) -> records.split rs

    array-as-units = (array) -> array.join us
    units-as-array = (units) -> units.split us

    array-as-groups = (array) -> array.join gs
    groups-as-array = (groups) -> groups.split gs

    #

    trimmed-is-empty = (string) -> (trim string) is ''

    #

    entity-regex = /&#(\d+);/g

      # / ... /g : denote the start and end of the regular expression
      # &# : matches the literal characters '&#' which is the beginning of a numeric character reference

      # ( : opens a capturing group. It allows to extract the number part of the entity later
      # \d+ : matches one or more digits

        # \d : is a shorthand character class that matches any digit (0-9)
        # + : is a quantifier that means "one or more of the preceding element"

      # ) : closes the capturing group

      # ; : matches the literal semicolon character, which ends a character entity

      # /g : a flag that stands for "global", to find all matches not just the first one

    char-as-entity = -> char-code = it.char-code-at 0 ; if (char-code < 32) or (char-code is 127) then "&##{char-code};" else it

    chars-as-entities = (chars) -> [ (char-as-entity character) for character in chars ]

    entity-encode = (string) -> string / '' |> chars-as-entities |> (* '')

    entity-decode = (string) -> string.replace entity-regex, (, number) -> char parse-int number, 10

    {
      char, trim,
      upper-case, lower-case,
      camel-case, kebab-case, capital-case,
      control-chars,
      string-as-words, words-as-string,
      affix, prepend, append,
      single-quotes, double-quotes,
      parens, braces, square-brackets, angle-brackets,
      padl, padr, padc,
      take-first-chars, drop-first-chars, take-last-chars, drop-last-chars,
      left-align, right-align, center-align,
      contains-string,
      repeat-string,
      reverse-string,
      string-as-records, records-as-string,
      array-as-records, records-as-array,
      array-as-units, units-as-array,
      array-as-groups, groups-as-array,
      trimmed-is-empty,
      entity-encode, entity-decode
    }
