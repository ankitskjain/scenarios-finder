#!/usr/bin/env ruby

puts 'Please provide your local repo path till one level above the cucumber directory'
path = gets
files = Dir[path.chomp + '/cucumber/**/**/*.feature']

html_report = File.new("scenarios.html", "w+")

tag = ''

scenario = total_scenarios = total_debug = total_automated = total_manual = total_todo = total_wip = 0
main_hash = Hash['@manual' => 0 , '@todo' => 0, '@debug' => 0, '@wip' => 0 ]
files.each do |file|
  html_report.puts '<b>Checking the feature file : ' + file.split('cucumber/').last + '</b>'
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
    html_report.puts '<p> Total number of scenarios in this feature file are : ' + scenario.to_s + '</p>'
    if prev_line != ''
      html_report.puts '<p> Found ' + first_line_tags.first.to_s + ' tag at the top of the file </p>'
      html_report.puts '<p> So in this feature file ' + scenario.to_s + ' ' + first_line_tags.first.to_s + ' scenario(s) </p>'
      hash[first_line_tags.first.to_s] = scenario.to_s
      # html_report.puts hash # Uncomment if you need to debug 
      hash.each do |_k , v|
        total_tag += v.to_i
      end
    end

    hash.each do |f_tag, f_value|
      html_report.puts '<p>Which also include ' + f_value.to_s + ' ' + f_tag.to_s + ' scenario(s) </p>' if not hash.include? first_line_tags.first.to_s
    end
    if total_tag  > scenario
      html_report.puts '<p> <font size="3" color="red">More tags found than number of scenarios</font> </p>'
      naya = total_tag - scenario
      hash[first_line_tags.first.to_s] = (scenario - naya).to_s
      html_report.puts '<p> So in this feature file ' + hash[first_line_tags.first.to_s] + ' ' + first_line_tags.first.to_s + ' scenario(s) </p>'
    end
  end
  main_hash.each do |final_tag, final_count|
    main_hash[final_tag] += hash[final_tag].to_i
  end
  # html_report.puts main_hash # Uncomment if you need to debug 
end

html_report.puts '<h2>##### Final Report for ' + path.chomp + ' Repo ##### </h2>'
html_report.puts '<p> Total number of feature files are ' + files.length.to_s + '</p>'
html_report.puts '<p> Total Scenarios are ' + total_scenarios.to_s + '</p>'
main_hash.each do |final_tags, final_counts|
  html_report.puts '<p> Number of ' + final_tags + ' tags ' + final_counts.to_s + '</p>'
end

puts 'Your html report is generated with the name - scenarios.html'
