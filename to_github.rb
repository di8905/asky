loop do
  print 'comment>> '
  com = gets.chomp
  if com == 'exit'
    exit
  else
    puts `git status`
    puts `git add .`
    puts `git commit -m "#{com}"`
    puts `git push`
  end
end
