# DirectoryTreeRepl

## Script Installation

Be sure to use the correct ruby version.

[$]> `rbenv install`

## Script Usage

Press `Enter`, `Ctrl + D` To Submit And Parse Input

[$]> `ruby directories.rb`

OR

[$]> `./directories.rb`

OR

[$]> `echo 'CREATE fruits\nLIST' | ./directories.rb`

## Run Full List Of Commands

[$]> `cat test_commands.txt | ./directories.rb`

```
echo 'CREATE fruits
CREATE vegetables
CREATE grains
CREATE fruits/apples
CREATE fruits/apples/fuji
LIST
CREATE grains/squash
MOVE grains/squash vegetables
CREATE foods
MOVE grains foods
MOVE fruits foods
MOVE vegetables foods
LIST
DELETE fruits/apples
DELETE foods/fruits/apples
LIST' | ./directories.rb
```

```
./directories.rb <<- 'COMMANDS'
  CREATE fruits
  CREATE vegetables
  CREATE grains
  CREATE fruits/apples
  CREATE fruits/apples/fuji
  LIST
  CREATE grains/squash
  MOVE grains/squash vegetables
  CREATE foods
  MOVE grains foods
  MOVE fruits foods
  MOVE vegetables foods
  LIST
  DELETE fruits/apples
  DELETE foods/fruits/apples
  LIST
COMMANDS
```

## Exit Script

Type `exit`, Press `Enter`, `Ctrl + D` To Exit

You Can Also Interrupt The Script By Pressing `Ctrl + C`

## Run Tests

[$]> `bundle exec rspec`

OR

[$]> `bundle exec rspec --format documentation`

## Run Linter

[$]> `bundle exec rubocop`

[$]> `bundle exec rubocop -a`

[$]> `bundle exec rubocop -A`

## Dependencies (Ignore -- Just For Personal Reference)

[$]> `brew install rbenv`

[$]> `gem install bundler`

## Project Creation Steps (Ignore -- Just For Personal Reference)

[$]> `touch directories.rb`

[$]> `chmod 755 directories.rb`

[$]> `touch .rubocop.yml`

[$]> `rbenv local 3.3.3`

[$]> `bundle init`

[$]> `bundle add pry rspec --group 'development, test'`

[$]> `bundle add rubocop rubocop-rspec --group development`

[$]> `bundle exec rspec --init`
