This gem is in very early stage and not yet documented. If you're interested in learning how it works or even contributing to it, please get in touch by creating an issue.

# Installation

0. Add to bundle: `gem 'albus', git: 'https://github.com/kalsan/albus.git'`
0. `rails g albus:install`, then run `rails db:migrate`
0. Create a model `astep.rb` with the content `include Albus::AstepMixin`