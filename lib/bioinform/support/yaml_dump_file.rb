require 'yaml'

def YAML.dump_file(obj,filename)
  File.open(filename, 'w'){|f| YAML.dump(obj,f)}
end