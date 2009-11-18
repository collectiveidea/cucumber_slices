When /^I see WTF is going on/i do
  save_and_open_page
end

When "I debug" do
  debugger
  true
end