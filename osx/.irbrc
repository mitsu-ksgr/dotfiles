##################################################
# IRB Config.
##################################################

require 'irb/completion'
require 'rubygems'
require 'wirble'


IRB.conf[:PROMPT_MODE] = :SIMPLE    # Simple Prompt
IRB.conf[:AUTO_INDENT_MODE] = false #
IRB.conf[:SAVE_HISTORY] = 10000     # Increase history


# Wirble Setting.
Wirble.init
Wirble.colorize


