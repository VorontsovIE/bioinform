# Parsers should be included after PM class defined - in order it could catch definitions of new classes

require 'bioinform/data_models/parsers/array_parser'
require 'bioinform/data_models/parsers/hash_parser'
require 'bioinform/data_models/parsers/string_parser'
require 'bioinform/data_models/parsers/string_fantom_parser'
