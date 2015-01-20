require 'chronic'

class AstroLogic

  attr_accessor :lines

  def generate 
    #TODO make work on linux
    lines = `9 astro  -okc 1 -C 1 2> /dev/null`.split("\n")[1..-1].select { |x| !x.match /SAO (\d+)/ }
    schedule = {}
    lines.map do |line|
      if line.match(/ at (.*)/)
        schedule = line.sub(/.* at /, '').sub(/ ...$/,'')
      else
        schedule = "now"
      end
      [Chronic.parse(schedule), line]
    end
  end
end
