#!/usr/bin/env ruby

puts 'Please provide your local repo path till one level above the cucumber directory'
path = gets
files = Dir[path.chomp + '/cucumber/**/**/*.feature']

html_report = File.new("scenarios.html", "w+")

tag = ''

user = Array.new
puts "Tags to be searched in comma separated format?"
user = gets.chomp.split(",")
main_hash = Hash[user.map {|x| [x, 0]}]

scenario = total_scenarios = total_debug = total_automated = total_manual = total_todo = total_wip = 0
auto_hash = Hash['automated' => '0']

files.each do |file|
  # Taking each feature file
  html_report.puts '<b>Checking the feature file : ' + file.split('cucumber/').last + '</b>'
  # Reading first line of the feature file to check if we have given tags at the top
  first_line = File.open(file).first
  # Initializing variables
  hash = Hash[user.map {|x| [x, 0]}]
  first_line_tags = Array.new
  prev_line = ''
  # Reading feature files
  File.open(file, 'r') do |f|
    scenario = 0
    # Reading each line
    f.each_line do |line|
      # Increase the Scenario count as soon as we found
      scenario += 1 if line.include? 'Scenario'
      hash.each do |tag, value|
        # Checking for tag
        if first_line.include? tag
          first_line_tags.insert(0,tag)
          prev_line = first_line
          #first_line = first_line.gsub(tag, '')
        elsif line.include? tag
          # Increasing the tag count as soon as found and its dynamic as well
          hash[tag] += 1
        end
      end
    end
    total_scenarios += scenario
    total_tag = actual_tag = not_automated = 0
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
      html_report.puts '<p>But we found ' + f_value.to_s + ' ' + f_tag.to_s + ' scenario(s) </p>' if f_value.to_s != '0' and f_tag.to_s != first_line_tags.first.to_s and hash.include? first_line_tags.first.to_s
      html_report.puts '<p>Which include ' + f_value.to_s + ' ' + f_tag.to_s + ' scenario(s) </p>' if not hash.include? first_line_tags.first.to_s and f_value.to_s != '0'
    end
    if total_tag  > scenario
      html_report.puts '<p> <font size="3" color="red">That means more tags found than number of scenarios</font> </p>'
      actual_tag = total_tag - scenario
      hash[first_line_tags.first.to_s] = (scenario - actual_tag).to_s
      html_report.puts '<p> So in this feature file ' + hash[first_line_tags.first.to_s] + ' ' + first_line_tags.first.to_s + ' scenario(s) </p>'
    end
    # puts hash # Uncomment if you need to debug the hash
    # Finding automated scenatrios
    hash.each do |_k , v|
      not_automated += v.to_i
    end
    html_report.puts '<p> Total number of automated scenario(s) in this feature file are : ' + (scenario - not_automated).to_s + '</p>'
    total_automated += (scenario - not_automated).to_i
  end
  main_hash.each do |final_tag, final_count|
    main_hash[final_tag] += hash[final_tag].to_i
  end
  # html_report.puts main_hash # Uncomment if you need to debug 
end

html_report.puts '<h2>##### Final Report for ' + path.chomp + ' Repo ##### </h2>'
html_report.puts '<p> Total number of feature files are ' + files.length.to_s + '</p>'
html_report.puts '<p> Total Scenarios are ' + total_scenarios.to_s + '</p>'

# puts main_hash # Uncomment if you need to debug the hash

main_hash.each do |final_tags, final_counts|
  html_report.puts '<p> Number of ' + final_tags + ' tags ' + final_counts.to_s + '</p>'
end

html_report.puts '<p> Total automated Scenarios are ' + total_automated.to_s + '</p>'
html_report.puts '<p> Total automation coverage percent is : ' + ((total_automated.to_f/total_scenarios.to_f)*100).to_s + '</p>'
puts 'Your html report is generated, please run the command "open scenarios.html" to see the report.'
