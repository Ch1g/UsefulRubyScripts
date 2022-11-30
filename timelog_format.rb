require "csv"
require "pry"

Issue = Struct.new(:id, :title, :category, keyword_init: true)

def call
  timelog = CSV.read(ARGV.first)
  time_entries = Hash.new(Array.new)

  timelog[1..].each do |row|
    issue = parse_issue(row[4])
    comment = row[5]
    time_entries[issue] += [comment]
  end

  print standup_message(time_entries)
end

def parse_issue(cell)
  issue, title = cell.split(": ")
  category, id = issue.split(" #")

  Issue.new(
    id:       id,
    title:    title,
    category: category
  )
end

def standup_message(time_entries)
  markdown_entries_array = []

  time_entries.each do |issue, comments|
    markdown_entries_array << markdown_row(issue, comments)
  end

  markdown_entries_array.join("\n")
end

def markdown_row(issue, comments)
  standup_rows = []

  standup_rows << title_row(issue)

  comments.reverse.each do |comment|
    standup_rows << comment_row(comment)
  end

  standup_rows.join("\n")
end

def title_row(issue)
  "- [#{issue.category} ##{issue.id}](https://pm.nordicresults.com/issues/#{issue.id}): **#{issue.title}**"
end

def comment_row(comment)
  "  - [x] #{comment}"
end

call
