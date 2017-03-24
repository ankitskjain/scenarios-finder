#!/usr/bin/env ruby

files = Dir[ARGV[0] + '/cucumber/**/**/*.feature']

tag = ''

scenario = total_scenarios = total_debug = total_automated = total_manual = total_todo = total_wip = 0
main_hash = Hash['@manual' => 0 , '@todo' => 0, '@debug' => 0, '@wip' => 0 ]
files.each do |file|
  puts '<b>Reading ' + file + '</b>'
  first_line = File.open(file).first
  hash = Hash['@manual' => 0 , '@todo' => 0, '@debug' => 0, '@wip' => 0 ]
  first_line_tags = Array.new
  prev_line = ''
  File.open(file, 'r') do |f|
    scenario = 0
    f.each_line do |line|
      scenario += 1 if line.include? 'Scenario'
      hash.each do |tag, value|
        if first_line.include? tag
          first_line_tags.insert(0,tag)
          prev_line = first_line
          #first_line = first_line.gsub(tag, '')
        elsif line.include? tag
          hash[tag] += 1
        end
      end
    end
    total_scenarios += scenario
    total_tag = 0
    naya = 0
    puts '<p> Total number of scenarios in this feature file are : ' + scenario.to_s + '</p>'
    if prev_line != ''
      puts '<p> Found ' + first_line_tags.first.to_s + ' tag at the top of the file </p>'
      puts '<p> So in this feature file ' + scenario.to_s + ' ' + first_line_tags.first.to_s + ' scenario(s) </p>'
      hash[first_line_tags.first.to_s] = scenario.to_s
      puts hash
      hash.each do |_k , v|
        total_tag += v.to_i
      end
    end
    hash.delete(first_line_tags.first.to_s)
    hash.each do |f_tag, f_value|
      puts '<p>Which also include ' + f_value.to_s + ' ' + f_tag.to_s + ' scenario(s) </p>' if not hash.include? first_line_tags.first.to_s
    end
    if total_tag  > scenario
      puts '<p> <font size="3" color="red">More tags found than number of scenarios</font> </p>'
      naya = total_tag - scenario
      hash[first_line_tags.first.to_s] = (scenario - naya).to_s
      puts '<p> So in this feature file ' + hash[first_line_tags.first.to_s] + ' ' + first_line_tags.first.to_s + ' scenario(s) </p>'
    end
  end
  main_hash.each do |final_tag, final_count|
    main_hash[final_tag] += hash[final_tag].to_i
  end
  puts main_hash
end

puts '<h2>##### Final Report for ' + ARGV[0] + ' Repo ##### </h2>'
puts '<p> Total number of feature files are ' + files.length.to_s + '</p>'
puts '<p> Total Scenarios are ' + total_scenarios.to_s + '</p>'
main_hash.each do |final_tags, final_counts|
  puts '<p> Number of ' + final_tags + ' tags ' + final_counts.to_s + '</p>'
end
