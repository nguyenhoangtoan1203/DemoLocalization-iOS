#!/usr/bin/ruby

#
#  localize.rb  
#  

COMMON_SOURCE_NAME = 'DemoLocalization'
SOURCE_NAME = 'DemoLocalization'
COMPANY_NAME = 'ToanNH9'

def validate_localizable_strings_file(string_files)
  
  puts "Validating #{string_files}..."
  
  unique_keys = Array.new()
  unique_key_value_pairs = Array.new()
  duplicated_keys = Array.new()
  
  lines = File.readlines(string_files)
  lines.each do |line|
    r = /(.*?)[\s]*?=[\s]*?(.*?);/i
    a = line.scan(r)
    a.each do |item|
      key = item[0]
      value = item[1]
      if unique_keys.include? key
        duplicated_keys << key
      else
        unique_keys << key
      end      
      unique_key_value_pairs << item unless unique_key_value_pairs.include? item
    end
  end
  
  puts 'unique_keys: ' + unique_keys.length.to_s
  puts 'unique_key_value_pairs: ' + unique_key_value_pairs.length.to_s

  if duplicated_keys.length > 0
    puts puts 'duplicated_keys: ' + duplicated_keys.to_s
  end

  if unique_keys.length == unique_key_value_pairs.length then
    return true
  else
    return false
  end
  
end

def validate_ns_localized_string_in_source()
  
  puts "Validating NSLocalizedString in all source files..."

  unique_keys = Array.new()
  unique_comments = Array.new()
  unique_key_comment_pairs = Array.new()
  
  #
  # Find key comment pairs in common source directory
  #
  Dir.glob("./#{COMMON_SOURCE_NAME}/**/*.{h,m}").each do |f|
    
    lines = File.readlines(f)
    lines.each do |line|
      r = /NSLocalizedString\(@(.*?),[\s]*?@(.*?)\)/i
      a = line.scan(r)
      a.each do |item|
        key = item[0]
        comment = item[1]
        unique_keys << key unless unique_keys.include? key
        unique_comments << comment unless unique_comments.include? comment
        unique_key_comment_pairs << item unless unique_key_comment_pairs.include? item
      end
    end
    
  end
  
  #
  # Find key comment pairs in source directory
  #
  Dir.glob("./#{SOURCE_NAME}/**/*.{h,m}").each do |f|
    
    lines = File.readlines(f)
    lines.each do |line|
      r = /NSLocalizedString\(@(.*?),[\s]*?@(.*?)\)/i
      a = line.scan(r)
      a.each do |item|
        key = item[0]
        comment = item[1]
        unique_keys << key unless unique_keys.include? key
        unique_comments << comment unless unique_comments.include? comment
        unique_key_comment_pairs << item unless unique_key_comment_pairs.include? item
      end
    end
    
  end
      
  puts 'unique_keys: ' + unique_keys.length.to_s
  puts 'unique_comments: ' + unique_comments.length.to_s
  puts 'unique_key_comment_pairs: ' + unique_key_comment_pairs.length.to_s

  unique_comments_from_unique_key_comment_pairs = Array.new()
  
  unique_key_comment_pairs.each do |item|
    key = item[0]
    comment = item[1]
    
    line = key + " = " + comment
    if unique_comments_from_unique_key_comment_pairs.include? comment
      line = key + " != "
    end
    
    unique_comments_from_unique_key_comment_pairs << comment unless unique_comments_from_unique_key_comment_pairs.include? comment
    
  end

  puts 'unique_comments_from_unique_key_comment_pairs: ' + unique_comments_from_unique_key_comment_pairs.length.to_s
  
  if unique_keys.length == unique_comments.length and unique_comments.length == unique_key_comment_pairs.length then
    return true
  else
    puts 'Duplicated keys:' + find_duplicated_keys(unique_keys, unique_key_comment_pairs).to_s
    puts 'Duplicated comments' + find_duplicated_comments(unique_comments, unique_key_comment_pairs).to_s
    return false
  end
    
end

def find_unique_keys_in_localizable_strings_file(localizable_strings_file)
  
  unique_keys = Array.new()
  
  lines = File.readlines(localizable_strings_file)
  lines.each do |line|
    r = /(.*?)[\s]*?=[\s]*?(.*?);/i
    a = line.scan(r)
    a.each do |item|
      key = item[0]
      unique_keys << key unless unique_keys.include? key
    end
  end
  
  return unique_keys
    
end

def find_unique_key_value_pairs_in_localizable_strings_file(localizable_strings_file)
  
  unique_key_value_pairs = Hash.new()
  
  lines = File.readlines(localizable_strings_file)
  lines.each do |line|
    r = /(.*?)[\s]*?=[\s]*?(.*?);/i
    a = line.scan(r)
    a.each do |item|
      key = item[0]
      value = item[1]
      unique_key_value_pairs.store(key, value) unless unique_key_value_pairs.include? key
    end
  end
  
  return unique_key_value_pairs
    
end

def find_unique_keys_in_source()

  unique_keys = Array.new()
  
  #
  # Find unique keys in common source directory
  #
  Dir.glob("./#{COMMON_SOURCE_NAME}/**/*.{h,m}").each do |f|
    
    lines = File.readlines(f)
    lines.each do |line|
      r = /NSLocalizedString\(@(.*?),[\s]*?@(.*?)\)/i
      a = line.scan(r)
      a.each do |item|
        key = item[0]
        unique_keys << key unless unique_keys.include? key
      end
    end
    
  end
  
  #
  # Find unique keys in source directory
  #
  Dir.glob("./#{SOURCE_NAME}/**/*.{h,m}").each do |f|
    
    lines = File.readlines(f)
    lines.each do |line|
      r = /NSLocalizedString\(@(.*?),[\s]*?@(.*?)\)/i
      a = line.scan(r)
      a.each do |item|
        key = item[0]
        unique_keys << key unless unique_keys.include? key
      end
    end
    
  end
  
  return unique_keys  
    
end

def find_unique_key_comment_pairs_in_source()

  unique_key_comment_pairs = Hash.new()
  
  #
  # Find unique key_comment pairs in common source directory
  #
  Dir.glob("./#{COMMON_SOURCE_NAME}/**/*.{h,m}").each do |f|
    
    lines = File.readlines(f)
    lines.each do |line|
      r = /NSLocalizedString\(@(.*?),[\s]*?@(.*?)\)/i
      a = line.scan(r)
      a.each do |item|
        key = item[0]
        comment = item[1]
        unique_key_comment_pairs.store(key, comment) unless unique_key_comment_pairs.include? key
      end
    end
    
  end
  
  #
  # Find unique key_comment pairs in source directory
  #
  Dir.glob("./#{SOURCE_NAME}/**/*.{h,m}").each do |f|
    
    lines = File.readlines(f)
    lines.each do |line|
      r = /NSLocalizedString\(@(.*?),[\s]*?@(.*?)\)/i
      a = line.scan(r)
      a.each do |item|
        key = item[0]
        comment = item[1]
        unique_key_comment_pairs.store(key, comment) unless unique_key_comment_pairs.include? key
      end
    end
    
  end
  
  return unique_key_comment_pairs  
    
end

def find_duplicated_keys(unique_keys_in_source, unique_key_comment_pairs_in_source)
  unique_keys = Array.new(unique_keys_in_source)
  duplicated_keys = Array.new()
  unique_keys_from_key_comment_pairs = Array.new()
  unique_key_comment_pairs_in_source.each do |item|
    unique_keys_from_key_comment_pairs << item[0]
    if unique_keys.include? item[0]
      unique_keys.delete(item[0])
    else
      duplicated_keys << item[0]
    end
  end
  
  File.open("/tmp/unique_keys_in_source.txt", "w+") do |f|
    unique_keys_in_source.sort.each do |item|
      f.puts item
    end
  end
  
  File.open("/tmp/unique_keys_from_key_comment_pairs_in_source.txt", "w+") do |f|
    unique_keys_from_key_comment_pairs.sort.each do |item|
      f.puts item
    end
  end
  
  return duplicated_keys
end

def find_duplicated_comments(unique_comments_in_source, unique_key_comment_pairs_in_source)
  unique_comments = Array.new(unique_comments_in_source)
  duplicated_comments = Array.new()
  unique_comments_from_key_comment_pairs = Array.new()
  unique_key_comment_pairs_in_source.each do |item|
    unique_comments_from_key_comment_pairs << item[1]
    if unique_comments.include? item[1]
      unique_comments.delete(item[1])
    else
      duplicated_comments << item[1]
    end
  end
  
  File.open("/tmp/unique_comments_in_source.txt", "w+") do |f|
    unique_comments_in_source.sort.each do |item|
      f.puts item
    end
  end
  
  File.open("/tmp/unique_comments_from_key_comment_pairs_in_source.txt", "w+") do |f|
    unique_comments_from_key_comment_pairs.sort.each do |item|
      f.puts item
    end
  end
  
  return duplicated_comments
end

def localize_lang(lang_code)
  
  strings_file = "./#{SOURCE_NAME}/#{lang_code}.lproj/Localizable.strings"
  
  if not File.file?(strings_file)
      puts 'The localized file does not exist'
      return false
  end
  
  puts '------------------------------------------------------------'

  validate_localizable_strings_file_succeeded = validate_localizable_strings_file(strings_file)
  puts ''
  if validate_localizable_strings_file_succeeded then
    puts 'SUCCEEDED'
  else
    puts 'FAILED'
  end

  puts '------------------------------------------------------------'

  validate_ns_localized_string_in_source_succeeded = validate_ns_localized_string_in_source

  puts ''
  if validate_ns_localized_string_in_source_succeeded then
    puts 'SUCCEEDED'
  else
    puts 'FAILED'
  end

  unique_keys_in_source = find_unique_keys_in_source
  unique_key_comment_pairs_in_source = find_unique_key_comment_pairs_in_source
  
  unique_keys_in_localizable_strings_file = find_unique_keys_in_localizable_strings_file(strings_file)
  unique_key_value_pairs_in_localizable_strings_file = find_unique_key_value_pairs_in_localizable_strings_file(strings_file)

  keys_in_localizable_strings_but_not_in_source = unique_keys_in_localizable_strings_file - unique_keys_in_source
  keys_in_source_but_not_in_localizable_strings = unique_keys_in_source - unique_keys_in_localizable_strings_file
  
  puts '------------------------------------------------------------'
  
  puts 'Keys in Localizable.strings are not in source files: ' + keys_in_localizable_strings_but_not_in_source.length.to_s
  puts keys_in_localizable_strings_but_not_in_source
  puts ''
  puts 'Keys in source files are not in Localizable.strings: ' + keys_in_source_but_not_in_localizable_strings.length.to_s
  puts keys_in_source_but_not_in_localizable_strings

  puts '------------------------------------------------------------'

  if validate_localizable_strings_file_succeeded and validate_ns_localized_string_in_source_succeeded then
    puts 'Generating strings and merging them into Localizable.strings...'
    puts ''

    unique_key_comment_pairs_in_source_sorted = unique_key_comment_pairs_in_source.sort

    File.open(strings_file, "w") do |f|

      basename = File.basename(strings_file)

      # licence
      f.puts("//")
      f.puts("//  #{basename}")
      f.puts("//  #{SOURCE_NAME}")
      f.puts("//")
      f.puts("//  Copyright (c) 2012 #{COMPANY_NAME}. All rights reserved.")
      f.puts("//")
      f.puts("")

      unique_key_comment_pairs_in_source_sorted.each do |key, comment|
        trimed_key = key.strip
        trimed_comment = comment.strip
        s = "/* #{trimed_comment} */"
        f.puts s.gsub(/("|")/, '')

        if unique_key_value_pairs_in_localizable_strings_file.include? key
          value = unique_key_value_pairs_in_localizable_strings_file[key]          
          trimed_value = value.strip     
          if trimed_value.empty?
            f.puts "#{trimed_key} = \"NOT_TRANSLATED_YET\";"            
          else
            f.puts "#{trimed_key} = #{trimed_value};"
          end
        else
          f.puts "#{trimed_key} = \"NOT_TRANSLATED_YET\";"
        end

        f.puts ''
      end
    end

  else
    puts 'Unable to generate strings because validation failed.'
    puts ''
  end
end

def main()
  localize_lang("Base")
  localize_lang("en")
  localize_lang("vi")
  localize_lang("ja")
end

main
