require "rails_helper"

describe "Adding todo items" do
  let!(:todo_list) {TodoList.create(title: "Grocery list",description: "Grocieries")}
  
  def visit_todo_list(list)
    visit "/todo_lists"
    within "#todo_list_#{todo_list.id}" do
      click_link "List Items"
    end  
  end
  
  it "is successful with valid content" do
    visit_todo_list(todo_list)
    click_link "New Todo Item"
    fill_in "Content",with: "Milk"
    click_button "Save"
    expect(page).to(have_content("Added todo list item."))
    within("ul.todo_items") do
      expect(page).to(have_content("Milk"))
    end
  end
  
  it "displays an error with no content" do
    visit_todo_list(todo_list)
    click_link "New Todo Item"
    fill_in "Content", with: ""
    click_button "Save"
    within("div#error_explanation") do
      expect(page).to(have_content("prohibited this todo item from being saved:"))
    end
    expect(page).to(have_content("Content can't be blank"))
  end
  
  it "displays an error with content less than 2 characters" do
    visit_todo_list(todo_list)
    click_link "New Todo Item"
    fill_in "Content", with: "a"
    click_button "Save"
    within("div#error_explanation") do
      expect(page).to(have_content("prohibited this todo item from being saved:"))
    end
    expect(page).to(have_content("Content is too short (minimum is 2 characters)"))
  end
 
end