#!/usr/bin/env ruby
files = Dir[ARGV[0] + '/cucumber/**/**/*.feature']
tag = first_line_tags = ''
total_scenarios = 0
total_debug = total_automated = total_manual = total_todo = total_wip = 0
files.each do |file|
  puts '<b>Reading ' + file + '</b>'
  first_line = File.open(file).first
  File.open(file, 'r') do |f|
    smoke = debug = wip = todo = manual = scenario = 0
    f.each_line do |line|
      scenario += 1 if line.include? 'Scenario'
      smoke += 1 if line.include? '@smoke'
      if first_line.include? '@manual'
        tag = 'manual_tag'
        first_line_tags = first_line
        first_line = first_line.gsub('@manual', '')
      elsif line.include? '@manual'
        manual += 1
      end

      if first_line.include? '@wip'
        tag = 'wip_tag'
        first_line_tags = first_line
        first_line = first_line.gsub('@wip', '')
      elsif line.include? '@wip'
        wip += 1
      end

      if first_line.include? '@todo'
        tag = 'todo_tag'
        first_line_tags = first_line
        first_line = first_line.gsub('@todo', '')
      elsif line.include? '@todo'
        todo += 1
      end

      if first_line.include? '@debug'
        tag = 'debug_tag'
        first_line_tags = first_line
        first_line = first_line.gsub('@debug', '')
      elsif line.include? '@debug'
        debug += 1
      end
    end
    total_scenarios += scenario
    puts '<p> Total number of scenarios in this feature file are : ' + scenario.to_s + '</p>'
    if first_line_tags.include? '@'
      puts '<p> ' + first_line_tags + ' tag is available at the top of the file </p>'
    end
    puts '<p>Which include ' + todo.to_s + ' todo scenario(s) </p>' if not tag.include? 'todo'
    if tag.include? 'todo'
      puts '<p>Which found ' + scenario.to_s + ' todo scenario(s) </p>'
      todo = scenario
      tag = ''
    end

    puts '<p> ' + wip.to_s + ' wip scenario(s) </p>' if not tag.include? 'wip'
    if tag.include? 'wip'
      puts '<p> ' + scenario.to_s + ' wip scenario(s) </p>' 
      wip = scenario
      tag = ''
    end

    puts '<p> ' + debug.to_s + ' debug scenario(s) </p>' if not tag.include? 'debug'
    if tag.include? 'debug'
      puts '<p> ' + scenario.to_s + ' debug scenario(s) </p>'
      debug = scenario
      tag = ''
    end

    puts '<p>And ' + manual.to_s + ' manual scenario(s) </p>' if not tag.include? 'manual'
    if tag.include? 'manual'
      puts '<p>And ' + scenario.to_s + ' manual scenario(s) </p>'
      manual = scenario
      tag = ''
    end

    automated = (scenario - (manual + wip + todo + debug))
    if automated.to_s.include? '-'
      puts '<p> <font size="3" color="red">More tags found than number of scenarios</font> </p>'
      todo += automated and puts '<p> new count for todo tag is ' + todo.to_s + '</p>' if first_line_tags.include? 'todo'
      wip += automated and puts '<p> new count for wip tag is ' + wip.to_s + '</p>' if first_line_tags.include? 'wip'
      debug += automated and puts '<p> new count for debug tag is ' + debug.to_s + '</p>' if first_line_tags.include? 'debug'
      manual += automated and puts '<p> new count for manual tag is ' + manual.to_s + '</p>' if first_line_tags.include? 'manual'
      first_line_tags = ''
      automated = 0
    end
    total_automated += automated
    puts '<p> Which results ' + automated.to_s + ' automated scenario(s) in this file </p>'

    total_manual += manual
    total_wip += wip
    total_todo += todo
    total_debug += debug
  end
end
puts '<h2>##### Final Report for ' + ARGV[0] + ' Repo ##### </h2>'
puts '<p> Total number of feature files are ' + files.length.to_s + '</p>'
puts '<p> Total Scenarios are ' + total_scenarios.to_s + '</p>'
puts '<p> Total number of automated are ' + total_automated.to_s + '</p>'
puts '<p> Total number of manual scenarios are ' + total_manual.to_s + '</p>'
puts '<p> Total number of todo scenarios are ' + total_todo.to_s + '</p>'
puts '<p> Total number of debug scenarios are ' + total_debug.to_s + '</p>'
puts '<p> Total number of wip scenarios are ' + total_wip.to_s + '</p>'
