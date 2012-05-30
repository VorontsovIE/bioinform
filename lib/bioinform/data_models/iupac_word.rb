class IupacWord
  IupacLetters = %w{A C G T  R Y K M S W  B D H V  N}
  Code = {"A" => "A", "C" => "C", "G" => "G", "T" => "T", 
        "AG" => "R", "CT" => "Y", "GT" => "K", "AC" => "M", 
        "CG" => "S", "AT" => "W", "CGT" => "B", "AGT" => "D", "ACT" => "H", "ACG" => "V", "ACGT" => "N"}
  Decode = Code.invert
  LetterCode = Hash[Decode.map{|k,v| 
    [k, %w{A C G T}.map{|chr| (v.include?(chr) ? 1.0 : 0.0) / v.size} ]
  }]
  
  attr_reader :word
  attr_accessor :weight
  def initialize(word)
    raise "Non-IUPAC letter in a word #{word}" unless word.each_char.all?{|letter| IupacLetters.include? letter}
    @word = word
    @weight = 1
  end
  
  def length
    word.length
  end

  def to_pcm
    matrix = @word.each_char.map{|letter| LetterCode[letter]}
    PositionalCountMatrix.new(matrix)
  end
end